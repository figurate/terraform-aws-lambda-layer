SHELL:=/bin/bash
TERRAFORM_VERSION=0.12.24
TERRAFORM=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

.PHONY: all clean test docs format

all: test docs format

clean:
	rm -rf .terraform/

test:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/aws-sdk-java && $(TERRAFORM) validate modules/aws-sdk-java
		$(TERRAFORM) init modules/groovy-runtime && $(TERRAFORM) validate modules/groovy-runtime
		$(TERRAFORM) init modules/python-requests && $(TERRAFORM) validate modules/python-requests

docs:
	docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./ >./README.md && \
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/aws-sdk-java >./modules/aws-sdk-java/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/groovy-runtime >./modules/groovy-runtime/README.md
		docker run --rm -v "${PWD}:/work" tmknom/terraform-docs markdown ./modules/python-requests >./modules/python-requests/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/aws-sdk-java
		$(TERRAFORM) fmt -list=true ./modules/groovy-runtime
		$(TERRAFORM) fmt -list=true ./modules/python-requests
