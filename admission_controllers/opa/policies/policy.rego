package kubernetes.admission

deny[msg] {
	input.request.kind.kind == "Pod"
	container = input.request.object.spec.containers[_]
	endswith(container.image, ":latest")
	print(container)
	msg := sprintf("Container %s in Pod %s uses 'latest' tag", [ container.name, input.request.object.metadata.name ])
}

deny[msg] {
	input.request.kind.kind == "Pod"
	container = input.request.object.spec.containers[_]
	container_parts = split(container.image, ":")
	1 == count(container_parts)
	print(container_parts)
	msg := sprintf("Container %s in Pod %s uses 'latest' tag", [ container.name, input.request.object.metadata.name ])
}
