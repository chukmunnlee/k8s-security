#!/usr/bin/env bash
CERT_DIR="./certs"

SERVICE="opa"
NAMESPACE="opa-ns"

rm -rf ${CERT_DIR}

mkdir ${CERT_DIR}

# generate CA
openssl genrsa -out ${CERT_DIR}/ca.key 4096
openssl req -x509 -key ${CERT_DIR}/ca.key -out ${CERT_DIR}/ca.crt \
	-days 365 -sha256 -subj '/CN=ca-opa'

# generate serving certificates
openssl genrsa -out ${CERT_DIR}/tls.key 4096
openssl req -new -key ${CERT_DIR}/tls.key -out ${CERT_DIR}/tls.csr \
	-subj "/CN=${SERVICE}.${NAMESPACE}.svc" \
	-addext "subjectAltName = DNS:${SERVICE}.${NAMESPACE}.svc" \
	-addext "keyUsage = nonRepudiation, digitalSignature, keyEncipherment" \
	-addext "extendedKeyUsage = serverAuth, clientAuth"

openssl x509 -req -in ${CERT_DIR}/tls.csr -out ${CERT_DIR}/tls.crt \
	-days 365 -sha256 \
	-CA ${CERT_DIR}/ca.crt -CAkey ${CERT_DIR}/ca.key -CAcreateserial \
	-extfile <(printf "subjectAltName = DNS:%s.%s.svc\nkeyUsage = nonRepudiation, digitalSignature, keyEncipherment\nextendedKeyUsage = serverAuth, clientAuth" ${SERVICE} ${NAMESPACE})

rm ${CERT_DIR}/tls.csr
