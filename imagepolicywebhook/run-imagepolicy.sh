#!/usr/bin/env bash
docker run -d -p 1323:1323 -v /home/docker/certs:/certs:ro \
	chukmunnlee/kube-image-bouncer:1.0 \
	--cert /certs/server.cert \
	--key /certs/server.key \
	--debug
