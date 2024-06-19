# Use the official Eclipse Mosquitto image as the base
FROM eclipse-mosquitto:latest

# Add a script to run when the container starts
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Override the default command
CMD ["/usr/local/bin/start.sh"]
