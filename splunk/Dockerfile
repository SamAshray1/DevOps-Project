FROM splunk/universalforwarder:9.3.4
# Set environment variables for Splunk admin credentials
ENV SPLUNK_START_ARGS="--accept-license"
ENV SPLUNK_USER=root
ENV SPLUNK_HOME="/opt/splunkforwarder"
# ENV SPLUNK_CMD="/opt/splunkforwarder/bin/splunk status"
ENV SPLUNK_PASSWORD="root"

# Copy Splunk configuration files
COPY inputs.conf /opt/splunkforwarder/etc/system/local/inputs.conf
COPY outputs.conf /opt/splunkforwarder/etc/system/local/outputs.conf

# Expose necessary ports (e.g., default Splunk forwarding port)
EXPOSE 9997

# Start Splunk Universal Forwarder
CMD ["/opt/splunkforwarder/bin/splunk", "start", "--accept-license", "--answer-yes", "--no-prompt", "--nodaemon"]
# CMD ["sh", "-c", "while true; do sleep 30; done"]