module "build" {
  source  = "figurate/docker-container/docker//modules/gradle"
  version = "1.0.9"

  host_path = abspath(path.module)
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.module}/build/layer"
  description  = "Java implementation of the AWS SDK"
  layer_name   = "aws-sdk-java"
  runtimes     = ["java8"]
  dry_run      = var.dry_run

  depends_on = [module.build]
}
