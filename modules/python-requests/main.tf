resource "null_resource" "build" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "pip3 install requests --target ${path.module}/packages/python"
  }
}

module "lambda_layer" {
  source = "../.."

  content_path = "${path.module}/packages/python"
  description = "Python requests package plus dependencies"
  layer_name = "python-requests"
  runtimes = ["python3.6"]

//  depends_on = [null_resource.build]
}