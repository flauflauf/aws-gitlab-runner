provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "gitlab-runner" {
  name = "${var.runner_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow inbound ssh from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound traffic"
  }
}

resource "aws_instance" "gitlab-runner" {
  # CoreOS Container Linux stable 1855.4.0 (HVM)
  ami = "ami-0b088568a857b7c27"

  instance_type   = "${var.ec2_instance_type}"
  key_name        = "${var.ssh_key_name}"
  security_groups = ["${aws_security_group.gitlab-runner.name}"]

  tags {
    Name = "${var.runner_name}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "core"
      private_key = "${file("${var.ssh_private_key_path}")}"
    }

    inline = [
      "sudo systemctl enable docker",
      "docker run -d -e DOCKER_IMAGE=ruby:2.1 -e RUNNER_NAME=${var.runner_name} -e CI_SERVER_URL=${var.gitlab_server} -e REGISTRATION_TOKEN=${var.token} -e RUNNER_EXECUTOR=docker -e REGISTER_NON_INTERACTIVE=true --name gitlab-runner --restart always -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:${var.gitlab_runner_image_version}",
      "docker exec -it gitlab-runner gitlab-runner register --docker-privileged",
    ]
  }
}

output "gitlab_runner_public_dns" {
  value = "${aws_instance.gitlab-runner.public_dns}"
}
