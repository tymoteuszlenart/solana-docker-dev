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

# Anchor Version Manager
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force

# Anchor
RUN avm install latest && avm use latest

WORKDIR /workspace

CMD ["bash"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]