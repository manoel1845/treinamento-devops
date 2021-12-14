provider "aws" {
  region = "sa-east-1"
}

data "aws_ami" "ami-ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "k8s_proxy" {
  ami           = data.aws_ami.ami-ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "k8s-haproxy-mineiro"
  }
  vpc_security_group_ids = [aws_security_group.acessos_haproxy.id]
}

resource "aws_instance" "k8s_master" {
  ami           = data.aws_ami.ami-ubuntu.id
  instance_type = "t2.large"
  key_name      = var.key_name
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "k8s-master-0-mineiro"
  }
  vpc_security_group_ids = [aws_security_group.acessos_master.id]
  depends_on = [
    aws_instance.k8s_workers,
  ]
}

resource "aws_instance" "k8s_masters" {
  ami           = data.aws_ami.ami-ubuntu.id
  instance_type = "t2.large"
  key_name      = var.key_name
  count         = 2
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "k8s-master-${count.index + 1}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_masters.id]
  depends_on = [
    aws_instance.k8s_workers,
  ]
}

resource "aws_instance" "k8s_workers" {
  ami           = data.aws_ami.ami-ubuntu.id
  instance_type = "t2.medium"
  key_name      = var.key_name
  count         = 3
  tags = {
    Name = "k8s_workers-${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
}

resource "aws_security_group" "acessos_master" {
  name        = "k8s-acessos_master-mineiro"
  description = "acessos inbound traffic"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "SSH from VPC"
      from_port        = 30000
      to_port          = 30000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "allow_ssh-mineiro"
  }
}


resource "aws_security_group" "acessos_masters" {
  name        = "k8s-acessos_masters-mineiro"
  description = "acessos inbound traffic"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "SSH from VPC"
      from_port        = 30000
      to_port          = 30000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "allow_ssh-mineiro"
  }
}

resource "aws_security_group" "acessos_haproxy" {
  name        = "k8s-haproxy-mineiro"
  description = "acessos inbound traffic"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "allow_haproxy_ssh-mineiro"
  }
}

resource "aws_security_group" "acessos_workers" {
  name        = "k8s-workers-mineiro"
  description = "acessos inbound traffic"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "allow_ssh-mineiro"
  }
}

resource "aws_security_group_rule" "de_masters_para_master" {
  type              = "ingress"
  description       = "Os master (m2,m3) precisam chegar até o master (m1)"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = aws_security_group.acessos_master.id
  security_group_id = aws_security_group.acessos_masters.id
}

resource "aws_security_group_rule" "de_master_para_haprory" {
  type              = "ingress"
  description       = "O master (m1) para o haproxy"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = aws_security_group.acessos_haproxy.id
  security_group_id = aws_security_group.acessos_master.id
}

resource "aws_security_group_rule" "de_masters_para_haprory" {
  type              = "ingress"
  description       = "Os masters (m2,m3) para o haproxy"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = aws_security_group.acessos_haproxy.id
  security_group_id = aws_security_group.acessos_masters.id
}

resource "aws_security_group_rule" "de_workers_para_haprory" {
  type              = "ingress"
  description       = "O workers (w1,w2,w3) para o haproxy"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = aws_security_group.acessos_haproxy.id
  security_group_id = aws_security_group.acessos_workers.id
}

resource "aws_security_group_rule" "de_master_para_workers" {
  type              = "ingress"
  description       = "O master (m1) para o workers"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = aws_security_group.acessos_workers.id
  security_group_id = aws_security_group.acessos_master.id
}

resource "aws_security_group_rule" "de_masters_para_workers" {
  type              = "ingress"
  description       = "O masters (m2, m3) para o workers"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = aws_security_group.acessos_workers.id
  security_group_id = aws_security_group.acessos_masters.id
}

output "k8s-master" {
  value = [
    "k8s-master 1 - ${aws_instance.k8s_master.private_ip} - ssh -i ~/kp-mineiro.pem ubuntu@${aws_instance.k8s_master.public_dns} -o ServerAliveInterval=60"
  ]
}

output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master ${key+2} - ${item.private_ip} - ssh -i ~/kp-mineiro.pem ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
      "k8s-workers ${key+1} - ${item.private_ip} - ssh -i ~/kp-mineiro.pem ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_proxy" {
  value = [
    "k8s_proxy - ${aws_instance.k8s_proxy.private_ip} - ssh -i ~/kp-mineiro.pem ubuntu@${aws_instance.k8s_proxy.public_dns} -o ServerAliveInterval=60"
  ]
}

output "security-group-workers-e-haproxy" {
  value = aws_security_group.acessos_haproxy.id
}



# terraform refresh para mostrar o ssh
