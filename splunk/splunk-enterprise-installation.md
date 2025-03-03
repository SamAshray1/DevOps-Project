## Splunk Enterprise Installation Steps for Ubuntu x64

wget -O splunk-9.4.1-e3bdab203ac8-linux-amd64.tgz "https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.tgz"

tar -xvf splunk-9.4.1-e3bdab203ac8-linux-amd64.tgz

sudo mv splunk /opt/splunk

sudo /opt/splunk/bin/splunk enable boot-start

sudo /opt/splunk/bin/splunk start --accept-license

# Enable listen via terminal in Splunk server instance

sudo /opt/splunk/bin/splunk enable listen 9997 -auth YourUser:YourStrongPassword

# OR

Settings > Forwarding and Receiving > Receive Data > Add port where you want to listen