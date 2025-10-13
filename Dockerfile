# Use the latest Node LTS version as the base image
FROM node:lts

# Update package list and install Node.js along with npm
RUN apt update && \
    apt install -y curl vim python3 python3-pip python3-venv

RUN npm install -g @qwen-code/qwen-code@0.0.14 @anthropic-ai/claude-code@2.0.14

# Install uv Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Go
RUN curl -LO https://go.dev/dl/go1.24.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.24.7.linux-amd64.tar.gz && \
    rm go1.24.7.linux-amd64.tar.gz && \
    ln -sf /usr/local/go/bin/go /usr/bin/go

# Set PATH environment variable for all tools
ENV PATH="$HOME/.cargo/bin:/usr/local/go/bin:$PATH"


# Set the working directory inside the container
WORKDIR /app

# Default command to run when the container starts (keep container running)
CMD ["/bin/bash", "-c", "while true; do sleep 1000; done"]
