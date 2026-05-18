#!/bin/bash

# Stop the script if any errors
set -e
# Load environment variables
if [ -f .env ]; then
    source .env
else
    echo "ERROR: El archivo .env no se encuentra en el directorio actual."
    exit 1
fi

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