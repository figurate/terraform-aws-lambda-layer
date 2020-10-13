module "build" {
  source  = "figurate/docker-container/docker//modules/python"
  version = "1.0.9"

  host_path = abspath(path.module)
  command   = ["pip3", "install", "requests", "--target", "packages/python"]
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.module}/packages/python"
  description  = "Python requests package plus dependencies"
  layer_name   = "python-requests"
  runtimes     = ["python3.6"]
  dry_run      = var.dry_run

  depends_on = [module.build]
}
