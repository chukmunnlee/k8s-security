package kubernetes.admission 

import input.request as req
import input.request.object as obj

is_create_update(oper) { { "CREATE", "UPDATE" }[oper] }

deny[msg] {

	"Pod" == req.kind.kind

	is_create_update(req.operation)

	endswith(obj.spec.containers[_].image, ":latest")

	msg := sprintf("Containers in pod %s uses :latest tag", [ obj.metadata.name ])
}

deny[msg] {

	"Pod" == req.kind.kind

	is_create_update(req.operation)

	count(split(obj.spec.containers[_].image, ":")) == 1

	msg := sprintf("Containers in pod %s implicitly uses latest tag", [ obj.metadata.name ])
}

deny[msg] {

	is_create_update(req.operation)

	"policies" == obj.metadata.namespace
	"ConfigMap" != req.kind.kind

	msg := sprintf("%s is not a Rego policy; only policies can be deployed into polices namespace", [ obj.metadata.name ])
}

deny[msg] {

	is_create_update(req.operation)

	"policies" == obj.metadata.namespace
	"ConfigMap" == req.kind.kind
	not obj.metadata.labels["openpolicyagent.org/policy"]

	msg := sprintf("ConfigMap %s is not a Rego policy", [ obj.metadata.name ])
}

deny[msg] {

	is_create_update(req.operation)

	"policies" == obj.metadata.namespace
	"ConfigMap" == req.kind.kind
	"rego" != obj.metadata.labels["openpolicyagent.org/policy"]

	msg := sprintf("ConfigMap %s is not a Rego policy", [ obj.metadata.name ])
}

