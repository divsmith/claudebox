# Use the latest Node LTS version as the base image
FROM node:lts

# Update package list and install dependencies
RUN apt update && \
    apt install -y curl vim python3 python3-pip python3-venv sudo build-essential gcc

RUN npm install -g @qwen-code/qwen-code@0.0.14 @anthropic-ai/claude-code@2.0.14

# Install uv Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Go 1.23 for beads compatibility
RUN GO_VERSION="1.23.4" && \
    ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64) GO_ARCH="amd64" ;; \
        aarch64|arm64) GO_ARCH="arm64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    echo "Installing Go ${GO_VERSION} for ${GO_ARCH}" && \
    curl -LO "https://golang.org/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-${GO_ARCH}.tar.gz && \
    rm go${GO_VERSION}.linux-${GO_ARCH}.tar.gz && \
    ln -sf /usr/local/go/bin/go /usr/bin/go && \
    /usr/local/go/bin/go version

# Install Beads
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p $GOPATH/bin && \
    go install github.com/steveyegge/beads/cmd/bd@latest && \
    ls -la $GOPATH/bin/ && \
    $GOPATH/bin/bd version

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

# Copy Go installation and beads to qwen user's home directory
RUN mkdir -p /home/qwen/go/bin && \
    cp -r /root/go/bin/* /home/qwen/go/bin/ && \
    chown -R qwen:qwen /home/qwen/go

# Set PATH environment variable for all tools
ENV PATH="/home/qwen/.cargo/bin:/usr/local/go/bin:/home/qwen/.local/bin:/home/qwen/go/bin:$PATH"

# Set Beads environment variables
ENV BD_ACTOR="parker"

# Set the working directory inside the container
WORKDIR /app

# Switch to non-root user
USER qwen

# Default command to run when the container starts (keep container running)
CMD ["/bin/bash", "-c", "while true; do sleep 1000; done"]
