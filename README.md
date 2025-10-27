# Docker Images

## Assumptions

It is assumed that you know how to set up docker on your system and can
run CUDA. You may need to adjust for the version of CUDA your graphics
driver supports or remove the CUDA components entirely.

## Instructions

The rundocker script will run the container:

```
rundocker.sh image workspace
```

Where workspace is the path you wish to work inside when the docker
container is running.

The first time the script is run the image will be built and tagged under the
namespace `mukoan`, e.g. the techdemo image will be tagged `mukoan/techdemo`.

## Images

### techdemo

Start with `./rundocker.sh techdemo /path/to/workspace`.

OpenCV will be built inside the container on the first run,
taking approximately 30 minutes depending on the specications of your computer.

If the CUDA version is modified then the torch version must be modified too.

### gsplat

Start with `./rundocker.sh gsplat /path/to/workspace`.

The gsplat source will be in the home directory of the user.
