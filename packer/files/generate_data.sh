#!/bin/bash
sudo apt install mariadb-client-core-10.6 -y

# Set database connection parameters
host="[DATABASE_HOST]"
user="[DATABASE_USERNAME]"
password="[DATABASE_PASSWORD]"
database="[DATABASE_SCHEMA]"
table="[DATABASE_TABLE]"

# Prepare database
mysql -h $host -u $user -p$password -e "CREATE USER IF NOT EXISTS 'debezium'@'%' IDENTIFIED BY 'password';"
mysql -h $host -u $user -p$password -e "GRANT SELECT, RELOAD, PROCESS, REFERENCES, INDEX, SHOW DATABASES, CREATE TEMPORARY TABLES, REPLICATION SLAVE, LOCK TABLES, SHOW VIEW, EVENT, REPLICATION CLIENT, TRIGGER ON *.* TO 'debezium'@'%';"
mysql -h $host -u $user -p$password -e "FLUSH PRIVILEGES;"
mysql -h $host -u $user -p$password -e "CREATE DATABASE IF NOT EXISTS sample_database;"
mysql -h $host -u $user -p$password -e "CREATE TABLE IF NOT EXISTS sample_database.people(id int not null AUTO_INCREMENT primary key,name varchar(100),address varchar(255),phone_number varchar(100),created_at DATETIME) AUTO_INCREMENT=1;"

# Loop to insert fake data
while true
do
  # Generate fake data
  name=$(shuf -n 1 words.txt)
  address=$(shuf -n 1 words.txt)
  phone_number=$(echo "$RANDOM-$RANDOM-$RANDOM" | sed 's/-/ /g')

  # Get current date and time
  datetime=$(date '+%Y-%m-%d %H:%M:%S')

  # Construct SQL query
  query="INSERT INTO $table (name, address, phone_number, created_at) VALUES ('$name', '$address', '$phone_number', '$datetime')"

  # Insert data into database
  mysql -h $host -u $user -p$password $database -e "$query"

  # Wait for a few minutes before inserting new data
  sleep 2
done
