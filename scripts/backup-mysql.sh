#!/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/ubuntu/backups"
mkdir -p $BACKUP_DIR

echo "Starting MySQL backup..."
kubectl exec -n skillpulse mysql-0 -- \
  mysqldump -uskillpulse -pskillpulse123 skillpulse \
  > $BACKUP_DIR/skillpulse_$TIMESTAMP.sql

echo "Backup saved to $BACKUP_DIR/skillpulse_$TIMESTAMP.sql"
ls -lh $BACKUP_DIR