package armo_builtins


# Fails if workload doas not have replicas more than one
deny[msga] {
    wl := input[_]
	spec_template_spec_patterns := {"Deployment","ReplicaSet","StatefulSet"}
	spec_template_spec_patterns[wl.kind]
    spec := wl.spec
    result := replicasOneOrLess(spec)
	msga := {
		"alertMessage": sprintf("Workload: %v: %v   doas not have replicas more than one", [ wl.kind, wl.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"failedPaths": [result],
		"alertObject": {
			"k8sApiObjects": [wl]
		}
	}
}


replicasOneOrLess(spec) = path {
	not spec.replicas
	path = ""
}

replicasOneOrLess(spec) = path{
	spec.replicas == 1
	path = "spec.replicas"
}
