#!/bin/bash
sudo apt install mariadb-client-core-10.6 -y

# Set database connection parameters
host="[DATABASE_HOST]"
user="[DATABASE_USERNAME]"
password="[DATABASE_PASSWORD]"
database="[DATABASE_SCHEMA]"

# Prepare database
mysql -h $host -u $user -p$password -e "CREATE USER IF NOT EXISTS 'debezium'@'%' IDENTIFIED BY 'password';"
mysql -h $host -u $user -p$password -e "GRANT SELECT, RELOAD, PROCESS, REFERENCES, INDEX, SHOW DATABASES, CREATE TEMPORARY TABLES, REPLICATION SLAVE, LOCK TABLES, SHOW VIEW, EVENT, REPLICATION CLIENT, TRIGGER ON *.* TO 'debezium'@'%';"
mysql -h $host -u $user -p$password -e "FLUSH PRIVILEGES;"
mysql -h $host -u $user -p$password -e "CREATE DATABASE IF NOT EXISTS sample_database;"
mysql -h $host -u $user -p$password -e "CREATE TABLE IF NOT EXISTS sample_database.users(id int not null AUTO_INCREMENT primary key,name varchar(100),address varchar(255),phone_number varchar(100),created_at DATETIME) AUTO_INCREMENT=1;"
mysql -h $host -u $user -p$password -e "CREATE TABLE IF NOT EXISTS sample_database.products(id int not null AUTO_INCREMENT primary key,product varchar(100), price DECIMAL(10,2), created_at DATETIME) AUTO_INCREMENT=1;"
mysql -h $host -u $user -p$password -e "CREATE TABLE IF NOT EXISTS sample_database.purchases(id int not null AUTO_INCREMENT primary key, userId int, productId int, created_at DATETIME) AUTO_INCREMENT=1;"

# Add some records to the database
for i in {1..100}
do

  # Call API and retrieve JSON response
  response=$(curl -s https://api.namefake.com/english/random)

  # Extract values from JSON using jq
  name=$(echo "$response" | jq -r '.name')
  address=$(echo "$response" | jq -r '.address')
  phone_number=$(echo "$response" | jq -r '.phone_w')
  product=$(echo "$response" | jq -r '.sport')
  price=$(echo "$response" | jq -r '.weight')
  datetime=$(date +"%Y-%m-%d %H:%M:%S")
  user_id=$(( ( RANDOM % 99 )  + 1 ))
  product_id=$(( ( RANDOM % 99 )  + 1 ))

  mysql -h $host -u $user -p$password $database -e "INSERT INTO users (name, address, phone_number, created_at) VALUES ('$name', '$address', '$phone_number', '$datetime')"
  mysql -h $host -u $user -p$password $database -e "INSERT INTO products (product, price, created_at) VALUES ('$product', '$price', '$datetime')"
  mysql -h $host -u $user -p$password $database -e "INSERT INTO purchases (userId, productId, created_at) VALUES ('$user_id', '$product_id', '$datetime')"

  sleep 1
done


