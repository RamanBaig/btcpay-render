#!/bin/bash

# Create health check file
touch /tmp/healthy

# Wait for PostgreSQL to be ready with timeout
max_attempts=30
attempt=0
until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q'; do
  attempt=$((attempt+1))
  if [ $attempt -ge $max_attempts ]; then
    rm /tmp/healthy
    echo "Failed to connect to PostgreSQL after $max_attempts attempts"
    exit 1
  fi
  echo "Waiting for PostgreSQL to be ready... (attempt $attempt/$max_attempts)"
  sleep 5
done

# Start BTCPay Server with production optimizations
export COMPlus_EnableDiagnostics=0
export DOTNET_gcServer=1
export DOTNET_GCHeapCount=1

exec dotnet BTCPayServer.dll
