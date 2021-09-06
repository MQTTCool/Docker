#!/bin/bash
VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Pleasy specify a version"
    exit 1
fi

docker build ${VERSION} -t mqttcool/mqtt.cool:${VERSION} --no-cache
docker tag mqttcool/mqtt.cool:${VERSION} mqttcool/mqtt.cool:latest
docker push mqttcool/mqtt.cool:${VERSION}
docker push mqttcool/mqtt.cool:latest
