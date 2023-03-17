#!/usr/bin/env bash

# Populate the distributed properties with the broker addresses
sed -i "s/\[KAFKA_BROKERS\]/${brokers}/g" /home/ubuntu/kafka/config/connect-distributed.properties

# Populate the connector JSON file with Broker and RDS details
sed -i "s/\[KAFKA_BROKERS\]/${brokers}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_HOST\]/${database_host}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_USERNAME\]/${database_username}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_PASSWORD\]/${database_password}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_SCHEMA\]/${database_schema}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_TABLE\]/${database_table}/g" /home/ubuntu/connector.json

# Populate the apicurio registry start script
sed -i "s/\[KAFKA_BROKERS\]/${brokers}/g" /home/ubuntu/start_registry.sh

# Move the files in to place
sudo mv /home/ubuntu/debezium.service /etc/systemd/system/debezium.service
sudo mv /home/ubuntu/registry.service /etc/systemd/system/registry.service
sudo chmod +x /home/ubuntu/start_registry.sh
sudo systemctl daemon-reload

# Decompress the Avro jars
sudo mkdir -p /usr/share/java/apicurio-registry-connect-converter
sudo tar xzf /home/ubuntu/apicurio-registry-distro-connect-converter-2.4.1.Final.tar.gz -C /usr/share/java/apicurio-registry-connect-converter

# Start services
sudo service debezium start
sudo service registry start
