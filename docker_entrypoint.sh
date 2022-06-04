#!/bin/sh

_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$redis_child" 2>/dev/null
  kill -TERM "$npm_child" 2>/dev/null
}

mkdir -p /root/redis-data
echo "dir /root/redis-data" | redis-server - &
redis_child=$!

# export REDIS_URL="redis://localhost:6379"
export TOR_URL=$(yq e '.tor-address' /root/start9/config.yaml)
export TOR_URL=$(yq e '.tor-address' /root/start9/config.yaml)
# PORT: "3000"
# TOR_URL: "$TOR_ADDRESS"
# LND_CERT_FILE: "/lnd/tls.cert"
# LND_ADMIN_MACAROON_FILE: "/lnd/data/chain/bitcoin/${BITCOIN_NETWORK}/admin.macaroon"
export CONFIG='{ "redis": { "port": 6379, "host": "localhost", "family": 4, "password": "password", "db": 0 }, "lnd": { "url": "lnd.embassy:10009", "password": ""}}'

cp /mnt/lnd/tls.cert /lndhub/ && cp /mnt/lnd/admin.macaroon /lndhub/

exec tini npm start &
npm_child=$!

trap _term SIGTERM

wait -n $redis_child $npm_child
