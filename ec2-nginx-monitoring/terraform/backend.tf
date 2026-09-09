terraform{
    backend "s3" {
        bucket = "my-nginx-server-health-bucket-123"
        key    = "terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true #For state locking and consistency checking, set to true
}
}