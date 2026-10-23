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

If the CUDA version is modified then the torch version must be modified too.

### gsplat

gsplat will be installed via pip.

The gsplat source will be downloaded and stored in the home directory of the user.

### orbslam3

ORBSLAM3 and Pangolin (a dependency) will be downloaded into the home
directory of the user and built.

The ORBSLAM3 source is from the community version maintained by Jeremy Salwen;
it includes bug fixes from PRs submitted to the original ORBSLAM3 repository.
I have further patched it to support export to COLMAP.
