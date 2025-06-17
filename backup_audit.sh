#!/bin/bash

# Set backup source directory where Jenkins has access
BACKUP_DIR=/var/lib/jenkins/mygithub-repos
DEST_DIR=$WORKSPACE

for repo in repo1 repo2 repo3; do
    echo "[$repo] Pulling latest changes..."
    if [ -d "$BACKUP_DIR/$repo" ]; then
        cd "$BACKUP_DIR/$repo" || { echo "❌ Failed to enter $repo"; exit 1; }
        git pull origin main || echo "❌ Pull failed for $repo"

        echo "[$repo] Archiving..."
        tar -czf "$DEST_DIR/${repo}_$(date +%F).tar.gz" -C "$BACKUP_DIR" "$repo"
    else
        echo "❌ $repo not found at $BACKUP_DIR"
        exit 1
    fi
done

echo "✅ Backup complete. Files are archived to Jenkins workspace."
