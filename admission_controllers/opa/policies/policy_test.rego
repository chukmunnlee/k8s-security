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
					},
					{
						"name": "dov-bear",
						"image": "nicolaka/netshoot:v123"
					}
				]
			}
		}
	}
}

input_request_without_tag := {
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
						"image": "chukmunnlee/dov-bear",
					},
				]
			}
		}
	}
}

input_request_without_label := {
	"kind": "AdmissionReview",
	"request": {
		"kind": {
			"kind": "ConfigMap"
		},
		"namespace": "policies",
		"object": {
			"metadata": {
				"name": "mycm",
				"labels": {
					"name": "mycm"
				}
			}
		}
	}
}

test_deny_image_with_latest_tag {
	deny with input as input_request
}

test_deny_image_without_tag {
	deny with input as input_request_without_tag
}

test_deny_configmap {
	deny with input as input_request_without_label
}
