package kubernetes.admission

deny[msg] {
	input.request.kind.kind == "Pod"
	container = input.request.object.spec.containers[_]
	endswith(container.image, ":latest")
	msg := sprintf("Container %s in Pod %s uses 'latest' tag", [ container.name, input.request.object.metadata.name ])
}

deny[msg] {
	input.request.kind.kind == "Pod"
	container = input.request.object.spec.containers[_]
	container_parts = split(container.image, ":")
	1 == count(container_parts)
	msg := sprintf("Container %s in Pod %s uses 'latest' tag", [ container.name, input.request.object.metadata.name ])
}

deny[msg] {
	input.request.namespace == "policies"
	not input.request.kind.kind == "ConfigMap"
	msg := "Only OPA configmap policies can be deployed to policies namespace"
}

deny[msg] {
	input.request.namespace == "policies"
	input.request.kind.kind == "ConfigMap"
	#TODO how to check openpolicyagent.org/policy
	not "rego" == input.request.object.metadata.labels["openpolicyagent.org"]
	msg := "Only OPA configmap policies with openpolicyagent.org/policy=rego label can be deployed to policies namespace"
}
