# DevBox Development Sandbox

A containerized development sandbox for running coding tools with automatic environment management, tmux integration, and a hybrid tool caching system.

## Features

- **Clean Sandbox Environment** - Docker-based with Node.js LTS, Python, Go, Rust, and essential utilities
- **Hybrid Tool Caching** - Install development tools on-demand, cached for instant subsequent use
- **Automatic tmux Session Management** - Each project gets its own isolated session
- **Automatic Container Cleanup** - Containers stop when you exit the session
- **Multi-Tool Support** - Claude Code, Gemini Code, Qwen CLI, OpenCode, and more
- **Smart Caching** - Tools downloaded once, cached for all future sessions

## Quick Start

### Using the DevBox Script (Recommended)

The easiest way to use DevBox is with the provided launch script:

```bash
# Basic usage - drops you to bash shell
./devbox

# Launch for specific project directory
./devbox ~/code/myproject

# Launch with specific development tool
./devbox ~/code/myproject --tool claude-code

# See available tools
./devbox --list-tools
```

### Available Development Tools

| Tool | Description | Cache Status |
|------|-------------|--------------|
| `claude-code` | Anthropic's Claude Code CLI | 📥 Download on demand |
| `gemini-code` | Google's Gemini CLI | 📥 Download on demand |
| `qwen-cli` | Qwen AI CLI | 📥 Download on demand |
| `opencode` | OpenCode CLI | 📥 Download on demand |

### Cache Management

```bash
# Update all tool caches (download for offline use)
./devbox --cache-update

# Clean tool cache
./devbox --cache-clean

# List tools and their cache status
./devbox --list-tools
```

## How It Works

### The Hybrid Caching System

1. **First Use**: Tool is downloaded and installed (takes 30-60 seconds)
2. **Automatic Caching**: Tool is packaged and cached to `~/.devbox/cache/`
3. **Subsequent Uses**: Tool extracted from cache (takes 2-5 seconds) ⚡

This gives you:
- ✅ Clean base image (no bloat)
- ✅ Fast subsequent startups
- ✅ Offline capability after first download
- ✅ Multiple tools without conflicts

### Session Management

Each project gets its own isolated environment:
- **tmux session**: `devbox-{project-name}`
- **Docker container**: `devbox-{project-name}`
- **Mount point**: `/sandbox/{project-name}`
- **Automatic cleanup**: Container stops when session ends

## Manual Docker Usage

If you prefer to use Docker directly:

1. Build the Docker image:
```bash
docker build --no-cache -t devbox .
```

2. Run the container:
```bash
docker run -d --rm --name devbox --env-file .devbox_env -v /host/volume/directory:/sandbox/project-name devbox
```

3. Exec into the container:
```bash
docker exec -it devbox /bin/bash
```

## Environment Configuration

Create a `~/.devbox_env` file for environment variables:

```bash
# API keys for development tools
ANTHROPIC_API_KEY=your_anthropic_key
GOOGLE_API_KEY=your_google_key
OPENAI_API_KEY=your_openai_key

# Custom settings
DEFAULT_EDITOR=vim
GIT_AUTHOR_NAME="Your Name"
GIT_AUTHOR_EMAIL="your.email@example.com"
```

## Development

### Building the Project

```bash
# Build Docker image
docker build --no-cache -t devbox .

# Test the launch script
./devbox --help
```

### Project Structure

```
devbox/
├── devbox               # Main launch script
├── Dockerfile          # Multi-language development environment
├── README.md           # This file
├── AGENTS.md           # Development guidelines for agents
└── .github/
    └── workflows/
        └── update-and-publish.yml  # CI/CD pipeline
```

## Use Cases

### For Different Development Tools

```bash
# Claude Code for AI-assisted development
./devbox ~/myproject --tool claude-code

# Gemini Code for Google's AI assistance
./devbox ~/myproject --tool gemini-code

# Multiple projects, different tools
./devbox ~/frontend --tool claude-code
./devbox ~/backend --tool gemini-code
```

### For Team Collaboration

Each team member can have their own tool preferences while maintaining consistent environments:

```bash
# Developer A prefers Claude Code
./devbox ~/shared-project --tool claude-code

# Developer B prefers Gemini Code  
./devbox ~/shared-project --tool gemini-code
```

## GitHub Actions Automation

The repository includes a GitHub Actions workflow that:
- Rebuilds the Docker image on changes to Dockerfile
- Publishes to GitHub Container Registry (GHCR)
- Supports multi-platform builds (linux/amd64, linux/arm64)

Images are published to:
- `ghcr.io/divsmith/claudebox:latest`
- `ghcr.io/divsmith/claudebox:VERSION`
- `ghcr.io/divsmith/claudebox:COMMIT_SHA`

## Troubleshooting

### Common Issues

**Container won't start:**
```bash
# Check Docker is running
docker --version

# Check for existing containers
docker ps -a | grep devbox
```

**Tool installation fails:**
```bash
# Clean cache and retry
./devbox --cache-clean
./devbox --cache-update
```

**tmux session issues:**
```bash
# List existing sessions
tmux ls

# Kill stuck session
tmux kill-session -t devbox-projectname
```

### Getting Help

```bash
# Show all options
./devbox --help

# Check cache status
./devbox --list-tools
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- The Docker team for the excellent containerization platform
- The tmux team for the terminal multiplexer
- All the development tool teams for their amazing CLI tools