module "build" {
  source = "figurate/docker-container/docker//modules/gradle"

  host_path = abspath(path.root)
}

module "lambda_layer" {
  source = "../.."

  content_path = "${module.build.output_dir}/layer"
  description  = "Open Tracing java library"
  layer_name   = "opentracing"
  runtimes     = ["java8"]
  dry_run      = var.dry_run

  depends_on = [module.build]
}
