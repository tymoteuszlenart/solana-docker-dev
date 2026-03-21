# Use an official Ubuntu base image for glibc compatibility
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# sys + nodejs + yarn
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    llvm \
    clang \
    cmake \
    make \
    python3 \
    && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

# Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Solana (Anza)
RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

# AVM + Anchor
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force \
    && /root/.cargo/bin/avm install latest \
    && /root/.cargo/bin/avm use latest

WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]