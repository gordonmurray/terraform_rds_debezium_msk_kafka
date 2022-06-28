# Terraform RDS, Debezium and a Kafka cluster using MSK

A small project to stream data from an RDS instance to Kafka using Debezium

* Create a MariaDB RDS instance
* Save the generated password for RDS to AWS Secrets Manager
* Create a Kafka cluster using AWS MSK
* Create an EC2 instance with Debezium to monitor a table in the RDS instance

Theres a way to avoid using an EC2 instance by using Kafka custom connectors which I need to try.