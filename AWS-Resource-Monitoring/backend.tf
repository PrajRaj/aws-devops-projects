terraform{
    required_version = ">= 1.0.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    backend "s3" {
        bucket = "my-nginx-server-health-bucket-123"
        key    = "resource_monitoring/terraform.tfstate" # The path within the bucket where the state file of this project will be stored
        region = "us-east-1"
        encrypt = true
        # use_lockfile = true #For state locking and consistency checking, set to true
}
}