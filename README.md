# Kubernetes Client

### Container Details
[![](https://images.microbadger.com/badges/image/campbelldgunn/k8s-kubectl-win.svg)](http://microbadger.com/images/campbelldgunn/k8s-kubectl-win "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/campbelldgunn/k8s-kubectl-win.svg)](http://microbadger.com/images/campbelldgunn/k8s-kubectl-win "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/campbelldgunn/k8s-kubectl-win.svg)](http://microbadger.com/images/campbelldgunn/k8s-kubectl-win "Get your own commit badge on microbadger.com")

# Supported tags and respective `Dockerfile` links
* `v1.10.2`, `latest`    [(v1.10.2/Dockerfile)](https://github.com/campbelldgunn/k8s-kubectl-windows/blob/v1.10.2/Dockerfile)

## Overview
This container provides the Kubernetes client kubectl which can be used to interact with a Kubernetes cluster

## Build
`make docker_build`

## Run
`docker run --rm campbelldgunn/k8s-kubectl-win:``git rev-parse --abbrev-ref HEAD`` --server=http://<server-name>:8080 get pods`

## Data Container

In order to get kube spec files accessible via the kubectl container please use the following data container that exposes a data volume under /data. It dumps everything under cwd in the data container.

```
cat ~/bin/mk-data-container
#!/usr/bin/env sh

WORKDIR="$1"

if [ -z $WORKDIR ]; then
    WORKDIR='.'
fi

cd $WORKDIR
echo "FROM debian:jessie\n\nVOLUME [ '/data' ]\n\nCOPY * /data/" > ./Dockerfile.data-container
docker rm data
docker build -f ./Dockerfile.data-container -t temp/data .
docker run --name data temp/data
rm ./Dockerfile.data-container
```

## Data container with kubectl container
```
docker run --rm -it --volumes-from data k8s/kubectl-win:<tag> --server=http://<server-name>:8080 create -f /data/controller.yml
```
