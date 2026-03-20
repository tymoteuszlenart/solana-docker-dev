#!/bin/bash
set -e

# A: validator container
if [ "$1" = 'solana-test-validator' ]; then
    echo "🚀 Uruchamianie walidatora Solana..."
    exec "$@"
fi

# B: dev container
echo "⚙️ Konfiguracja środowiska programisty..."
solana config set --url http://localhost:8899

# wait for the validator to start and then airdrop some SOL to the default wallet
(
    echo "⏳ Oczekiwanie na start walidatora..."
    # check if the validator is up by sending a getVersion request every second until it succeeds
    while ! curl -s http://localhost:8899 -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getVersion"}' > /dev/null; do
        sleep 1
    done
    
    echo "💰 Sieć działa! Wykonywanie airdropu 100 SOL..."
    solana airdrop 100 > /dev/null 2>&1
    echo "✅ Gotowe do pracy!"
) &

# exec the command passed as arguments (e.g. bash)
exec "$@"