# Use the latest Node LTS version as the base image
FROM node:lts

# Update package list and install Node.js along with npm
RUN apt update && \
    apt install -y curl vim python3 python3-pip python3-venv sudo

RUN npm install -g @qwen-code/qwen-code@0.0.14 @anthropic-ai/claude-code@2.0.14

# Install uv Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Go
RUN GO_VERSION="1.24.7" && \
    ARCH=$(dpkg --print-architecture) && \
    case $ARCH in \
        amd64) GO_ARCH="amd64" ;; \
        arm64) GO_ARCH="arm64" ;; \
        armhf) GO_ARCH="armv6l" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    curl -LO "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    tar -C /usr/local -xzf "go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    rm "go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    ln -sf /usr/local/go/bin/go /usr/bin/go

# Install beads tool
RUN git clone https://github.com/steveyegge/beads /tmp/beads && \
    cd /tmp/beads && \
    go build -o bd ./cmd/bd && \
    mv bd /usr/local/bin/ && \
    rm -rf /tmp/beads

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    chmod +x /root/.cargo/env

# Create a non-root user
RUN useradd -m -s /bin/bash qwen && \
    usermod -aG sudo qwen && \
    echo 'qwen ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Make /root readable for inspection (but not writable)
RUN chmod 755 /root

# Copy Rust installation to qwen user's home directory
RUN cp -r /root/.cargo /home/qwen/ && \
    cp -r /root/.rustup /home/qwen/ && \
    chown -R qwen:qwen /home/qwen/.cargo /home/qwen/.rustup

# Copy uv installation to qwen user's home directory
RUN cp -r /root/.local /home/qwen/ && \
    chown -R qwen:qwen /home/qwen/.local

# Set PATH environment variable for all tools
ENV PATH="$HOME/.cargo/bin:/usr/local/go/bin:$HOME/.local/bin:$PATH"

# Set the working directory inside the container
WORKDIR /app

# Switch to non-root user
USER qwen

# Default command to run when the container starts (keep container running)
CMD ["/bin/bash", "-c", "while true; do sleep 1000; done"]
