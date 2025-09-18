# QwenBox

A containerized sandbox for running Qwen (and other) CLI tools with OpenAI-compatible API.

## Features

- Docker-based environment with Node.js LTS
- Pre-installed Qwen Code package
- Environment variable configuration for API access

## Docker Usage
1. Build the Docker image:
```bash
docker build --no-cache -t qwenbox .
```
2. Run the container:
```bash
docker run -d --rm --name qwenbox --env-file .env -v /host/volume/directory:/app qwenbox
```
3. Exec into the container:
```bash
docker exec -it qwenbox /bin/sh
```

## GitHub Actions Automation

This repository includes a GitHub Actions workflow that automatically monitors the `@qwen-code/qwen-code` npm package for updates and rebuilds the Docker image when updates are detected.

The workflow:
1. Runs every 6 hours or can be triggered manually
2. Checks for new versions of `@qwen-code/qwen-code` on npm
3. If a new version is detected, it:
   - Updates the Dockerfile with the new version
   - Builds and publishes the Docker image to GitHub Container Registry (GHCR)
   - Commits and pushes the updated Dockerfile to the repository

Images are published to:
- `ghcr.io/divsmith/qwenbox:latest`
- `ghcr.io/divsmith/qwenbox:VERSION`
- `ghcr.io/divsmith/qwenbox:COMMIT_SHA`