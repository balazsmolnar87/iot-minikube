#!/bin/sh

# Start Mosquitto broker in the background
mosquitto -c /mosquitto/config/mosquitto.conf &

# Wait for the broker to start
sleep 2

# Subscribe to the topic and log messages to a file
mosquitto_sub -h localhost -t test/topic -v > /mosquitto/log/subscribed_messages.log &

# Keep the container running
tail -f /dev/null
