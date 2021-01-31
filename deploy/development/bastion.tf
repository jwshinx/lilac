data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "bastion" {
  name               = "${local.project}-${local.prefix}-bastion"
  assume_role_policy = file("./templates/bastion/instance-profile-policy.json")

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "bastion_attach_policy" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.project}-${local.prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion.name
}

# ami-02354e95b39ca8dec
# amzn2-ami-hvm-2.0.20200722.0-x86_64-gp2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  user_data            = file("./templates/bastion/user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  key_name             = aws_key_pair.auth.id
  subnet_id            = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  # export TF_LOG=TRACE
  # export TF_LOG=
  provisioner "file" {
    source      = "templates/bastion/postgres-init.sql"
    destination = "/home/ec2-user/postgres-init.sql"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.private_key_path)
      timeout     = "5m"
      agent       = false
    }
  }

  tags = merge(
    local.common_tags,
    map("Name", "${local.project}-${local.prefix}-bastion")
  )
}
