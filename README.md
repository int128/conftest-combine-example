# conftest-combine-example ![test](https://github.com/int128/conftest-combile-example/workflows/test/badge.svg)

This is an example to validate Kubernetes manifests with a cross-document rule using conftest.


## Example use case

When you create a HPA (horizontal pod autoscaler) resource, you need to remove `replicas` field from the corresponding Deployment resource.
This is because HPA automatically sets `replicas` field and it should not be changed in CIOps/GitOps. See also [the best practice in Argo CD](https://argoproj.github.io/argo-cd/user-guide/best_practices/).

You can test this rule using [conftest](https://www.conftest.dev/).

This repository contains manifests [`HorizontalPodAutoscaler`](hpa.yaml) and [`Deployment`](deployment.yaml) which has `replicas` field.
You can validate the manifests:

```console
% make
kustomize build | conftest test -i yaml --combine -
FAIL - Combined - Do not set replicas of Deployment[name=php-apache] with HorizontalPodAutoscaler[name=php-apache]

1 test, 0 passed, 0 warnings, 1 failure, 0 exceptions
make: *** [conftest] Error 1
```

See [`dont_set_replicas_with_hpa.rego`](./policy/dont_set_replicas_with_hpa.rego).


## How it works

conftest supports `--combine` flag to test a cross-document rule.

It is recommended to pack manifest files into a single file using kustomize when `--combine` flag is enabled.
This is because `input` variable is an array of documents if file has multiple documents.
See [conftest#138](https://github.com/open-policy-agent/conftest/issues/138) for details.
