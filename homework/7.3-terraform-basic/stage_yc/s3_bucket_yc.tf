
terraform {
  backend "s3" {
    endpoint             = "storage.yandexcloud.net"
    bucket               = "netbucket"
    region               = "ru-central1"
    workspace_key_prefix = "environments"
    key                  = "terraform.tfstate"
    access_key           = "YCA***"
    secret_key           = "***P7"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}