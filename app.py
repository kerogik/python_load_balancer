from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def sample():
    return "this is the {} service".format(os.environ["APP"])

if __name__ == "__main__":
    app.run(host="0.0.0.0")