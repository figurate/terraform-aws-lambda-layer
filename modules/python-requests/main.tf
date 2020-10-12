module "build" {
  source = "figurate/docker-container/docker//modules/python"

  command = ["pip3", "install", "requests", "--target", "${path.root}/packages/python"]
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.rot}/packages/python"
  description  = "Python requests package plus dependencies"
  layer_name   = "python-requests"
  runtimes     = ["python3.6"]
  dry_run      = var.dry_run

  depends_on = [module.build]
}
