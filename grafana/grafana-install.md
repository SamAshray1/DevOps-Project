# SetUp Prometheus for Ubuntu Linux
```bash
#!/bin/bash

sudo apt-get install -y adduser libfontconfig1 musl

wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.0_amd64.deb

sudo dpkg -i grafana-enterprise_11.5.0_amd64.deb
```
# Login to Grafana portal
Go to http://your_grafana_ip:3000

Default Username and Password is: admin