from flask import Flask
import time

app = Flask(__name__)

def compute_fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a

@app.route("/")
def home():
    return "Hello World! from HIMANSH SHARMA"

@app.route("/compute")
def heavy_task():
    start_time = time.time()
    _ = compute_fibonacci(10000)
    duration = time.time() - start_time
    return f"Done in {duration:.2f}s"
