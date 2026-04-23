FROM node:22-alpine

ARG GO_VERSION=1.24.7
ARG UV_VERSION=0.11.7
ARG COPILOT_CLI_VERSION=1.0.34
ARG CLAUDE_CODE_VERSION=2.1.118

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    py3-pip \
    python3 \
    vim

RUN adduser -D -s /bin/bash devusr

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        GO_ARCH="arm64"; \
    else \
        GO_ARCH="amd64"; \
    fi \
    && curl -fsSLo "/tmp/go.tgz" "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" \
    && tar -C /usr/local -xzf "/tmp/go.tgz" \
    && rm "/tmp/go.tgz" \
    && ln -sf /usr/local/go/bin/go /usr/local/bin/go

USER devusr
ENV HOME=/home/devusr

RUN npm config set prefix "$HOME/.npm-global" \
    && npm install -g \
        "@github/copilot@${COPILOT_CLI_VERSION}" \
        "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
    && curl -LsSf https://astral.sh/uv/install.sh | env UV_VERSION="${UV_VERSION}" sh \
    && rm -rf /tmp/*

USER root

RUN ln -sf /home/devusr/.npm-global/bin/copilot /usr/local/bin/copilot \
    && ln -sf /home/devusr/.npm-global/bin/claude /usr/local/bin/claude

ENV PATH="/usr/local/go/bin:/home/devusr/.local/bin:/home/devusr/.npm-global/bin:$PATH"

WORKDIR /devbox

USER devusr

ENTRYPOINT ["/bin/bash"]

CMD ["-c", "while true; do sleep 1000; done"]