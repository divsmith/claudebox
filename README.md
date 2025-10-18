# ClaudeBox

A containerized sandbox for running Claude Code with automatic environment management and tmux integration.

## Features

- Docker-based environment with Node.js LTS
- Pre-installed Claude Code CLI
- Automatic tmux session management
- Environment variable configuration for API access
- Automatic container cleanup on session end

## Quick Start

### Using the ClaudeBox Script (Recommended)

The easiest way to use ClaudeBox is with the provided launch script:

```bash
# Launch for current directory
./claudebox

# Launch for specific project directory
./claudebox ~/path/to/your/project

# The script will:
# - Create a tmux session named "claude-{project-name}"
# - Start a Docker container with your project mounted
# - Automatically launch Claude Code
# - Clean up the container when you exit the session
```

### Manual Docker Usage

1. Build the Docker image:
```bash
docker build --no-cache -t claudebox .
```
2. Run the container:
```bash
docker run -d --rm --name claudebox --env-file .env -v /host/volume/directory:/sandbox/project-name claudebox
```
3. Exec into the container:
```bash
docker exec -it claudebox /bin/sh
```

## GitHub Actions Automation

This repository includes a GitHub Actions workflow that automatically monitors the `@anthropic-ai/claude-code` npm package for updates and rebuilds the Docker image when updates are detected.

The workflow:
1. Runs every 6 hours or can be triggered manually
2. Checks for new versions of `@anthropic-ai/claude-code` on npm
3. If a new version is detected, it:
   - Updates the Dockerfile with the new version
   - Builds and publishes the Docker image to GitHub Container Registry (GHCR)
   - Commits and pushes the updated Dockerfile to the repository

Images are published to:
- `ghcr.io/divsmith/claudebox:latest`
- `ghcr.io/divsmith/claudebox:VERSION`
- `ghcr.io/divsmith/claudebox:COMMIT_SHA`