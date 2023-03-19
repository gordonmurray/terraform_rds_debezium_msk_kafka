#!/bin/sh
# This starts the apicura schema registry
sudo java -Dregistry.kafka.common.bootstrap.servers=[KAFKA_BROKERS] -jar apicurio-registry-storage-kafkasql-2.4.1.Final-runner.jar
