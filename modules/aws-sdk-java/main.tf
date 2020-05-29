resource "null_resource" "build" {
  triggers = {
    build = local.build_triggers[var.build_frequency]
  }
  provisioner "local-exec" {
    command = "${path.module}/gradlew build"
  }
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.module}/build/layer"
  description  = "Java implementation of the AWS SDK"
  layer_name   = "aws-sdk-java"
  runtimes     = ["java8"]

  //  depends_on = [null_resource.build]
}
