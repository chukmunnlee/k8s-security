#!/bin/bash
BASE_DIR=./certs
SERVICE="webhook-js-svc"
NAMESPACE="webhook-js"

rm -rf ${BASE_DIR}
mkdir -p ${BASE_DIR}

# generate self sign certificate
openssl genrsa -out ${BASE_DIR}/ca 

openssl req -x509 -key ${BASE_DIR}/ca -out ${BASE_DIR}/ca.crt \
	-days 365 -sha256 \
	-subj '/CN=webhook-js-ca'

openssl genrsa -out ${BASE_DIR}/tls.key

openssl req -new -key ${BASE_DIR}/tls.key -out ${BASE_DIR}/tls.csr \
	-subj "/CN=${SERVICE}.${NAMESPACE}.svc" \
	-addext "subjectAltName = DNS:${SERVICE}.${NAMESPACE}.svc, DNS:${SERVICE}.${NAMESPACE}.svc.cluster.local" \
	-addext "extendedKeyUsage = serverAuth"


openssl x509 -req -in ${BASE_DIR}/tls.csr -out ${BASE_DIR}/tls.crt \
	-days 365 -sha256 \
	-CA ${BASE_DIR}/ca.crt -CAkey ${BASE_DIR}/ca -CAcreateserial \
	-extfile <(printf "subjectAltName = DNS:${SERVICE}.${NAMESPACE}.svc, DNS:${SERVICE}.${NAMESPACE}.svc.cluster.local\nextendedKeyUsage = serverAuth\n")

rm ${BASE_DIR}/tls.csr
