module "build" {
  source  = "figurate/docker-container/docker//modules/gradle"
  version = "1.0.9"

  host_path = abspath(path.module)
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.module}/build/layer"
  description  = "Groovy runtime libraries"
  layer_name   = "groovy-runtime"
  runtimes     = ["java8"]
  dry_run      = var.dry_run

  depends_on = [module.build]
}
