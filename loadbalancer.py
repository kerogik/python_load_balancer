from itertools import cycle
from flask import Flask
import requests, os
import yaml

loadbalancer = Flask(__name__)

def load_configuration(path):
    with open(path) as config_file:
        config = yaml.load(config_file, Loader=yaml.FullLoader)
    for entry in config["paths"]:
        entry["servers"] = cycle(entry["servers"])
    return config

config = load_configuration('/app/loadbalancer.yml')

def round_robin(iter):
    return next(iter)

def reload_cycle_skip(gen, value):
    for el in gen:
        if el == value:
            continue
        yield el

def try_redirect(entry):
    try:
        chosen = round_robin(entry["servers"])
        response = requests.get("http://{}".format(chosen))
        return response.content, response.status_code
    except:
        entry["servers"] = reload_cycle_skip(entry["servers"], chosen)   
        return try_redirect(entry)

@loadbalancer.route('/')
def landing():
    return "this is the {} service".format(os.environ["APP"])

@loadbalancer.route('/<path>')
def path_router(path):
    global config
    if os.path.isfile("/app/restart"):
        config = load_configuration("/app/loadbalancer.yml")
        os.remove("/app/restart")
    for entry in config["paths"]:
        if ("/"+path) == entry["path"]:
            return try_redirect(entry)
    return "Not Found", 404

if __name__ == "__main__":
    loadbalancer.run(host="0.0.0.0")