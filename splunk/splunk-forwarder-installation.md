## Splunk Forwarder Installation Steps for Ubuntu x64

wget -O splunkforwarder-9.4.1-e3bdab203ac8-linux-amd64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.4.1/linux/splunkforwarder-9.4.1-e3bdab203ac8-linux-amd64.tgz"

tar -xvf splunkforwarder-9.4.1-e3bdab203ac8-linux-amd64.tgz

sudo mv splunkforwarder /opt/splunkforwarder

sudo /opt/splunkforwarder/bin/splunk enable boot-start

/opt/splunkforwarder/bin/splunk add forward-server hostname:9997

/opt/splunkforwarder/bin/splunk restart

Test Forwarder connection:
/opt/splunkforwarder/bin/splunk list forward-server

Add Data:
/opt/splunkforwarder/bin/splunk add monitor /path/to/app/logs/ -index main -sourcetype %app% 


# Links to read up on
https://hub.docker.com/r/splunk/universalforwarder
https://docs.splunk.com/Documentation/Forwarder/latest/Forwarder/Configuretheuniversalforwarder
