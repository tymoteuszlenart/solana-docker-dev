# 🐳 Solana Docker Dev Environment

A fully containerized, out-of-the-box development environment for building Solana programs (Smart Contracts) using Rust and the Anchor framework. 

Originally designed as a fast setup for older legacy macOS systems, this environment is **100% universal** and runs smoothly on Windows (via WSL2), Linux, and modern Apple Silicon (M1/M2/M3) Macs.

## ✨ Features

* **Zero-Setup Initialization:** Automatically generates a local wallet and configures the Solana CLI on the first run.
* **Auto-Airdrop:** Gives you 1000 SOL automatically every time you start the container.
* **Persistent Wallet:** Your `id.json` is mapped to your host machine, meaning you keep the same public key even if you destroy the containers.
* **Dual-Container Architecture:** Keeps the noisy `solana-test-validator` logs separate from your development workspace.
* **Pre-installed Stack:** Includes Ubuntu 24.04, Node.js 24, Yarn, Rust, Solana CLI (Anza release), and the latest Anchor AVM.

---

## 🚀 Quick Start

### 1. Prerequisites
* Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker Engine.
* Make sure you have a `.config/solana` folder on your host machine. If not, run this on your local terminal first:
  ```bash
  mkdir -p ~/.config/solana