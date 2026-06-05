#!/bin/bash

BACKUP_DIR="logs_backup"

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
fi

for i in {1..5}
do
    touch "logfile_${i}.log"
done

mv *.log "$BACKUP_DIR"/

echo "Done! Log files have been moved to $BACKUP_DIR."
