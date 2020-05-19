variable "layer_name" {
  description = "Name of the lambda layer"
}

variable "description" {
  description = "A short description of the layer contents"
}

variable "content_path" {
  description = "Path to content to include in the layer"
}

variable "runtimes" {
  description = "List of compatible runtimes for the lambda layer"
  type        = list(string)
}
