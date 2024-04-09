#! /bin/bash

set -e
source .env

# Copy SQL join program to Docker container
docker cp ./fusion.sql ex00_db_1:/home/

# Execute SQL commands in PostgreSQL Docker container
docker exec -i ex00_db_1 psql -U $POSTGRES_USER -d $POSTGRES_DB -h localhost -f /home/fusion.sql
