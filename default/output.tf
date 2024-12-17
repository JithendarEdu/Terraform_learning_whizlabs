output "ami_id" { #ami_id = "ami-05f86c88d902e4a4e"
  value = aws_ami_from_instance.ec2ami.id
}

#4. In the above code, we will extract the ami id of the created EC2 AMI and display it once the resources are created. 