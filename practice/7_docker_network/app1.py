from flask import Flask, request
import requests

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "hello Web1"

@app.route('/communicate')
def communicate():
    response = requests.get('http://web2:5001')
    return f"Web1 recived response from Web2: {response.text}"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)