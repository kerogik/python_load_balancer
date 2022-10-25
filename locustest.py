import resource
from locust import HttpUser, task, between

resource.setrlimit(resource.RLIMIT_NOFILE, (999999, 999999))

class WebsiteUser(HttpUser):
    
    wait_time = between(1,3)
    
    @task
    def index(l):
        l.client.get("/")

    @task
    def get_cat(l):
        l.client.get("/cat")

    @task
    def get_dog(l):
        l.client.get("/dog")
    
    @task
    def get_mouse(l):
        l.client.get("/mouse")

    @task
    def get_fish(l):
        l.client.get("/fish")
