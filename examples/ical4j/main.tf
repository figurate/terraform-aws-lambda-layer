module "build" {
  source = "figurate/docker-container/docker//modules/gradle"
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.root}/build/layer"
  description  = "iCal4j java library"
  layer_name   = "ical4j"
  runtimes     = ["java8"]
  dry_run      = var.dry_run

  depends_on = [module.build]
}
