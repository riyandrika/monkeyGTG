import socket
import json
from firebase_rtdb import rtdb
import winsound

PORT = 8000
HOST_IP = socket.gethostbyname(socket.gethostname())
ADDRESS = (HOST_IP, PORT)
CHUNK = 1024

FREQ = 4000
DURATION = 5000

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("", PORT))
print(f"Socket created at port {PORT}")
s.listen(1)
print(f"Waiting for connection at port {PORT}")
conn, addr = s.accept()
print(f"{addr[0]} connected to server")

data = conn.recv(CHUNK)
data = json.loads(data)
print(f"Pushing {data} to DB")
rtdb.child("Data").push(data = data) # data.keys = [time, location, lat, long]

winsound.Beep(frequency = FREQ, duration = DURATION)