provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "this" {
  ami                    = var.ami                        # AMI ID
  instance_type          = var.instance_type              # Instance type
  subnet_id              = var.subnet_id                  # Subnet ID
  iam_instance_profile   = "AmazonSSMManagedInstanceCore" # IAM instance profile role name
  vpc_security_group_ids = var.vpc_security_group_ids     # Security group IDs

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

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}
