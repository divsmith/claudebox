TODO:
* [x] Update project directory mount from /app to /sandbox/{directory}
* [x] Update container user name from qwen to claude
* [x] Fix scheduled job that updates claude-code to not run build and publish if a new version of claude code is not detected. Currently the "build-and-publish" job will often fail with "On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
Error: Process completed with exit code 1."
* [x] Remove the write to config.toml "accept-dangerously-skip-permissions = true" since it should come in with the attached claude config volume.