provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# In the above code, you are defining the provider as aws. 

# 5. Next, we want to tell Terraform to create a Security Group within AWS EC2, and populate it with rules to allow traffic on specific ports. In our case, we are allowing the ssh and tcp port 80 (HTTP). 

# 6. We also want to make sure the instance can connect outbound on any port, so we’re including an egress section below as well. 

# 7. Paste the below content into the main.tf file after the provider. 
resource "aws_security_group" "ec2sg" {
  name = "EC2-SG"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 8. Let's add another set of code after security group creation where you will create EC2 instance. 

# 9. In the below code, we have defined the Amazon Linux 2 AMI. The AMI ID mentioned above is for the us-east-1 region. 

# 10. We have mentioned the instance type as t2.micro. The security group ID is automatically taken by using the variable which we have set during the creation process. 

# 11. We have added the user data to install the apache server and add a html page. 

# 12. We have provided tags for the EC2 instance. 

resource "aws_instance" "ec2instance" {
  ami              = "ami-0c101f26f147fa7fd" #azure machine image id
  instance_type    = "t2.micro"
  security_groups  = ["${aws_security_group.ec2sg.name}"]
 
  user_data = <<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install httpd -y
    echo "<html><h1> Welcome to Whizlabs </h1></html>" >> /var/www/html/index.html  
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Name = "MyEC2Server"
  }
}

#13. Let's add another set of code after EC2 Instances creation where you will create the ec2 ami using the ec2 instance created.
resource "aws_ami_from_instance" "ec2ami" {
  name               = "MyEC2Image"
  source_instance_id = aws_instance.ec2instance.id
}


resource "aws_instance" "ec2amiinstance" {
  ami              = aws_ami_from_instance.ec2ami.id
  instance_type    = "t2.micro"
  security_groups  = ["${aws_security_group.ec2sg.name}"]
 
  tags = {
    Name = "MyEC2AMIServer"
  }
}
