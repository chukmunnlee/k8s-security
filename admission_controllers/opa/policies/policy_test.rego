package kubernetes.admission

input_request := {
	"kind": "AdmissionReview",
	"request": {
		"kind": {
			"kind": "Pod"
		},

		"object": {
			"metadata": {
				"name": "myapp"
			},
			"spec": {
				"containers": [
					{
						"name": "dov-bear",
						"image": "chukmunnlee/dov-bear:v1",
					},
					{
						"name": "dov-bear",
						"image": "nicolaka/netshoot:latest"
					}
				]
			}
		}
	}
}

test_deny_image_with_latest_tag {
	deny with input as input_request
}

