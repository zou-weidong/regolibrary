package armo_builtins


# Fails if namespace does not have service accounts (not incluiding default)
deny[msga] {
	namespace := input[_]
	namespace.kind == "Namespace"
	serviceAccounts := [serviceaccount |  serviceaccount= input[_]; isGoodSA(serviceaccount, namespace.metadata.name)]
	count(serviceAccounts) < 1
	msga := {
		"alertMessage": sprintf("Namespace: %v does not have any service accounts besides 'default'", [namespace.metadata.name]),
		"packagename": "armo_builtins",
		"alertScore": 7,
		"failedPaths": [""],
		"alertObject": {
			"k8sApiObjects": [namespace]
		}
	}
}
	
	
isGoodSA(sa, namespace) { 
	sa.kind == "ServiceAccount"
	sa.metadata.namespace == namespace
	sa.metadata.name != "default"
}