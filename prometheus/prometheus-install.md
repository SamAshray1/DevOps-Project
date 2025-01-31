# SetUp Prometheus for Ubuntu Linux
```bash
#!/bin/bash

# Update package manager repositories
sudo apt-get update

# Downloading the Prometheus file
sudo wget https://github.com/prometheus/prometheus/releases/download/v3.1.0/prometheus-3.1.0.linux-amd64.tar.gz

# Unzipping the Prometheus file
sudo tar -xvf prometheus-3.1.0.linux-amd64.tar.gz

# Change directory to the unzipped Prometheus file
sudo cd prometheus-3.1.0.linux-amd64

# Running as detached process, the executible Prometheus file
sudo ./prometheus &
```

# SetUp Blackbox Exporter for Ubuntu Linux
```bash
#!/bin/bash

# Downloading the Blackbox file
sudo wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz

# Unzipping the Blackbox file
sudo tar -xvf blackbox_exporter-0.25.0.linux-amd64.tar.gz

# Change directory to the unzipped Blackbox file
sudo cd blackbox_exporter-0.25.0.linux-amd64

# Running as detached process, the executible Blackbox file
sudo ./blackbox_exporter &
```

### Prometheus Configuration for promethus.yml
Blackbox exporter implements the multi-target exporter pattern, so we advice to read the guide Understanding and using the multi-target exporter pattern to get the general idea about the configuration.

The blackbox exporter needs to be passed the target as a parameter, this can be done with relabelling.

Example config:

scrape_configs:
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - http://prometheus.io    # Target to probe with http.
        - https://prometheus.io   # Target to probe with https.
        - http://example.com:8080 # Target to probe with http on port 8080.
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9115  # The blackbox exporter's real hostname:port.


# SetUp Node Exporter for Ubuntu Linux
```bash
#!/bin/bash

# Downloading the Node Exporter file
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz

# Unzipping the Node Exporter file
sudo tar -xvf node_exporter-1.8.2.linux-amd64.tar.gz

# Change directory to the unzipped Node Exporter file
sudo cd node_exporter-1.8.2.linux-amd64

# Running as detached process, the executible Node Exporter file
sudo ./node_exporter &
```
### Prometheus Configuration for promethus.yml
Example config for Node Exporter:

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['node_ip:9100']

  - job_name: 'jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['node_ip:9100']
