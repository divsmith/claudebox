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