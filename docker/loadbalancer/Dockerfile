FROM python:3

RUN pip install flask requests pyyaml

COPY ./loadbalancer.py /app/loadbalancer.py

COPY ./loadbalancer.yml /app/loadbalancer.yml

CMD ["python", "/app/loadbalancer.py"]
