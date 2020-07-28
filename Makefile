.PHONY: conftest
conftest:  $(wildcard *.yaml)
	kustomize build | conftest test -i yaml --combine -
