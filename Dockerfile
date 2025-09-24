# Use the latest Node LTS version as the base image
FROM node:lts

# Update package list and install Node.js along with npm
RUN apt update && \
    apt install -y curl vim python3 python3-pip python3-venv

RUN npm install -g @qwen-code/qwen-code@0.0.13

# Install uv Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set the working directory inside the container
WORKDIR /app

# Default command to run when the container starts (keep container running)
CMD ["/bin/bash", "-c", "while true; do sleep 1000; done"]
