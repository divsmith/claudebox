TODO:
* [x] rename from claudebox to devbox
* [x] rename claude user to dev
* [x] use isolated ~/.claude.json file for each session
* [x] persist preferences (dark theme, vim mode enabled) in each container
* [x] rename claude user in dockerfile and devbox script to devusr
* [x] change /sandbox path to /devbox
* [x] use image published at ghcr.io/divsmith/devbox by default, override to use local image with -l or --local flag
* [x] Update github action to only build the image on push. Remove the scheduled update function entirely.
* [x] update devbox script to always pull when using a remote image
* [x] support multiple devbox sessions for a single project at the same time. Each should have its own unique .claude.json file, and running the 'devbox' script inside a project shouldn't shut down any existing containers for that project. 