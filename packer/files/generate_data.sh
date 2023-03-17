#!/bin/bash

# Set database connection parameters
host="[DATABASE_HOST]"
user="[DATABASE_USERNAME]"
password="[DATABASE_PASSWORD]"
database="[DATABASE_SCHEMA]"
table="[DATABASE_TABLE]"

# Loop to insert fake data every few minutes
while true
do
  # Generate fake data
  name=$(shuf -n 1 words.txt)
  address=$(shuf -n 1 words.txt)
  phone_number=$(echo "$RANDOM-$RANDOM-$RANDOM" | sed 's/-/ /g')

  # Get current date and time
  datetime=$(date '+%Y-%m-%d %H:%M:%S')

  # Construct SQL query
  query="INSERT INTO [DATABASE_TABLE] (name, address, phone_number, created_at) VALUES ('$name', '$address', '$phone_number', '$datetime')"

  # Insert data into database
  mysql -h $host -u $user -p$password $database -e "$query"

  # Wait for a few minutes before inserting new data
  sleep 300
done
