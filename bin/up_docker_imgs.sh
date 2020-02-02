#!/bin/bash

LOCAL_REGISTRY='registry.k8s.example.com:5000'

origin_images=`docker images | grep -v "^$LOCAL_REGISTRY" | grep -vw '^REPOSITORY'`
registry_images=`docker images | grep "^$LOCAL_REGISTRY" | grep -vw '^REPOSITORY'`

for origin_image in $orgin_images
do

