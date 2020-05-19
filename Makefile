SHELL:=/bin/bash
TERRAFORM_VERSION=0.12.24
TERRAFORM=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

.PHONY: all clean test docs format

all: test docs format

clean:
	rm -rf .terraform/

test:
	$(TERRAFORM) init && $(TERRAFORM) validate

aws-sdk-java:
	$(TERRAFORM) init modules/aws-sdk-java && $(TERRAFORM) plan modules/aws-sdk-java

groovy-runtime:
	$(TERRAFORM) init modules/groovy-runtime && $(TERRAFORM) plan modules/groovy-runtime

python-requests:
	$(TERRAFORM) init modules/python-requests && $(TERRAFORM) plan modules/python-requests

docs:
	docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./ >./README.md

format:
	$(TERRAFORM) fmt -list=true ./
