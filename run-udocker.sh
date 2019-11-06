VERSION=0-4

#!/bin/bash
udocker --quiet --repo=/var/tmp/udocker run --workdir=${PWD} --bindhome --hostenv -v /tmp:/tmp -v /var/tmp:/var/tmp -v /scratch/users/${USER}:/scratch/users/${USER}  --user ${USER} --env HOME=${HOME}  r-test-${VERSION}
## Note that this works for GUI-based usage that allows one to display plotting windows.

## For batch execution:
udocker --quiet --repo=/var/tmp/udocker run --workdir=${PWD} --bindhome --hostenv -v /tmp:/tmp -v /var/tmp:/var/tmp -v /scratch/users/${USER}:/scratch/users/${USER}  --user ${USER} --env HOME=${HOME}  r-test-${VERSION} CMD BATCH --no-save file.R file.Rout



