# DevBox Agent Notes

## Project Scope

- This repo is centered on two execution surfaces: `./devbox` for local session orchestration and `Dockerfile` for the container image.
- Keep behavior changes aligned across `devbox`, `README.md`, and `.github/workflows/build-and-publish.yml` when flags, image names, mount paths, or published image behavior change.
- Use `README.md` for end-user workflow details. Keep this file focused on agent-facing shortcuts and pitfalls.

## Key Files

- `devbox`: bash entrypoint that selects the image, defaults to GitHub Copilot CLI, injects `COPILOT_GITHUB_TOKEN` from a dedicated host secret file, mounts the project into `/devbox/<project>`, and can dispatch to secondary agents such as Claude Code.
- `Dockerfile`: image definition for the runtime used by `devbox`; installs GitHub Copilot CLI, Claude Code, Go, Python 3, and `uv` for both `linux/amd64` and `linux/arm64`.
- `.github/workflows/build-and-publish.yml`: pushes GHCR images when `Dockerfile` or the workflow changes on `main`.
- `README.md`: canonical quick-start and manual Docker usage docs.

## Validation

- There is no automated test suite in this repo.
- After changing `devbox`, run `bash -n ./devbox` as the cheapest syntax check.
- After changing `Dockerfile`, prefer a focused validation such as `docker build -t devbox:latest .` when Docker is available.
- If you change image tags, platforms, or publish triggers, review `.github/workflows/build-and-publish.yml` in the same change.

## Conventions And Pitfalls

- `./devbox` defaults to the remote image `ghcr.io/divsmith/devbox:latest` and pulls it on each run unless `-l` or `--local` is used.
- `./devbox` defaults to GitHub Copilot CLI when no `--agent` option is given.
- Multiple concurrent sessions for the same project are intentional. Preserve the random container suffix and any per-session config behavior needed by non-default agents.
- The default Copilot auth contract is a dedicated host token file at `$HOME/.config/devbox/copilot.env` containing `COPILOT_GITHUB_TOKEN=...`.
- The script still expects `$HOME/.devbox_env` for non-secret shared environment variables. Do not overload it with the default Copilot token path.
- The project mount path inside the container is `/devbox/<project-name>`, not `/sandbox`.
- Avoid reintroducing broad host auth mounts or host keychain coupling into the default Copilot flow.

## Documentation

- Link to [README.md](README.md) instead of copying usage instructions into new customization files.