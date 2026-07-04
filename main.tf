terraform {
  required_version = ">= 1.5"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "app_config" {
  filename = "${path.module}/generated/config.txt"
  content  = "version=1\nenvironment=dev"
}

resource "local_file" "legacy_marker" {
  filename = "${path.module}/generated/legacy.txt"
  content  = "deprecated=true"
}
