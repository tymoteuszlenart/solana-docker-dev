FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

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
    && rm -rf /var/lib/apt/lists/*

# Node.js 24 + Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g yarn

# Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Solana
RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"
RUN solana-keygen new -o /root/.config/solana/id.json && \
    solana config set --keypair /root/.config/solana/id.json && \
    solana config set --url http://localhost:8899 && \
    solana airdrop 1000

# Anchor Version Manager
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force

# Anchor
RUN avm install latest && avm use latest

WORKDIR /workspace

CMD ["bash"]