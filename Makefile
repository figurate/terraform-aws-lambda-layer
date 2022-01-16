SHELL:=/bin/bash
include .env

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test docs format

all: validate test docs format

clean:
	rm -rf .terraform/ terraform.tfstate* examples/ical4j/build ical4j.zip opentracing.zip

validate:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/aws-sdk-java && $(TERRAFORM) validate modules/aws-sdk-java && \
		$(TERRAFORM) init modules/groovy-runtime && $(TERRAFORM) validate modules/groovy-runtime && \
		$(TERRAFORM) init modules/python-requests && $(TERRAFORM) validate modules/python-requests

test: validate
	$(CHECKOV) -d /work && \
		$(CHECKOV) -d /work/modules/aws-sdk-java && \
		$(CHECKOV) -d /work/modules/groovy-runtime && \
		$(CHECKOV) -d /work/modules/python-requests

	$(TFSEC) /work && \
		$(TFSEC) /work/modules/aws-sdk-java && \
		$(TFSEC) /work/modules/groovy-runtime && \
		$(TFSEC) /work/modules/python-requests

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
	$(TERRAFORM) init -upgrade examples/$(EXAMPLE) && $(TERRAFORM) plan examples/$(EXAMPLE)
