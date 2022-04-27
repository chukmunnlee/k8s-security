#!/usr/bin/env bash

openssl genrsa -out certs/server.key 4096

openssl req -new -key certs/server.key -out certs/server.csr \
	-subj '/CN=system:node:opa-svc.opa-system.svc/O=system:nodes' \
	-addext 'subjectAltName = DNS:opa-svc.opa-system.svc, DNS:opa-svc.opa-system.svc.cluster.local, IP:192.168.39.162' \
	-addext 'keyUsage = keyEncipherment, digitalSignature' \
	-addext 'extendedKeyUsage = serverAuth'

