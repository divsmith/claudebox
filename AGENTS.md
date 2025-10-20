# ClaudeBox Development Guidelines

## Build/Test Commands
- Build Docker image: `docker build --no-cache -t claudebox .`
- Run container: `docker run -d --rm --name claudebox --env-file .env -v /host/volume:/sandbox/project-name claudebox`
- Test launch script: `./claudebox` (creates tmux session with container)
- Manual container access: `docker exec -it claudebox /bin/sh`

## Code Style Guidelines
- Shell scripts: Use `set -e`, quote variables, follow existing bash conventions
- Dockerfile: Multi-stage builds, Alpine Linux preferred, cleanup in single layers
- All files start with `// ABOUTME: ` comment describing purpose
- Naming: Use descriptive names, avoid implementation details in names
- Error handling: Always check command success, provide clear error messages
- No temporal context in names/comments (avoid "new", "old", "legacy")
- Follow existing formatting and indentation patterns
- Keep changes minimal and focused