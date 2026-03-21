# 🐳 Solana Docker Dev Environment

A fully containerized, out-of-the-box development environment for building Solana programs (Smart Contracts) using Rust and the Anchor framework. 

Originally designed as a fast setup for legacy macOS systems, this environment is 100% universal and runs smoothly on Windows (via WSL2), Linux, and modern Apple Silicon (M1/M2/M3) Macs.

## ✨ Features

* Zero-Setup Initialization: Automatically generates a local wallet and configures the Solana CLI on the first run.
* Auto-Airdrop: Gives you 100 SOL automatically every time you start the network.
* Persistent Wallet: Your `.config/solana` directory is mapped to your host machine, meaning you keep the same public key even if you destroy the containers.
* Dual-Container Architecture: Keeps the noisy `solana-test-validator` logs separate from your development workspace.
* Pre-installed Stack: Includes Ubuntu 24.04 (required for GLIBC_2.39), Node.js 24, Yarn, Rust, Solana CLI (Anza release), and the latest Anchor AVM.

---

## 🚀 Quick Start

### 1. Prerequisites
* Install Docker Desktop or Docker Engine.
* Create a local directory for your Solana keys (this prevents permission/mapping issues):
```bash
  mkdir -p ~/.config/solana
```

### 2. Build and Run
Clone this repository, navigate to its folder, and start the environment in the background:
```bash
  docker-compose up --build -d
```
### 3. Start Coding
Enter your development container's terminal:
```bash
  docker exec -it solana-dev bash
```
Once inside, your environment is fully configured and funded! You can verify it by running:
```bash
  solana balance
  anchor init my_project
```
---

## 🏗️ Architecture & How It Works

This project uses a dual-container setup sharing a single network namespace (`network_mode: service:validator`).

1. `validator` container: Runs `solana-test-validator --reset` in the background. It provides a clean, local ledger on every startup.
2. `solana-dev` container: Your main workspace. It seamlessly connects to the validator via `localhost`. A custom `entrypoint.sh` script automatically sets up your CLI config and performs an automated airdrop when the validator is ready.

Your local `./workspace` folder is mapped directly inside the container. You can use your favorite IDE (VS Code, IntelliJ) on your host machine while executing all `cargo` and `anchor` commands inside Docker.