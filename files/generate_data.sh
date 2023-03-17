#!/bin/bash

# Set database connection parameters
user="<username>"
password="<password>"
database="<database>"
table="<table>"

# Loop to insert fake data every few minutes
while true
do
  # Generate fake data
  name=$(shuf -n 1 /usr/share/dict/words)
  address=$(shuf -n 1 /usr/share/dict/words)
  phone_number=$(echo "$RANDOM-$RANDOM-$RANDOM" | sed 's/-/ /g')

  # Get current date and time
  datetime=$(date '+%Y-%m-%d %H:%M:%S')

  # Construct SQL query
  query="INSERT INTO $table (name, address, phone_number, created_at) VALUES ('$name', '$address', '$phone_number', '$datetime')"

  # Insert data into database
  mysql -u$user -p$password $database -e "$query"

  # Wait for a few minutes before inserting new data
  sleep 300
done
