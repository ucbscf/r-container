## prepare .csv files with package listings, using installed R of your choice,
## in this case R 3.4.
Rscript -e "source('find_packages_3.4.R')"

## testing
docker run -it --rm rocker/r-ver:3.4.3

VERSION=0.4
DOCKER_USER=paciorek
CONTAINER=r-test
REPO=/var/tmp/udocker
# can't use periods in container names
VERSIONDASH=$(echo $VERSION | sed "s/\./\-/g")

docker build -f Dockerfile.full -t ${CONTAINER}:${VERSION} .

## Test to make sure container seems ok:
docker run -it --rm ${CONTAINER}:${VERSION}

## Push container to Dockerhub
docker login --username=${DOCKER_USER}
docker tag ${CONTAINER}:${VERSION} ${DOCKER_USER}/${CONTAINER}:${VERSION}
docker push ${DOCKER_USER}/${CONTAINER}:${VERSION}

## Create udocker container
udocker mkrepo ${REPO}
udocker --repo=${REPO} pull ${DOCKER_USER}/${CONTAINER}:${VERSION}
## udocker --repo=${REPO} rm ${CONTAINER}-${VERSIONDASH}
udocker --repo=${REPO} create --name=${CONTAINER}-${VERSIONDASH} ${DOCKER_USER}/${CONTAINER}:${VERSION}
## udocker --repo=${REPO} setup ${CONTAINER}-${VERSIONDASH}

## Create Singularity container
sudo singularity build ${CONTAINER}-${VERSIONDASH}.simg docker://${DOCKER_USER}/${CONTAINER}:${VERSION}
