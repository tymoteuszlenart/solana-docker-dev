# Node 24 + Yarn on Debian (bookworm)
FROM node:24-bookworm

ENV DEBIAN_FRONTEND=noninteractive

# packets required for building Solana and Anchor
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    llvm \
    clang \
    cmake \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Solana
RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

# Anchor
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force \
    && /root/.cargo/bin/avm install latest \
    && /root/.cargo/bin/avm use latest

WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]