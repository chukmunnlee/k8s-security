package system

input_request := {
	"apiVersion": "admission.k8s.io/v1",
	"kind": "AdmissionReview",
	"request": {
		"uid": "d7a7aa53-3f8a-4c06-a6c2-6ca0ad49c85f"
	}
}

admission = {
	"deny": [ "abc", "123" ]
}

test_system_main {
	main with input as input_request with data.kubernetes.admission as admission
}
