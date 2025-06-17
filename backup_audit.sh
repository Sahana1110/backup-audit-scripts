#!/bin/bash

BACKUP_DIR=/home/ec2-user/mygithub-repos
DEST_DIR=$WORKSPACE

for repo in repo1 repo2 repo3; do
    echo "[$repo] Pulling latest changes..."
    cd "$BACKUP_DIR/$repo" || { echo "❌ $repo not found"; exit 1; }
    git pull origin main || echo "❌ Pull failed for $repo"

    echo "[$repo] Archiving..."
    tar -czf "$DEST_DIR/${repo}_$(date +%F).tar.gz" -C "$BACKUP_DIR" "$repo"
done

echo "✅ Backup complete. Files are archived to Jenkins workspace."
