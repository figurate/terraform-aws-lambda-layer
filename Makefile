SHELL:=/bin/bash
TERRAFORM_VERSION=0.13.4
TERRAFORM=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

TERRAFORM_DOCS=docker run --rm -v "${PWD}:/work" tmknom/terraform-docs

CHECKOV=docker run --rm -t -v "${PWD}:/work" bridgecrew/checkov

TFSEC=docker run --rm -it -v "${PWD}:/work" liamg/tfsec

DIAGRAMS=docker run -t -v "${PWD}:/work" figurate/diagrams python

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test docs format

all: validate test docs format

clean:
	rm -rf .terraform/

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
		$(TERRAFORM) fmt -list=true ./examples/ical4j

example:
	$(TERRAFORM) init examples/$(EXAMPLE) && $(TERRAFORM) plan examples/$(EXAMPLE)
