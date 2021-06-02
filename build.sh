## prepare .csv files with package listings, using installed R of your choice,
## in this case R 4.0
## This creates the files {cran,bioc,later}_packages-4.0.csv
Rscript -e "source('find_packages_4.0.R')"

## testing
docker run -it --rm rocker/r-ver:4.0.3

VERSION=4.0.3
DOCKER_USER=paciorek
CONTAINER=r-scf
REPO=/var/tmp/udocker
# can't use periods in container names
VERSIONDASH=$(echo $VERSION | sed "s/\./\-/g")

## Create docker container.
docker build -f Dockerfile.full -t ${CONTAINER}:${VERSION} . | tee build.log

## Examine build.log for errors:
## search for "non-zero exit status"
## search for ERROR

## Test to make sure container seems ok.
docker run -it --rm ${CONTAINER}:${VERSION}

## Push container to Dockerhub.
docker login --username=${DOCKER_USER}
docker tag ${CONTAINER}:${VERSION} ${DOCKER_USER}/${CONTAINER}:${VERSION}
docker push ${DOCKER_USER}/${CONTAINER}:${VERSION}

## Create udocker container.
udocker mkrepo ${REPO}
udocker --repo=${REPO} pull ${DOCKER_USER}/${CONTAINER}:${VERSION}
## udocker --repo=${REPO} rm ${CONTAINER}-${VERSIONDASH}
udocker --repo=${REPO} create --name=${CONTAINER}-${VERSIONDASH} ${DOCKER_USER}/${CONTAINER}:${VERSION}
## udocker --repo=${REPO} setup ${CONTAINER}-${VERSIONDASH}

## Create Singularity container.
sudo singularity build ${CONTAINER}-${VERSIONDASH}.simg docker://${DOCKER_USER}/${CONTAINER}:${VERSION}
