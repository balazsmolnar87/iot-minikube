# IoT-minikube
Local Kubernetes to receive IoT sensor data and display it in Grafana

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

docker pull eclipse-mosquitto

# Run the Mosquitto container with the default configuration:

docker run -d --name mosquitto -p 1883:1883 -p 9001:9001 eclipse-mosquitto

Well, it runs, but I need to subscribe to a topic so I can check if messages arrive.

# Created mosquitto folder

Dockerfile

```
# Use the official Eclipse Mosquitto image as the base
FROM eclipse-mosquitto:latest

# Add a script to run when the container starts
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Override the default command
CMD ["/usr/local/bin/start.sh"]
```

start.sh

```
#!/bin/sh

# Start Mosquitto broker in the background
mosquitto -c /mosquitto/config/mosquitto.conf &

# Wait for the broker to start
sleep 2

# Subscribe to the topic and log messages to a file
mosquitto_sub -h localhost -t test/topic -v > /mosquitto/log/subscribed_messages.log &

# Keep the container running
tail -f /dev/null
```

# Build the Custom Docker Image

docker build -t custom-mosquitto .

# Create folders and config 

mkdir -p ./config
mkdir -p ./data
mkdir -p ./log

nano ./config/mosquitto.conf

# Run custom container

```
docker run -d --name custom-mosquitto -p 1883:1883 -p 9001:9001 \
  -v ./config:/mosquitto/config \
  -v ./data:/mosquitto/data \
  -v ./log:/mosquitto/log \
  custom-mosquitto
```

