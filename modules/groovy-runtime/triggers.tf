locals {
  build_triggers = {
    once   = "once"
    weekly = tonumber(formatdate("", timestamp())) / 4
    daily  = formatdate("DD", timestamp())
    hourly = formatdate("hhZ", timestamp())
    always = timestamp()
  }
}
