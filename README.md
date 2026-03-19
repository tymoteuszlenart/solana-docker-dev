# Solana Docker Dev (solana-docker-dev)

This repo provides a Docker-based development environment for a Solana/Anchor project.

It includes:
- A `solana-test-validator` container for running a local Solana cluster (validator)
- A `solana-dev` container for running development commands inside a stable toolchain environment

---

## 🧱 Prerequisites

- Docker (Desktop or Engine) with at least 4 CPUs and 8GB RAM allocated
- docker-compose (usually included with Docker Desktop)

---

## ▶️ Start the environment

From the repo root:

```bash
docker-compose up -d
```

This starts both containers in the background. The validator uses `--reset` to ensure a fresh ledger on each start.

---

## 🔌 Port mappings (host ↔ container)

### `solana-dev` (development container)
- RPC:  `localhost:8899` → container `8899`
- WS:   `localhost:8898` → container `8900`

### `validator` (solana-test-validator)
- RPC:  `localhost:8900` → container `8899`
- WS:   `localhost:8901` → container `8900`

> Note: Both services need RPC + WS ports, so the host ports must be unique.

---

## 🧪 Common workflows

### Open a shell in the dev container

```bash
docker-compose exec solana-dev bash
```

From there you can run Anchor/Rust/TypeScript commands.

### Configure Solana CLI to use the validator

Inside the dev container:

```bash
solana config set --url http://solana-validator:8899
solana cluster-version  # Verify connection
```

### Fund the wallet (for deployments/tests)

```bash
solana airdrop 100  # Request 100 SOL for the configured wallet
```

### Run Solana CLI against a specific service

- Against the dev container (RPC running on host `8899`):
  ```bash
  solana --url http://localhost:8899 <command>
  ```

- Against the validator (RPC running on host `8900`):
  ```bash
  solana --url http://localhost:8900 <command>
  ```

---

## 📌 Stop / clean up

Stop containers:

```bash
docker-compose down
```

Remove volumes (ledger data, caches):

```bash
docker-compose down -v
```

---

## 🛠️ Troubleshooting

### Validator stuck on a slot (e.g., "Processed Slot: 5901" repeating)
- **Cause**: Existing ledger corruption or resource issues.
- **Fix**: The validator is configured with `--reset` to start fresh. If still stuck, increase Docker resources (4+ CPUs, 8GB RAM) or run `docker-compose down -v` to wipe volumes.

### Airdrop taking too long (>1 minute)
- **Cause**: Validator not producing blocks or network latency.
- **Fix**: Ensure validator is advancing slots (`docker-compose logs -f validator`). Restart if stuck. Use smaller amounts: `solana airdrop 0.5`.

### Permission denied on Docker buildx
- **Cause**: File ownership issue in `~/.docker/buildx/current`.
- **Fix**: `sudo chown $USER ~/.docker/buildx/current` or restart Docker Desktop.

### General debugging
- Check logs: `docker-compose logs <service>`
- Monitor resources: `docker stats`
- Test connection: `solana ping --url http://solana-validator:8899`

---

## 🛠️ Notes

- `solana-dev` is configured as an interactive container (`stdin_open: true`, `tty: true`) and typically sits idle unless you run commands inside it.
- The `validator` container runs `solana-test-validator --reset` automatically for a clean start.
- CPU/RAM usage is high during Solana operations—allocate sufficient resources in Docker settings.
