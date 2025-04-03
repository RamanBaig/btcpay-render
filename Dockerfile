FROM mcr.microsoft.com/dotnet/sdk:7.0 AS builder
WORKDIR /source
RUN git clone --branch v1.7.11 https://github.com/btcpayserver/btcpayserver.git .
RUN dotnet publish -c Release -o /app \
    --no-self-contained \
    /p:PublishReadyToRun=true \
    /p:TieredCompilation=true \
    BTCPayServer/BTCPayServer.csproj

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=builder /app .
COPY start.sh .
RUN chmod +x start.sh \
    && apt-get update \
    && apt-get install -y postgresql-client \
    && rm -rf /var/lib/apt/lists/*

ENV ASPNETCORE_URLS=http://+:${PORT}
EXPOSE ${PORT}
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD [ -f /tmp/healthy ] || exit 1

ENTRYPOINT ["./start.sh"]
