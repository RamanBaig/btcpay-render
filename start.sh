#!/bin/bash

# Create health check file
touch /tmp/healthy

# Wait for PostgreSQL to be ready with timeout
max_attempts=60
attempt=0
echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD=$POSTGRES_PASSWORD psql "postgresql://${POSTGRES_USER}@${POSTGRES_HOST}:5432/${POSTGRES_DB}" -c '\q' > /dev/null 2>&1; do
    attempt=$((attempt+1))
    if [ $attempt -ge $max_attempts ]; then
        rm /tmp/healthy
        echo "Failed to connect to PostgreSQL after $max_attempts attempts"
        exit 1
    fi
    echo "Attempt $attempt/$max_attempts. Retrying in 5s..."
    sleep 5
done

echo "PostgreSQL is ready!"

# Start BTCPay Server with production optimizations
export COMPlus_EnableDiagnostics=0
export DOTNET_gcServer=1
export DOTNET_GCHeapCount=1

exec dotnet BTCPayServer.dll
