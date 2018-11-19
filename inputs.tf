variable "gitlab_server" {
  description = "Gitlab Server URL"
}

variable "ec2_instance_type" {
  description = "EC2 instance type. Defines how performant and costly the runner is."
}

variable "gitlab_runner_image_version" {
  description = "The runner's docker image version. See https://hub.docker.com/r/gitlab/gitlab-runner/tags/"
}

variable "runner_name" {
  description = "Name of the runner. Will also be used to name the EC2 instance and security group."
}

variable "token" {
  description = "Gitlab CI token. Can be obtained from project settings on Gitlab."
}

variable "ssh_key_name" {
  description = "Name of an existing AWS Key Pair (SSH). SSH is needed for Terraform to provision the EC2 instance."
}

variable "ssh_private_key_path" {
  description = "File path to private SSH key for the given AWS Key Pair. SSH is needed for Terraform to provision the EC2 instance."
}
