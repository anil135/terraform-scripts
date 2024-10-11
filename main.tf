# Specify the provider (AWS)
provider "aws" {
  region = "us-east-1" # Specify the region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


# Create a security group to allow SSH access for Ubuntu
resource "aws_security_group" "ubuntu_sg" {
  name        = "ubuntu-gs"
  description = "Allow SSH access, Postgresql, nodejs"


  ingress {
    from_port   = 22        #for SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 5432      #for postgresql
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 3000      #for node js
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  

  }

  ingress {
    from_port   = 8080      #for jenkins
    to_port     = 8080
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

# Define the AWS EC2 instance (Ubuntu)
resource "aws_instance" "my_ubuntu_ec2_instance" {
  ami           = "ami-0e86e20dae9224db8"  # Replace with a valid Ubuntu AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "interview-key"  # Ensure this key pair exists in your AWS account

  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]

  tags = {
    Name = "Ubuntu-Demo"
  }
}

#Define the AWS EC2 instance (Windows)


# Define Security Group for Windows
resource "aws_security_group" "windows_sg" {
  name        = "windows_sg"
  description = "Security group for Windows EC2 instance, postgresql, nodejs"


  ingress {
    from_port   = 3389  # RDP port
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow RDP access from all IPs (not recommended for production)
  }

   ingress {
    from_port   = 5432      #for postgresql
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 3000      #for node js
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  

  }

  ingress {
    from_port   = 5986      #for WinRm https connection
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  

  }

  ingress {
    from_port   = 5985      #for WinRm http connection
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}


resource "aws_instance" "my_windows_ec2_instance" {
  ami           = "ami-0888db1202897905c"  # Replace with a valid Windows AMI ID for your region
  instance_type = "t2.micro"
  key_name      = "interview-key"  # Ensure this key pair exists in your AWS account

  vpc_security_group_ids = [aws_security_group.windows_sg.id]

  tags = {
    Name = "Windows-Demo"
  }
}

# Output the public IP of the instances
output "ubunt_ec2_public_ip" {
  value = aws_instance.my_ubuntu_ec2_instance.public_ip
  description = "The public IP address of the Ubuntu EC2 instance"
}

output "windows_ec2_public_ip" {
  value       = aws_instance.my_windows_ec2_instance.public_ip
  description = "The public IP address of the Windows EC2 instance"
}


