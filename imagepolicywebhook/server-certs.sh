#!/bin/env bash
# minikube ip: 192.168.39.52

openssl genrsa -out certs/server.key 4096

openssl req -new -key certs/server.key -out certs/server.csr \
	-subj '/CN=system:node:imagepolicy.imagepolicy.svc/O=system:nodes' \
	-addext 'subjectAltName = DNS:imagepolicy.imagepolicy.svc, DNS:imagepolicy.imagepolicy.svc.cluster.local, IP:192.168.39.52' \
	-addext 'keyUsage = keyEncipherment, digitalSignature' \
	-addext 'extendedKeyUsage = serverAuth'
