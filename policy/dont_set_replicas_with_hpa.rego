package main

deny[msg] {
    f1 := input[_]
    f2 := input[_]
    workload := f1[_]
    hpa := f2[_]

    hpa.apiVersion == "autoscaling/v1"
    hpa.kind == "HorizontalPodAutoscaler"
    workload.apiVersion == hpa.spec.scaleTargetRef.apiVersion
    workload.kind == hpa.spec.scaleTargetRef.kind
    workload.metadata.name == hpa.spec.scaleTargetRef.name
    workload.spec.replicas != null

    msg = sprintf("Do not set replicas of %s[name=%s] with %s[name=%s]", [
        workload.kind,
        workload.metadata.name,
        hpa.kind,
        hpa.metadata.name,
    ])
}
