SHELL:=/bin/bash
include .env

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
VERSION=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test diagram docs format release

all: test docs format

clean:
	rm -rf .terraform/ terraform.tfstate* examples/ical4j/build ical4j.zip opentracing.zip

validate:
	$(TERRAFORM) init  && $(TERRAFORM) validate

test: validate
	$(CHECKOV) -d /work
	$(TFSEC) /work

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./ >./README.md && \
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/aws-sdk-java >./modules/aws-sdk-java/README.md && \
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/groovy-runtime >./modules/groovy-runtime/README.md && \
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/python-requests >./modules/python-requests/README.md

format:
	$(TERRAFORM) fmt -list=true -recursive

example:
	$(TERRAFORM) -chdir=examples/$(EXAMPLE) init  && $(TERRAFORM) -chdir=examples/$(EXAMPLE) plan -input=false

release: test
	git tag $(VERSION) && git push --tags
