# Use Node.js Alpine LTS - much smaller base image
FROM node:lts-alpine

# Install build dependencies and cleanup in single layer
RUN apk add --no-cache \
    curl \
    wget \
    vim \
    nano \
    git \
    htop \
    tree \
    unzip \
    tar \
    python3 \
    py3-pip \
    sudo \
    bash \
    jq \
    && rm -rf /var/cache/apk/*

# No coding tools pre-installed - installed on demand via caching system

# Install uv Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && rm -rf /tmp/*

# Install Go - multi-platform support for amd64 and arm64
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        GO_ARCH="arm64"; \
    else \
        GO_ARCH="amd64"; \
    fi \
    && curl -LO "https://go.dev/dl/go1.24.7.linux-${GO_ARCH}.tar.gz" \
    && tar -C /usr/local -xzf "go1.24.7.linux-${GO_ARCH}.tar.gz" \
    && rm "go1.24.7.linux-${GO_ARCH}.tar.gz" \
    && ln -sf /usr/local/go/bin/go /usr/bin/go

# Install Rust - minimal profile to save space
ENV RUSTUP_PROFILE=minimal
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal \
    && chmod +x /root/.cargo/env

# Create non-root user
RUN adduser -D -s /bin/bash dev \
    && addgroup dev wheel \
    && echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy tool installations to user and set ownership
RUN cp -r /root/.cargo /home/dev/ \
    && cp -r /root/.rustup /home/dev/ \
    && cp -r /root/.local /home/dev/ \
    && chown -R dev:dev /home/dev/.cargo /home/dev/.rustup /home/dev/.local \
    # Remove unnecessary Rust components to save space (~180M savings)
    && rm -rf /home/dev/.rustup/toolchains/stable-*/share/doc \
    && rm -rf /home/dev/.rustup/toolchains/stable-*/share/man \
    && rm -rf /home/dev/.rustup/toolchains/stable-*/lib/rustlib/*/bin \
    && rm -f /home/dev/.rustup/toolchains/stable-*/lib/rustlib/*/lib/libtest-*.rlib

# Set PATH for all tools (using literal paths since HOME expands at runtime)
ENV PATH="/home/dev/.cargo/bin:/usr/local/go/bin:/home/dev/.local/bin:$PATH"

# Set working directory
WORKDIR /sandbox

# Switch to non-root user
USER dev

# Set bash as entrypoint to override Node.js default
ENTRYPOINT ["/bin/bash"]

# Default command
CMD ["-c", "while true; do sleep 1000; done"]