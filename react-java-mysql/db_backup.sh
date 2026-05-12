#!/bin/bash

# Load environment variables
source .env

# Create backups folder if it doesn't exist
mkdir -p ./backups

# Generate filename with current date and time
FECHA=$(date +"%Y%m%d_%H%M%S")
ARCHIVO="./backups/backup_${FECHA}.sql"

echo "Starting database backup..."

# Run mysqldump inside the running container and save to host
docker exec mysql_db mysqldump \
  -u root \
  -p"${MYSQL_ROOT_PASSWORD}" \
  "${MYSQL_DATABASE}" > "${ARCHIVO}"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed: ${ARCHIVO}"
else
    echo "ERROR: Backup failed"
    rm -f "${ARCHIVO}"
    exit 1
fi