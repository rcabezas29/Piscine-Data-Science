#!/bin/bash

set -e
source .env

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <AbsolutePathToFolderWithCSV>"
    exit 1
fi

CSV_PATH=$1
# Extract the filename without the path and extension
TABLE_NAME=$(basename "$CSV_PATH" .csv)

# Copy the CSV file into the Docker container
docker cp "$CSV_PATH" ex00_db_1:/home/$TABLE_NAME.csv

# Generate SQL commands
SQL_COMMANDS=$(cat << EOF

CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    product_id INTEGER,
    category_id BIGINT,
    category_code TEXT,
    brand TEXT
);

TRUNCATE $TABLE_NAME;
COPY $TABLE_NAME(product_id, category_id, category_code, brand)
FROM '/home/$TABLE_NAME.csv' DELIMITER ',' CSV HEADER;
EOF
)

# Execute SQL commands in PostgreSQL Docker container
docker exec -i ex00_db_1 psql -U $POSTGRES_USER -d $POSTGRES_DB -h localhost <<< "$SQL_COMMANDS"
