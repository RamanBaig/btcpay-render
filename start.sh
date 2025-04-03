#!/bin/bash

# Create health check file
touch /tmp/healthy

# Ensure PORT is set
export PORT=${PORT:-10000}
echo "Using port: $PORT"

# Wait for PostgreSQL to be ready with timeout
max_attempts=60
attempt=0
echo "Waiting for PostgreSQL to be ready..."

# Print connection details (without password)
echo "Database connection details:"
echo "Host: $POSTGRES_HOST"
echo "User: $POSTGRES_USER"
echo "Database: $POSTGRES_DB"
echo "Port: $PGPORT"

until PGPASSWORD=$POSTGRES_PASSWORD psql "host=$POSTGRES_HOST port=$PGPORT dbname=$POSTGRES_DB user=$POSTGRES_USER sslmode=require" -c '\l' > /dev/null 2>&1; do
    attempt=$((attempt+1))
    if [ $attempt -ge $max_attempts ]; then
        rm /tmp/healthy
        echo "Failed to connect to PostgreSQL after $max_attempts attempts"
        
        # Try one last time with error output
        PGPASSWORD=$POSTGRES_PASSWORD psql "host=$POSTGRES_HOST port=$PGPORT dbname=$POSTGRES_DB user=$POSTGRES_USER sslmode=require" -c '\l'
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
