# r-container
Containerized version of SCF R environment for Docker and enroot (and possibly udocker and Singularity).

## Building the container

`build.sh` will build Docker, enroot, udocker, and Singularity containers that mimic the R SCF environment for R X.Y.Z including (almost) all R packages we provide. (As a result the container is rather large.)

## Using the container

See `run-docker.sh`, `run-udocker.sh`, `run-sing.sh` for Docker, udocker, and Singularity usage. Note that these are set up to map all relevant user directories into the container and to allow a user to display plotting windows on the host graphics device.

For use on the SCF, the files in `/usr/local/linux/R-X.Y.Z/bin` are the wrappers for enroot (similar to usage in `run-udocker.sh`) that we put on the SCF filesystem and that are found based on modifying PATH via a Linux environment module. 

## Notes

We rely on the Rocker project's rocker/r-ver:X.Y.Z Docker container, which is built on a base Debian image. Note that we could presumably build off an Ubuntu image using the code in the rocker Dockerfile.

As of R 4.4.3, we are switching to use `renv::install` rather than `install.packages`, as seen in `Dockerfile.full`.

If we wanted to provide RStudio, we would likely build off rocker/rstudio. Per Rocker documentation: The rocker/rstudio image builds with the latest version of RStudio by default. This can be customized by specifying the desired version in --build-arg RSTUDIO_VERSION=<VERSION> if building locally from its Dockerfile.

## Shortcomings

It's not clear how to set up the container so that one could use `future` or other R parallelization packages to run across _multiple_ nodes. Difficulties include:

 - `future` looks for Rscript to start worker processes in $R_HOME, which is set based on the container filesystem. A user can tell it to not look in $R_HOME but just use PATH to find Rscript, but then one would somehow need to have the container know to set PATH so that the correct Rscript on the host (the Rscript pointing back to the container) would be found.
 - In addition, I ran into the problem that when ssh is run, it is looking in /.ssh rather than the user's .ssh directory. 
