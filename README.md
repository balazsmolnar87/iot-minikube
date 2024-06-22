# IoT-minikube
Local Kubernetes pet project to receive IoT sensor data and display it in Grafana

# Setting up workspace on my Windows PC
Setting Up WSL 2 & Docker Desktop

[https://minikube.sigs.k8s.io/docs/tutorials/wsl_docker_driver/](https://minikube.sigs.k8s.io/docs/tutorials/wsl_docker_driver/)

minikube start

[https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)

Set Up Mosquitto MQTT Broker on Your PC

[https://mosquitto.org/download/](https://mosquitto.org/download/)

wsl
sudo apt-get update
sudo apt-get install mosquitto mosquitto-clients
mosquitto

# Test

mosquitto_sub -h localhost -t test/topic

In another terminal

mosquitto_pub -h localhost -t test/topic -m "Hello MQTT"

# Let's run Mosquitto in docker
```
mkdir mosquitto

cd mosquitto

docker pull eclipse-mosquitto
```

# Run the Mosquitto container with the default configuration:

docker run -d --name mosquitto -p 1883:1883 -p 9001:9001 eclipse-mosquitto

Well, it runs, but I need to subscribe to a topic so I can check if messages arrive.

# Created mosquitto folder, now create Dockerfile and the config
Create Dockerfile:
```
vi Dockerfile
```
Inside:
```
# Use the official Mosquitto image from Docker Hub
FROM eclipse-mosquitto

# Expose MQTT port
EXPOSE 1883

# Copy your custom configuration file if needed
COPY config/mosquitto.conf /mosquitto/config/mosquitto.conf
```
Create config folder and config file
```
mkdir config
cd config
vi mosquitto.conf
cd ..
```
Inside:
```
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log

listener 1883

allow_anonymous true
```

# Build the Custom Docker Image
```
docker build -t custom-mosquitto .
```
# Create folders for data and log 
```
mkdir data
mkdir log
```
# Run custom container

```
docker run -d -p 1883:1883 --name my-mosquitto-container my-mosquitto-image
```

I can post messages to the broker and also subscribe to it so I can get the messages. 
