terraform {
  backend "s3" {
    endpoint             = "storage.yandexcloud.net"
    bucket               = "rusdevops-bucket"
    region               = "ru-central1"
    workspace_key_prefix = "environments"
    key                  = "terraform.tfstate"
    access_key           = "***"
    secret_key           = "***"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}