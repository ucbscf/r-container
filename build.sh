## prepare .csv files with package listings, using installed R of your choice,
## in this case R 4.4.0
## This creates the files {cran,bioc,later}_packages-${VERSION}.csv

Rscript -e "source('find_packages_4.4.0.R')"

## testing
## docker run -it --rm rocker/r-ver:4.4.0

VERSION=4.4.0
DOCKER_USER=paciorek
CONTAINER=r-scf
REPO=/var/tmp/udocker
# can't use periods in container names
VERSIONDASH=$(echo $VERSION | sed "s/\./\-/g")

## Create docker container. First check that the lines in Dockerfile.full that modify the R/etc file(s) are still correct for this rocker version.
docker build -f Dockerfile.full -t ${CONTAINER}:${VERSION} . | tee build-${VERSION}.log

## Examine build.log for errors:
## Search for:
##    "non-zero exit status"
##    ERROR
##    ERROR: config

## Test to make sure container seems ok.
docker run -it --rm ${CONTAINER}:${VERSION}

## Push container to Dockerhub.
docker login --username=${DOCKER_USER}
docker tag ${CONTAINER}:${VERSION} ${DOCKER_USER}/${CONTAINER}:${VERSION}
docker push ${DOCKER_USER}/${CONTAINER}:${VERSION}

## Create udocker container (if desired for testing; not required as the R-${VERSION}/bin/R script will do all this.
udocker mkrepo ${REPO}
udocker --repo=${REPO} pull ${DOCKER_USER}/${CONTAINER}:${VERSION}
## udocker --repo=${REPO} rm ${CONTAINER}-${VERSIONDASH}
udocker --repo=${REPO} create --name=${CONTAINER}-${VERSIONDASH} ${DOCKER_USER}/${CONTAINER}:${VERSION}
## udocker --repo=${REPO} setup ${CONTAINER}-${VERSIONDASH}

## Create Singularity container (if desired; not used on SCF per se).
sudo singularity build ${CONTAINER}-${VERSIONDASH}.simg docker://${DOCKER_USER}/${CONTAINER}:${VERSION}
