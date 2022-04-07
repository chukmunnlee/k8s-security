package kubernetes.admission

deny[msg] {
	input.request.kind.kind == "Pod"
	container = input.request.object.spec.containers[_]
	endswith(container.image, ":latest")
	msg := sprintf("Container %s in Pod %s uses 'latest' tag", [ container.name, input.request.object.metadata.name ])
}
