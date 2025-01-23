variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the web app"
  type        = string
  default     = "web-app"
}

variable "environment_name" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "ami" {
  description = "Machine image used for ec2 inst."
  type        = string
  default     = "ami-011899242bb902164"
}

variable "instance_type" {
  description = "ec2 inst. type"
  type        = string
  default     = "t2.micro"
}
