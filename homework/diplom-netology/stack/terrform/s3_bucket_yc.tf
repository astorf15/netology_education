terraform {
  backend "s3" {
    endpoint             = "storage.yandexcloud.net"
    bucket               = "rusdevops-bucket"
    region               = "ru-central1"
    workspace_key_prefix = "environments"
    key                  = "terraform.tfstate"
    access_key           = "YCAJECc06O1uh3b-TaAacKnGB"
    secret_key           = "YCM6vp3ONPCLCBNGv2Mo7EhjM4_4Ap5ekJEptxP7"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}