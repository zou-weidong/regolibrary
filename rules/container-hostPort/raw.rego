package armo_builtins


# Fails if pod has container with hostPort
deny[msga] {
    pod := input[_]
    pod.kind == "Pod"
    container := pod.spec.containers[i]
	begginingOfPath := "spec."
	result := isHostPort(container, i, begginingOfPath)
	msga := {
		"alertMessage": sprintf("Container: %v has Host-port", [ container.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"failedPaths": [result],
		"alertObject": {
			"k8sApiObjects": [pod]
		}
	}
}

# Fails if workload has container with hostPort
deny[msga] {
    wl := input[_]
	spec_template_spec_patterns := {"Deployment","ReplicaSet","DaemonSet","StatefulSet","Job"}
	spec_template_spec_patterns[wl.kind]
    container := wl.spec.template.spec.containers[i]
	begginingOfPath := "spec.template.spec."
    result := isHostPort(container, i, begginingOfPath)
	msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   has Host-port", [ container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"failedPaths": [result],
		"alertObject": {
			"k8sApiObjects": [wl]
		}
	}
}

# Fails if cronjob has container with hostPort
deny[msga] {
  	wl := input[_]
	wl.kind == "CronJob"
	container = wl.spec.jobTemplate.spec.template.spec.containers[i]
	begginingOfPath := "spec.jobTemplate.spec.template.spec."
    result := isHostPort(container, i, begginingOfPath)
    msga := {
		"alertMessage": sprintf("Container: %v in %v: %v   has Host-port", [ container.name, wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"failedPaths": [result],
		"alertObject": {
			"k8sApiObjects": [wl]
		}
	}
}



isHostPort(container, i, begginingOfPath) = path {
	ports := container.ports[j]
    ports.hostPort
	path = sprintf("%vcontainers[%v].ports[%v].hostPort", [begginingOfPath, format_int(i, 10), format_int(j, 10)])
}