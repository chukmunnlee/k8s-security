#!/usr/bin/env bash 

openssl genrsa -out certs/client.key 4096

openssl req -new -key certs/client.key -out certs/client.csr \
	-subj '/CN=apiserver-imagepolicy/O=system:authenticated' \
	-addext 'keyUsage = keyEncipherment, digitalSignature' \
	-addext 'extendedKeyUsage = clientAuth'
