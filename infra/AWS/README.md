# AWS cloud provider setup with Terraform

This directory contains the Terraform code to create the base of an AWS cloud provider, like VPC and a EKS cluster.

In order to achieve this we need to create the following resources:

## VPC

1. **VPC**:
    Define your VPC with the chosen CIDR block. This will be the primary networking environment for your resources.

2. **Subnets**:
    - **Public Subnets**: Create public subnets in each availability zone. These subnets will have routes to the internet through an Internet Gateway.
    - **Private Subnets**: Create private subnets in each availability zone. These subnets will not have direct access to the internet.

3. **Internet Gateway**:
    Attach an Internet Gateway to the VPC to allow resources in the public subnets to access the internet.

4. **NAT Gateway**:
    If your private subnets require outbound internet access (e.g., for updates or API calls), create a NAT Gateway in a public subnet.

5. **Route Tables**:
    - **Public Route Table**: Create a route table for the public subnets that routes traffic to the Internet Gateway.
    - **Private Route Table**: Create a route table for the private subnets that routes traffic to the NAT Gateway.
