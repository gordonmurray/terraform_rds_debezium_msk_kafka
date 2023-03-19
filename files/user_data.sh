#!/usr/bin/env bash

# Populate the distributed properties with the broker addresses
sed -i "s/\[KAFKA_BROKERS\]/${brokers}/g" /home/ubuntu/kafka/config/connect-distributed.properties

# Populate the ksqldb server properties with the broker addresses
sed -i "s/\[KAFKA_BROKERS\]/${brokers}/g" /home/ubuntu/ksql-server.properties

# Populate the connector JSON file with Broker and RDS details
sed -i "s/\[KAFKA_BROKERS\]/${brokers}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_HOST\]/${database_host}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_USERNAME\]/${database_username}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_PASSWORD\]/${database_password}/g" /home/ubuntu/connector.json
sed -i "s/\[DATABASE_SCHEMA\]/${database_schema}/g" /home/ubuntu/connector.json

# Populate the data generator
sed -i "s/\[DATABASE_HOST\]/${database_host}/g" /home/ubuntu/generate_data.sh
sed -i "s/\[DATABASE_USERNAME\]/${database_username}/g" /home/ubuntu/generate_data.sh
sed -i "s/\[DATABASE_PASSWORD\]/${database_password}/g" /home/ubuntu/generate_data.sh
sed -i "s/\[DATABASE_SCHEMA\]/${database_schema}/g" /home/ubuntu/generate_data.sh

# Populate the apicurio registry start script
sed -i "s/\[KAFKA_BROKERS\]/${brokers}/g" /home/ubuntu/start_registry.sh

# Move the files in to place
sudo mv /home/ubuntu/debezium.service /etc/systemd/system/debezium.service
sudo mv /home/ubuntu/registry.service /etc/systemd/system/registry.service
sudo mv /home/ubuntu/ksqldb.service /etc/systemd/system/ksqldb.service
sudo mv /home/ubuntu/ksql-server.properties /etc/ksqldb/ksql-server.properties
sudo chmod +x /home/ubuntu/start_registry.sh
sudo systemctl daemon-reload

# Start services
sudo service debezium start
sudo service registry start
sudo service ksqldb start

# Populate database if mariadb is active
if [ "$(systemctl is-active mariadb)" = "active" ]; then
  bash /home/ubuntu/generate_data.sh
fi