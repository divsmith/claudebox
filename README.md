# DevBox

DevBox runs coding agents inside a Docker container with your project mounted at `/devbox/<project-name>`. The default agent is GitHub Copilot CLI. Claude Code remains available as an opt-in agent path.

## Features

- Docker-based workspace with Node.js 22, Go, Python 3, Git, and `uv`
- GitHub Copilot CLI installed by default
- Claude Code installed as a secondary agent path
- Automatic container cleanup on session end
- Copilot authentication via a dedicated host-side token file instead of repeated in-container login

## Quick Start

### 1. Create a Copilot token file

DevBox expects a dedicated token file at `~/.config/devbox/copilot.env` by default.

Create a fine-grained GitHub personal access token with the `Copilot Requests` permission, then store it like this:

```bash
mkdir -p ~/.config/devbox
chmod 700 ~/.config/devbox
cat > ~/.config/devbox/copilot.env <<'EOF'
COPILOT_GITHUB_TOKEN=github_pat_...
EOF
chmod 600 ~/.config/devbox/copilot.env
```

Classic PATs are not supported by Copilot CLI.

### 2. Launch DevBox

```bash
# Launch GitHub Copilot CLI for the current directory
./devbox

# Launch GitHub Copilot CLI for a specific project
./devbox ~/path/to/your/project

# Launch Claude Code explicitly
./devbox --agent claude ~/path/to/your/project

# Override the default Copilot token file location
./devbox --copilot-token-file ~/.secrets/devbox-copilot.env
```

The script will:

- Start a container for the selected project
- Mount the project at `/devbox/<project-name>`
- Launch GitHub Copilot CLI by default when no `--agent` option is given
- Inject `COPILOT_GITHUB_TOKEN` from the dedicated token file for the Copilot path
- Clean up the container automatically when you exit

## Security Model

- The default Copilot flow does not require repeating `copilot login` inside each container.
- DevBox injects `COPILOT_GITHUB_TOKEN` into the container instead of mounting broad GitHub auth state.
- The launcher applies `--security-opt no-new-privileges:true` to the container runtime.
- Claude-specific config is mounted only when `--agent claude` is selected.

## Building Locally

```bash
docker build -t devbox:latest .
```

To use the local image instead of the remote GHCR image:

```bash
./devbox --local
```

## Manual Docker Usage

The launcher is the supported entrypoint because it handles session naming, project mounting, agent selection, and auth injection. If you need to run the container manually, use the same workspace mount convention:

```bash
docker run --rm -it \
   --security-opt no-new-privileges:true \
   -e COPILOT_GITHUB_TOKEN=github_pat_... \
   -v /host/project:/devbox/project \
   -w /devbox/project \
   devbox:latest \
   copilot
```

## Published Images

Images are published to GHCR as:

- `ghcr.io/divsmith/devbox:latest`
- `ghcr.io/divsmith/devbox:<commit-sha>`