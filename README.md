# ![AWS](aws-logo.png) Lambda Layer

[![CI](https://github.com/figurate/terraform-aws-lambda-layer/actions/workflows/main.yml/badge.svg)](https://github.com/figurate/terraform-aws-lambda-layer/actions/workflows/main.yml)

![AWS Lambda Layer](aws\_lambda\_layer.png)  
Purpose: Provision a Lambda Layer in AWS.

Rationale: Provide templates for Lambda dependencies.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| content\_path | Path to content to include in the layer | `any` | n/a | yes |
| description | A short description of the layer contents | `any` | n/a | yes |
| dry\_run | Flag to disable lambda layer deployment | `bool` | `true` | no |
| layer\_name | Name of the lambda layer | `any` | n/a | yes |
| runtimes | List of compatible runtimes for the lambda layer | `list(string)` | n/a | yes |

## Outputs

No output.

