import http.server
import socketserver
import json
import subprocess

# Mock function to fetch values
def fetch_value(key):
    print(f"Fetching {key}")
    return f"{key} value"

# Mock function to generate random data
def generate_random_data():
    print("Generating random data")
    return {"altitude": "Mock Altitude", "battery": "Mock Battery", "status": "Mock Status"}

# Mock function for pose
pose = {"x": 0, "y": 0, "z": 0}

class RequestHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == '/altitude':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"altitude": fetch_value("Altitude")})
            self.wfile.write(response.encode())
        
        elif self.path == '/battery':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"battery": fetch_value("Battery")})
            self.wfile.write(response.encode())
        
        elif self.path == '/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"status": fetch_value("Status")})
            self.wfile.write(response.encode())

        elif self.path == '/drone_telemetry':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps(generate_random_data())
            self.wfile.write(response.encode())

        elif self.path == '/get_current_ip':
            try:
                ip = subprocess.check_output(['hostname', '-I']).decode('utf-8').strip()
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                response = json.dumps({"ip_address": ip})
                self.wfile.write(response.encode())
            except subprocess.CalledProcessError as e:
                self.send_response(500)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                response = json.dumps({"error": "Unable to get IP address", "details": str(e)})
                self.wfile.write(response.encode())

        elif self.path == '/get_pose':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"x": pose["x"], "y": pose["y"], "z": pose["z"]})
            self.wfile.write(response.encode())

        elif self.path == '/stop' or self.path == '/rtl' or self.path == '/takeoff':
            status_messages = {
                '/stop': "Drone stopped",
                '/rtl': "Returning to launch",
                '/takeoff': "Taking off"
            }
            status_message = status_messages.get(self.path, "Unknown command")
            
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"status": status_message})
            print(f"Command: {self.path}")
            print(f"Status: {status_message}")
            
            self.wfile.write(response.encode())

        else:
            self.send_response(404)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'Not Found')

    def do_POST(self):
        if self.path == '/move':
            content_length = int(self.headers['Content-Length'])
            post_body = self.rfile.read(content_length).decode('utf-8')
            
            try:
                data = json.loads(post_body)
                direction = data.get('direction')
                
                if direction not in ['forward', 'backward', 'left', 'right', 'up', 'down']:
                    self.send_response(400)
                    self.send_header('Content-type', 'application/json')
                    self.end_headers()
                    response = json.dumps({"error": "Invalid direction. Must be forward, backward, left, right, up, or down."})
                    self.wfile.write(response.encode())
                else:
                    print(f"Moving {direction}")
                    
                    self.send_response(200)
                    self.send_header('Content-type', 'application/json')
                    self.end_headers()
                    response = json.dumps({"status": f"Moving {direction}"})
                    
                    self.wfile.write(response.encode())
            except json.JSONDecodeError:
                self.send_response(400)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                response = json.dumps({"error": "Invalid JSON payload"})
                
                self.wfile.write(response.encode())

def run_server(host="localhost", port=5000):
    with socketserver.TCPServer((host, port), RequestHandler) as httpd:
        print(f"Running server on {host=} {port=}")
        httpd.serve_forever()

if __name__ == "__main__":
    run_server()