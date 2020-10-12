module "build" {
  source = "figurate/docker-container/docker//modules/gradle"
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.root}/build/layer"
  description  = "Groovy runtime libraries"
  layer_name   = "groovy-runtime"
  runtimes     = ["java8"]
  dry_run      = var.dry_run

  depends_on = [module.build]
}
