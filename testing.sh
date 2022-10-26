#!/bin/bash

#In order to launch testing, you should have locust installed on your computer

cd docker;
sudo docker-compose up -d;
echo "Containers have been deployed";
echo "Waiting for 10s"
sleep 10;
locust -f ../locustest.py --headless --host http://localhost:8080 -u 1000 -r 100 --run-time 100 --stop-timeout 3 --only-summary;
echo "last 100s on cat1, cat2 and cat3:";
sudo docker-compose logs --since 100s | grep cat1 | wc -l;
sudo docker-compose logs --since 100s | grep cat2 | wc -l;
sudo docker-compose logs --since 100s | grep cat3 | wc -l;
echo "through the whole test accumulated on cat1:";
sudo docker-compose logs | grep cat1 | wc -l;

echo "Stopping cat2 container...";
sudo docker-compose stop cat2;
echo "Waiting for 10s";
sleep 10;
locust -f ../locustest.py --headless --host http://localhost:8080 -u 1000 -r 100 --run-time 100 --stop-timeout 3 --only-summary;
echo "last 100s on cat1, cat2 and cat3 accordingly:";
sudo docker-compose logs --since 100s | grep cat1 | wc -l;
sudo docker-compose logs --since 100s | grep cat2 | wc -l;
sudo docker-compose logs --since 100s | grep cat3 | wc -l;
echo "through the whole test accumulated on cat1:";
sudo docker-compose logs | grep cat1 | wc -l;

echo "restarting cat2...";
sudo docker-compose start cat2;
sudo docker-compose exec loadbalancer touch /app/restart
echo "Waiting for 10s";
sleep 10;
locust -f ../locustest.py --headless --host http://localhost:8080 -u 1000 -r 100 --run-time 100 --stop-timeout 3 --only-summary;
echo "last 100s on cat1, cat2 and cat3 accordingly:";
sudo docker-compose logs --since 100s | grep cat1 | wc -l;
sudo docker-compose logs --since 100s | grep cat2 | wc -l;
sudo docker-compose logs --since 100s | grep cat3 | wc -l;
echo "through the whole test accumulated on cat1:";
sudo docker-compose logs | grep cat1 | wc -l;

sudo docker-compose down;