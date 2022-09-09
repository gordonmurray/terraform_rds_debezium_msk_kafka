# RDS, Debezium and a MSK Kafka cluster using Terraform

A small project to stream data from an RDS instance to Kafka using Debezium

* Creates a MariaDB RDS instance
* Saves the generated password for RDS to AWS Secrets Manager
* Creates a Kafka cluster using AWS MSK
* Creates an EC2 instance with Debezium to monitor a table in the RDS instance

There is a way to avoid using an EC2 instance by using Kafka custom connectors which I need to try.

## Deploy the infrastructure

You will need to create the Debezium AMI first, using Packer. 

Update `packer/variables.json to include your AWS credentials profile name, preferred region and instance size. Then run the following commands to Validate the file and Build an AMI that Terraform can use:

Validate:
> packer validate --var-file=variables.json debezium_instance.json

Build:
> packer build --var-file=variables.json debezium_instance.json

Once your AMI has been created, you can now run Terraform to create the necessary infrastructure:

```
terraform init
terraform apply
```

### Sample data for the RDS instance

```
create database if not exists sample_database;

CREATE TABLE IF NOT EXISTS sample_database.people(
    id int not null AUTO_INCREMENT primary key,
    name varchar(100),
    age int,
    comments varchar(100)
)AUTO_INCREMENT=1;

INSERT INTO sample_database.people (name, age, comments) VALUES ('Bob', 44, null);
INSERT INTO sample_database.people (name, age, comments) VALUES ('Fred', 22, null);
INSERT INTO sample_database.people (name, age, comments) VALUES ('Mary', 35, null);
INSERT INTO sample_database.people (name, age, comments) VALUES ('Jane', 6, null);
INSERT INTO sample_database.people (name, age, comments) VALUES ('Beth', 9, null);
INSERT INTO sample_database.people (name, age, comments) VALUES ('Emma', 14, null);

CREATE USER 'debezium'@'%' IDENTIFIED BY 'password';
GRANT SELECT, RELOAD, PROCESS, REFERENCES, INDEX, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, SHOW VIEW, EVENT, REPLICATION CLIENT, TRIGGER ON *.* TO 'debezium'@'%';
FLUSH PRIVILEGES;
```

'''

### Debezium

### Add a Kafka connector to Debezium

> curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8083/connectors -d @rds.json

### List connectors

> curl -X GET http://localhost:8083/connectors



### Estimated cost

```
Project: gordonmurray/terraform_rds_debezium_msk_kafka/.

 Name                                                             Monthly Qty  Unit                    Monthly Cost 
                                                                                                                    
 aws_cloudwatch_log_group.kafka_broker_logs                                                                         
 ├─ Data ingested                                           Monthly cost depends on usage: $0.57 per GB             
 ├─ Archival Storage                                        Monthly cost depends on usage: $0.03 per GB             
 └─ Insights queries data scanned                           Monthly cost depends on usage: $0.0057 per GB           
                                                                                                                    
 aws_db_instance.default                                                                                            
 ├─ Database instance (on-demand, Single-AZ, db.t4g.micro)                730  hours                         $12.41 
 ├─ Storage (general purpose SSD, gp2)                                     20  GB                             $2.54 
 ├─ Additional backup storage                               Monthly cost depends on usage: $0.095 per GB            
 └─ Performance Insights API                                Monthly cost depends on usage: $0.01 per 1000 requests  
                                                                                                                    
 aws_instance.debezium                                                                                              
 ├─ Instance usage (Linux/UNIX, on-demand, t3.small)                      730  hours                         $16.64 
 └─ root_block_device                                                                                               
    └─ Storage (general purpose SSD, gp2)                                  10  GB                             $1.10 
                                                                                                                    
 aws_kms_key.cloudwatch_key                                                                                         
 ├─ Customer master key                                                     1  months                         $1.00 
 ├─ Requests                                                Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                    
 aws_kms_key.kafka_key                                                                                              
 ├─ Customer master key                                                     1  months                         $1.00 
 ├─ Requests                                                Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                    
 aws_kms_key.rds_key                                                                                                
 ├─ Customer master key                                                     1  months                         $1.00 
 ├─ Requests                                                Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                    
 aws_kms_key.secrets_manager                                                                                        
 ├─ Customer master key                                                     1  months                         $1.00 
 ├─ Requests                                                Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                        Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                    
 aws_msk_cluster.kafka                                                                                              
 ├─ Instance (kafka.t3.small)                                           2,190  hours                        $109.28 
 └─ Storage                                                               150  GB                            $16.50 
                                                                                                                    
 aws_secretsmanager_secret.example                                                                                  
 ├─ Secret                                                                  1  months                         $0.40 
 └─ API requests                                            Monthly cost depends on usage: $0.05 per 10k requests   
                                                                                                                    
 OVERALL TOTAL                                                                                              $162.88 
──────────────────────────────────
35 cloud resources were detected:
∙ 9 were estimated, 4 of which include usage-based costs, see https://infracost.io/usage-file
∙ 26 were free:
  ∙ 7 x aws_security_group_rule
  ∙ 3 x aws_route_table_association
  ∙ 3 x aws_security_group
  ∙ 3 x aws_subnet
  ∙ 1 x aws_db_subnet_group
  ∙ 1 x aws_eip
  ∙ 1 x aws_eip_association
  ∙ 1 x aws_internet_gateway
  ∙ 1 x aws_key_pair
  ∙ 1 x aws_msk_configuration
  ∙ 1 x aws_route
  ∙ 1 x aws_route_table
  ∙ 1 x aws_secretsmanager_secret_version
  ∙ 1 x aws_vpc
```