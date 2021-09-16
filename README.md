# Fire Dynamics Simulator (FDS) sandbox

This project creates an Docker image with FDS installed from source code. The goals are:
- Provide a common environment. We use Ubuntu 20.04.
- Detailed instructions on how to install FDS from source-code.

## Create image and container

- Run `./configure.sh` to download dependencies and prepare for Docker build.
- Run `./build.sh` to build the image.
- Run something like `run.sh.sample` to create a container.