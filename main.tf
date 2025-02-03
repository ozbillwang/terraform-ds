provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "example" {
  ami                    = "ami-09e143e99e8fa74f9" # AMI ID
  #instance_type          = "t2.large"              # Instance type
  instance_type          = "g4dn.xlarge"
  subnet_id              = "subnet-21f5a867"       # Subnet ID
  iam_instance_profile   = "AmazonSSMManagedInstanceCore"          # IAM instance profile role name
  vpc_security_group_ids = ["sg-1e3e347c"]         # Security group ID

  root_block_device {
    volume_size = 20    # Root volume size in GB
    volume_type = "gp2" # General Purpose SSD
  }

  user_data = <<-EOF
              #!/bin/bash

              # Update the system
              apt-get update -y

              # Install dependencies
              apt-get install -y curl

              # Download and install Ollama
              curl -fsSL https://ollama.ai/install.sh | sh
              sed -i '/\[Service\]/a Environment="OLLAMA_HOST=0.0.0.0"' /etc/systemd/system/ollama.service

              # Start the Ollama service
              systemctl start ollama

              # Enable Ollama to start on boot
              systemctl enable ollama

              # Optional: Verify the service is running
              export HOME="/root"
              sleep 5
              systemctl status ollama
              for i in {1..10}
              do
               ollama pull deepseek-r1:8b
              done 

              EOF

  tags = {
    Name = "deepseek-r1"
  }
}
