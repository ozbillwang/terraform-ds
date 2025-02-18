variable "ami" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-09e143e99e8fa74f9" # Default AMI ID
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "g4dn.xlarge" # Default instance type
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = "subnet-21f5a867" # Default subnet ID
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = ["sg-1e3e347c"] # Default security group IDs
}