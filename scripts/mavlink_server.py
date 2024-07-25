from flask import Flask, request, jsonify, url_for
import random
import multiprocessing
import time
from pymavlink import mavutil

app = Flask(__name__)

# Global variables to store drone telemetry data
drone_data = {
    "Distance_X": 0.0,
    "Distance_Y": 0.0,
    "Distance_Z": 0.0,
    "Roll": 0.0,
    "Pitch": 0.0,
    "Yaw": 0.0,
    "Altitude": 0.0,
    "Battery": 0.0,
    "Velocity_X": 0.0,
    "Velocity_Y": 0.0,
    "Velocity_Z": 0.0,
    "Acceleration_X": 0.0,
    "Acceleration_Y": 0.0,
    "Acceleration_Z": 0.0,
    "Roll_Rate": 0.0,
    "Pitch_Rate": 0.0,
    "Yaw_Rate": 0.0,
    "Temperature": 0.0,
    "Status": "Disconnected"
}

is_connected = False
current_ip = 'udp:127.0.0.1:14550'


# Mutex lock for thread-safe read/write operations
data_lock = multiprocessing.Lock()

drone_thread = None
drone_thread_lock = multiprocessing.Lock()
drone_thread_stop = multiprocessing.Event()


# Function to connect to the drone and update telemetry data
def connect_to_drone(ip_address = 'udp:127.0.0.1:14550'):
    global drone_data, is_connected
    if drone_thread_stop.is_set():
        raise Exception("Cannot start thread, thread already running")
    try:
        master = mavutil.mavlink_connection(ip_address)  # Adjust connection string as needed
        master.wait_heartbeat()
    except:
        raise Exception("Cannot start thread, error initializing")

    # Initialize previous time and velocity
    prev_time = time.time()
    prev_vx, prev_vy, prev_vz = 0.0, 0.0, 0.0

    while not drone_thread_stop.is_set():
        msg = master.recv_match(blocking=True)
        if not msg:
            continue

        current_time = time.time()
        dt = current_time - prev_time

        with data_lock:
            if msg.get_type() == 'HEARTBEAT':
                is_connected = True
                drone_data["Status"] = "Connected"
            elif msg.get_type() == 'ATTITUDE':
                drone_data["Roll"] = msg.roll
                drone_data["Pitch"] = msg.pitch
                drone_data["Yaw"] = msg.yaw
                drone_data["Roll_Rate"] = msg.rollspeed
                drone_data["Pitch_Rate"] = msg.pitchspeed
                drone_data["Yaw_Rate"] = msg.yawspeed
            elif msg.get_type() == 'GLOBAL_POSITION_INT':
                drone_data["Altitude"] = msg.relative_alt / 1000.0  # Altitude in meters
            elif msg.get_type() == 'VFR_HUD':
                vx = msg.groundspeed * 100  # Convert to cm/s if needed
                vy = msg.airspeed * 100  # Assuming airspeed is lateral speed, adjust as needed
                vz = msg.climb * 100  # Vertical speed in cm/s

                drone_data["Velocity_X"] = vx
                drone_data["Velocity_Y"] = vy
                drone_data["Velocity_Z"] = vz

                drone_data["Distance_X"] += prev_vx * dt
                drone_data["Distance_Y"] += prev_vy * dt
                drone_data["Distance_Z"] += prev_vz * dt

                prev_vx, prev_vy, prev_vz = vx, vy, vz
                prev_time = current_time
            elif msg.get_type() == 'SYS_STATUS':
                drone_data["Battery"] = msg.battery_remaining
            elif msg.get_type() == 'RAW_IMU':
                drone_data["Acceleration_X"] = msg.xacc
                drone_data["Acceleration_Y"] = msg.yacc
                drone_data["Acceleration_Z"] = msg.zacc
                drone_data["Temperature"] = msg.temperature  # Assuming temperature in RAW_IMU message, adjust as needed
            
        time.sleep(0.1)

# Function to start the drone connection thread
def start_drone_thread(ip_address):
    with drone_thread_lock:
        print("Starting drone thread")
        global drone_thread, drone_thread_stop
        drone_thread_stop.clear()
        try:
            drone_thread = multiprocessing.Process(target=connect_to_drone, args=(ip_address,))
            drone_thread.start()
        except:
            raise Exception("Cannot connect to drone")

# Function to stop the drone connection thread
def stop_drone_thread():
    with drone_thread_lock:
        global drone_thread_stop, drone_thread
        drone_thread_stop.set()
        if drone_thread is not None:
            drone_thread.terminate()
            print("Drone thread killed")
        else:
            print("Cannot access thread since its empty")

