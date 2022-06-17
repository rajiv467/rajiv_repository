#!/bin/bash

docker build -t kfbuild:latest . \
&& docker run \
  -it --rm \
  -p 8888:80 \
  --mount type=bind,source="$(pwd)/../secrets/.aws",target=/root/.aws \
  --mount type=bind,source="$(pwd)/../secrets/.kube",target=/root/.kube \
  --mount type=bind,source="$(pwd)/../",target=/root/aws \
  --entrypoint bash \
  --name kubeflow-builder \
  kfbuild:latest