#!/bin/bash
opa run --server \
	--tls-ca-cert-file=./certs/ca.crt \
	--tls-cert-file=./certs/tls.crt \
	--tls-private-key-file=./certs/tls.key \
	--authentication=tls \
	--addr=0.0.0.0:8443 \
	--addr=http://127.0.0.1:8181 \
	--log-format=json-pretty \
	--set=decision_logs.console=true \
	--set=status.console=true 
	--log-level=debug
