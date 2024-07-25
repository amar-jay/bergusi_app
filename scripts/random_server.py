from flask import Flask, jsonify
import random

app = Flask(__name__)

def generate_longitude():
    return f"{random.uniform(-180.0, 180.0):.6f}°"

def generate_latitude():
    return f"{random.uniform(-90.0, 90.0):.6f}°"

def generate_altitude():
    return f"{random.uniform(0.0, 10000.0):.2f} m"

def generate_speed():
    return f"{random.uniform(0.0, 50.0):.2f} m/s"

def generate_battery():
    return f"{random.uniform(0.0, 100.0):.1f}%"

def generate_status():
    return "Status: Connected" if random.choice([True, False]) else "Status: Disconnected"

@app.route('/longitude', methods=['GET'])
def get_longitude():
    return jsonify({"Longitude": generate_longitude()})

@app.route('/latitude', methods=['GET'])
def get_latitude():
    return jsonify({"Latitude": generate_latitude()})

@app.route('/altitude', methods=['GET'])
def get_altitude():
    return jsonify({"Altitude": generate_altitude()})

@app.route('/speed', methods=['GET'])
def get_speed():
    return jsonify({"Speed": generate_speed()})

@app.route('/battery', methods=['GET'])
def get_battery():
    return jsonify({"Battery": generate_battery()})

@app.route('/status', methods=['GET'])
def get_status():
    return jsonify({"Status": generate_status()})

@app.route('/drone_status', methods=['GET'])
def get_drone_status():
    return jsonify({
        "Longitude": generate_longitude(),
        "Latitude": generate_latitude(),
        "Altitude": generate_altitude(),
        "Speed": generate_speed(),
        "Battery": generate_battery(),
        "Status": generate_status()
    })

if __name__ == '__main__':
    app.run(debug=True)
