# Use the latest Node LTS version as the base image
FROM node:lts

# Update package list and install Node.js along with npm
RUN apt update && \
    apt install -y curl vim python3 python3-pip python3-venv

# Install Go language
RUN curl -OL https://go.dev/dl/go1.22.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz && \
    rm go1.22.5.linux-amd64.tar.gz

# Install Rust language
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install WebAssembly tools
RUN apt install -y binaryen

# Set environment variables
ENV GOPATH=/root/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:/root/.cargo/bin

# Source cargo environment
RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc && \
    echo 'export PATH="$PATH:$HOME/.cargo/bin"' >> $HOME/.bashrc
RUN . $HOME/.cargo/env

RUN npm install -g @qwen-code/qwen-code@latest

# Install uv Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set the working directory inside the container
WORKDIR /app

# Default command to run when the container starts (keep container running)
CMD ["/bin/bash", "-c", "while true; do sleep 1000; done"]
