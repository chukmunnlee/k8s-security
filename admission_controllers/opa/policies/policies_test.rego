package kubernetes.admission

data1 = {
	"request": {
		"uid": "abc123",
		"kind": {
			"kind": "Pod"
		},
		"operation": "CREATE",
		"object": {
			"metadata": {
				"name": "nginx1-18"
			},
			"spec": {
				"containers": [
					{
						"name": "nginx",
						"image": "nginx:1.18",
					}
				]
			}
		}
	}
}

data2 = {
	"request": {
		"uid": "abc123",
		"kind": {
			"kind": "Pod"
		},
		"operation": "CREATE",
		"object": {
			"metadata": {
				"name": "nginx-latest-tag"
			},
			"spec": {
				"containers": [
					{
						"name": "nginx",
						"image": "nginx:latest",
					}
				]
			}
		}
	}
}

data3 = {
	"request": {
		"uid": "abc123",
		"kind": {
			"kind": "Pod"
		},
		"operation": "CREATE",
		"object": {
			"metadata": {
				"name": "nginx-implicit-latest"
			},
			"spec": {
				"containers": [
					{
						"name": "nginx",
						"image": "nginx",
					}
				]
			}
		}
	}
}

data4 = {
	"request": {
		"uid": "abc123",
		"kind": {
			"kind": "Pod"
		},
		"operation": "CREATE",
		"object": {
			"metadata": {
				"name": "nginx-1.19",
				"namespace": "policies"
			},
			"spec": {
				"containers": [
					{
						"name": "nginx",
						"image": "nginx:1.18"
					}
				]
			}
		}
	}
}

data5 = {
	"request": {
		"uid": "abc123",
		"kind": {
			"kind": "ConfigMap",
		},
		"operation": "CREATE",
		"object": {
			"metadata": {
				"name": "app-cm",
				"namespace": "policies"
			},
			"data": {
				"db_password": "changeit"
			}
		}
	}
}

data6 = {
	"request": {
		"uid": "abc123",
		"kind": {
			"kind": "ConfigMap",
		},
		"operation": "CREATE",
		"object": {
			"metadata": {
				"name": "app-cm",
				"namespace": "policies",
				"labels": {
					"openpolicyagent.org/policy": "abc"
				}
			},
			"data": {
				"db_password": "changeit"
			}
		}
	}
}

test_allow_images {
	count(deny) == 0 with input as data1
}

test_deny_images_latest {
	count(deny) > 0 with input as data2
}

test_deny_images_without_tag {
	count(deny) > 0 with input as data3
}

test_deny_deploy_into_policies {
	count(deny) > 0 with input as data4
}

test_deny_not_rego_policy_0 {
	count(deny) > 0 with input as data5
}

test_deny_not_rego_policy_1 {
	count(deny) > 0 with input as data6
}
