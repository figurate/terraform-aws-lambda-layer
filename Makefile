SHELL:=/bin/bash
include .env

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
VERSION=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test diagram docs format release

all: test docs format

clean:
	rm -rf .terraform/ terraform.tfstate* examples/ical4j/build ical4j.zip opentracing.zip

validate:
	$(TERRAFORM) init -upgrade && $(TERRAFORM) validate && \
		$(TERRAFORM) -chdir=modules/aws-sdk-java init -upgrade && $(TERRAFORM) -chdir=modules/aws-sdk-java validate && \
		$(TERRAFORM) -chdir=modules/groovy-runtime init -upgrade && $(TERRAFORM) -chdir=modules/groovy-runtime validate && \
		$(TERRAFORM) -chdir=modules/python-requests init -upgrade && $(TERRAFORM) -chdir=modules/python-requests validate

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
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/aws-sdk-java && \
		$(TERRAFORM) fmt -list=true ./modules/groovy-runtime && \
		$(TERRAFORM) fmt -list=true ./modules/python-requests && \
		$(TERRAFORM) fmt -list=true ./examples/ical4j && \
		$(TERRAFORM) fmt -list=true ./examples/opentracing

example:
	$(TERRAFORM) -chdir=examples/$(EXAMPLE) init -upgrade && $(TERRAFORM) -chdir=examples/$(EXAMPLE) plan -input=false

release: test
	git tag $(VERSION) && git push --tags
