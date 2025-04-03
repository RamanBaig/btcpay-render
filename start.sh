#!/bin/bash

# Create health check file
touch /tmp/healthy

# Ensure PORT is set
export PORT=${PORT:-10000}
echo "Using port: $PORT"

# Wait for PostgreSQL to be ready with timeout
max_attempts=30
attempt=0
echo "Waiting for PostgreSQL to be ready..."

until psql "$POSTGRES_CONNECTIONSTRING" -c '\q' 2>/dev/null; do
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
export ASPNETCORE_URLS="http://+:${PORT}"

exec dotnet BTCPayServer.dll
