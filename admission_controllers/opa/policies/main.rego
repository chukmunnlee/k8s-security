package system

import data.kubernetes.admission

default uid = ""

uid = input.request.uid

main = {
	"apiVersion": "admission.k8s.io/v1",
	"kind": "AdmissionReview",
	"response": response
}

response = {
	"allowed": false,
	"uid": uid,
	"status": {
		"message": reason
	}
} {
	reason := concat(", ", admission.deny)
	"" != trim_space(reason)
}

else = { 
	"allowed": true,
	"uid": uid
}
