/**
 * # ![AWS](aws-logo.png) Lambda Layer
 *
 * Purpose: Provision a Lambda Layer in AWS.
 *
 * Rationale: Provide templates for Lambda dependencies.
 */
data "archive_file" "layer" {
  output_path = "${var.layer_name}.zip"
  type        = "zip"
  source_dir  = var.content_path
}

resource "aws_lambda_layer_version" "layer" {
  count               = var.dry_run ? 0 : 1
  filename            = data.archive_file.layer.output_path
  layer_name          = var.layer_name
  description         = var.description
  compatible_runtimes = var.runtimes
  source_code_hash    = filesha256(data.archive_file.layer.output_path)
}
