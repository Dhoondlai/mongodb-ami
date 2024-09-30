packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "mongodb-ubuntu-22" {
  ami_name      = "mongodb-ubuntu-22"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"

    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username    = "ubuntu"
  skip_create_ami = var.skip_create_ami
  force_deregister = true # to save space
  force_delete_snapshot = true # to save space
}

build {
  name = "mongodb-ubuntu-22"
  sources = [
    "source.amazon-ebs.mongodb-ubuntu-22"
  ]


  provisioner "shell" {
    inline = [
      "echo Setting up MongoDB",
      "sleep 30",
      "sudo apt-get install gnupg curl",
      "curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor",
      "echo 'deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org",
      "sudo systemctl daemon-reload",
      "sudo systemctl start mongod",
    ]
  }

}
