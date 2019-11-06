#!/bin/bash

VERSION=0-4

## Note that $HOME, ~USER, pwd, /tmp, /var/tmp, ENV all fine in the container.
singularity run -B /scratch/users/${USER} r-test-${VERSION}.simg 
## Note that this works for GUI-based usage that allows one to display plotting windows.


## batch execution
singularity run -B /scratch/users/${USER} r-test-${VERSION}.simg CMD BATCH --no-save file.R file.Rout