start_drone_thread(current_ip)

# Start a separate thread to connect to the drone and update data
# drone_thread = threading.Thread(target=connect_to_drone)
# drone_thread.start()


def generate_random_data():
    return {
        "Distance_X": random.uniform(0.0, 1000.0),
        "Distance_Y": random.uniform(0.0, 1000.0),
        "Distance_Z": random.uniform(0.0, 1000.0),
        "Roll": random.uniform(-180.0, 180.0),
        "Pitch": random.uniform(-90.0, 90.0),
        "Yaw": random.uniform(-180.0, 180.0),
        "Altitude": random.uniform(0.0, 500.0),
        "Battery": random.uniform(0.0, 100.0),
        "Velocity_X": random.uniform(-100.0, 100.0),
        "Velocity_Y": random.uniform(-100.0, 100.0),
        "Velocity_Z": random.uniform(-100.0, 100.0),
        "Acceleration_X": random.uniform(-10.0, 10.0),
        "Acceleration_Y": random.uniform(-10.0, 10.0),
        "Acceleration_Z": random.uniform(-10.0, 10.0),
        "Roll_Rate": random.uniform(-10.0, 10.0),
        "Pitch_Rate": random.uniform(-10.0, 10.0),
        "Yaw_Rate": random.uniform(-10.0, 10.0),
        "Temperature": random.uniform(-20.0, 50.0),
        "Status": "Disconnected"
    }


def fetch_value(value, units = ""):
    with data_lock:
        return jsonify({f"{value}": f"{drone_data[value] if is_connected else generate_random_data()[value]:.2f}{(' ' + units) if units else ''}"}) 

# Flask routes to get drone telemetry data
@app.route('/distance_x', methods=['GET'])
def get_distance_x():
    return fetch_value("Distance_X", "cm")

@app.route('/distance_y', methods=['GET'])
def get_distance_y():
    return fetch_value("Distance_Y", "cm")


@app.route('/distance_z', methods=['GET'])
def get_distance_z():
    return fetch_value("Distance_Z", "cm")

@app.route('/roll', methods=['GET'])
def get_roll():
    return fetch_value("Roll")

@app.route('/pitch', methods=['GET'])
def get_pitch():
    return fetch_value("Pitch")

@app.route('/yaw', methods=['GET'])
def get_yaw():
    return fetch_value("Yaw")

@app.route('/altitude', methods=['GET'])
def get_altitude():
    return fetch_value("Altitude")

@app.route('/battery', methods=['GET'])
def get_battery():
    return fetch_value("Battery")

@app.route('/velocity_x', methods=['GET'])
def get_velocity_x():
    return fetch_value("Velocity_X")

@app.route('/velocity_y', methods=['GET'])
def get_velocity_y():
    return fetch_value("Velocity_Y")

@app.route('/velocity_z', methods=['GET'])
def get_velocity_z():
    return fetch_value("Velocity_Z")

@app.route('/acceleration_x', methods=['GET'])
def get_acceleration_x():
    return fetch_value("Acceleration_X")

@app.route('/acceleration_y', methods=['GET'])
def get_acceleration_y():
    return fetch_value("Acceleration_Y")

@app.route('/acceleration_z', methods=['GET'])
def get_acceleration_z():
    return fetch_value("Acceleration_Z")

@app.route('/roll_rate', methods=['GET'])
def get_roll_rate():
    return fetch_value("Roll_Rate")

@app.route('/pitch_rate', methods=['GET'])
def get_pitch_rate():
    return fetch_value("Pitch_Rate")

@app.route('/yaw_rate', methods=['GET'])
def get_yaw_rate():
    return fetch_value("Yaw_Rate")

@app.route('/temperature', methods=['GET'])
def get_temperature():
    return fetch_value("Temperature")

@app.route('/status', methods=['GET'])
def get_status():
    return fetch_value("Status")

@app.route('/drone_telemetry', methods=['GET'])
def get_drone_telemetry():
    with data_lock:
        return jsonify(drone_data if is_connected else generate_random_data())

@app.route('/update_ip', methods=['GET'])
def update_ip():
    global current_ip
    new_ip = request.args.get('ip', "")
    if not new_ip:
        return jsonify({"error": "No IP address provided"}), 400
    print(new_ip)

    # Update the IP address and restart the drone connection thread
    with data_lock:
        stop_drone_thread()
        current_ip = new_ip
        start_drone_thread(current_ip)
        return jsonify({"message": "IP address updated.", "new_ip": current_ip})



if __name__ == '__main__':
    app.run(debug=False)

