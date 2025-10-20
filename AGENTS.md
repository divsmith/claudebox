# DevBox Development Guidelines

## Build/Test Commands
- Build Docker image: `docker build --no-cache -t devbox .`
- Test launch script: `./devbox --help`
- Run container manually: `docker run -d --rm --name devbox --env-file .devbox_env -v /host/volume:/sandbox/project-name devbox`
- Test tool installation: `./devbox --tool claude-code`
- Cache management: `./devbox --cache-update && ./devbox --cache-clean`

## Code Style Guidelines
- Shell scripts: Use `set -e`, quote variables, follow existing bash conventions
- Dockerfile: Multi-stage builds, Alpine Linux preferred, cleanup in single layers
- All files start with `// ABOUTME: ` comment describing purpose
- Naming: Use descriptive names, avoid implementation details in names
- Tool definitions: Use variable format `TOOL_NAME="install_cmd|cache_file|check_cmd"`
- Error handling: Always check command success, provide clear error messages
- No temporal context in names/comments (avoid "new", "old", "legacy")
- Follow existing formatting and indentation patterns
- Keep changes minimal and focused
- User experience: Fast feedback, clear progress indicators, helpful error messages