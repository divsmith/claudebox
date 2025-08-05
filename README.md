# QwenBox

A containerized sandbox for running Qwen (and other) CLI tools with OpenAI-compatible API.

## Features

- Docker-based environment with Node.js LTS
- Pre-installed Qwen Code package
- Environment variable configuration for API access

## Setup

### Environment Configuration

Copy `.env.example` as `.env` and update the following variables:

```env
OPENAI_API_KEY=your_api_key_here
OPENAI_BASE_URL=https://openrouter.ai/api/v1
OPENAI_MODEL=qwen/qwen3-coder:free
```

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