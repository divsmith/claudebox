# Use specific Node.js Alpine version for smaller base and better reproducibility
FROM node:20-alpine3.19

# Install build dependencies with minimal variants and aggressive cleanup
RUN apk add --no-cache \
    curl \
    vim \
    python3 \
    py3-pip \
    sudo \
    bash \
    && rm -rf /var/cache/apk/* \
    # Remove system docs/man pages to save space
    && rm -rf /usr/share/man /usr/share/doc /usr/share/info /usr/local/share/man \
    # Remove vim documentation and runtime files to save space
    && rm -rf /usr/share/vim/vim*/doc /usr/share/vim/vim*/tutor /usr/share/vim/vim*/macros

# Create non-root user first
RUN adduser -D -s /bin/bash devusr \
    && addgroup devusr wheel \
    && echo 'devusr ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Go with aggressive cleanup (~1GB+ savings)
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        GO_ARCH="arm64"; \
    else \
        GO_ARCH="amd64"; \
    fi \
    && curl -LO "https://go.dev/dl/go1.24.7.linux-${GO_ARCH}.tar.gz" \
    && tar -C /usr/local -xzf "go1.24.7.linux-${GO_ARCH}.tar.gz" \
    && rm "go1.24.7.linux-${GO_ARCH}.tar.gz" \
    && ln -sf /usr/local/go/bin/go /usr/bin/go \
    # Aggressive Go cleanup (~500MB+ savings)
    && rm -rf /usr/local/go/{api,doc,pkg/testdata,misc,cwd,test,src} \
    && rm -rf /usr/local/go/pkg/tool/*/api \
    && rm -rf /usr/local/go/pkg/tool/*/buildid \
    && find /usr/local/go/pkg -name "*.a" -delete \
    && find /usr/local/go/pkg -name "*.o" -delete

# Install Rust as devusr with minimal profile and maximum cleanup
USER devusr
ENV RUSTUP_PROFILE=minimal
ENV HOME=/home/devusr
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal \
    && chmod +x /home/devusr/.cargo/env \
    # Maximum Rust cleanup (~1GB+ savings)
    && rm -rf /home/devusr/.rustup/toolchains/stable-*/share/{doc,man,info} \
    && rm -rf /home/devusr/.rustup/toolchains/stable-*/lib/rustlib/*/bin \
    && rm -rf /home/devusr/.rustup/toolchains/stable-*/lib/rustlib/*/analysis \
    && rm -rf /home/devusr/.rustup/toolchains/stable-*/lib/rustlib/*/src \
    && rm -rf /home/devusr/.rustup/downloads \
    # Keep only essential .rlib files, remove test libs and examples
    && find /home/devusr/.rustup/toolchains/stable-*/lib/rustlib -name "*.rlib" -not -name "libstd-*" -not -name "libcore-*" -not -name "liballoc_*" -delete \
    # Remove rustdoc and analysis tools
    && rm -f /home/devusr/.rustup/toolchains/stable-*/bin/rustdoc \
    && rm -f /home/devusr/.rustup/toolchains/stable-*/bin/rust-gdb \
    && rm -rf /home/devusr/.rustup/toolchains/stable-*/lib/rustlib/etc

# Install Claude Code and uv with aggressive cache cleanup
RUN npm config set prefix '~/.npm-global' \
    && npm install -g @anthropic-ai/claude-code@2.0.21 \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    # NPM and uv cleanup (~200MB savings)
    && npm cache clean --force \
    && rm -rf ~/.npm/_cacache \
    && rm -rf ~/.npm/_logs \
    && rm -rf ~/.cargo/registry/cache \
    && rm -rf ~/.cargo/registry/index/.cache \
    && rm -rf ~/.cargo/git/db \
    && rm -rf /tmp/* \
    # Remove docs and examples from npm packages
    && find ~/.npm-global -name "*.md" -delete \
    && find ~/.npm-global -name "README*" -delete \
    && find ~/.npm-global -name "LICENSE*" -delete

# Switch back to root for remaining installations
USER root

# Set PATH for all tools (using literal paths since HOME expands at runtime)
ENV PATH="/home/devusr/.cargo/bin:/usr/local/go/bin:/home/devusr/.local/bin:/home/devusr/.npm-global/bin:/usr/local/bin:$PATH"

# Final system cleanup
RUN rm -rf /tmp/* /var/tmp/* \
    && rm -rf /root/.cache /root/.npm

# Set working directory
WORKDIR /devbox

# Switch to non-root user
USER devusr

# Set bash as entrypoint to override Node.js default
ENTRYPOINT ["/bin/bash"]

# Default command
CMD ["-c", "while true; do sleep 1000; done"]