#!/bin/bash

set -e

# wait for MaridDB to be ready
until wp db check --allow-root; do
    echo "Waiting for database..."
    sleep 5
done


# configure WordPress
wp core config --db