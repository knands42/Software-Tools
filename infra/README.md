# Infraestructure managed by Terraform

This directory contains the Terraform code to create the base of a cloud provider setup (AWS or GCP for now) for most applications.

## Requirements

- Terraform v0.12.24
- AWS CLI v2.0.0

## Usage

1. Configure your AWS credentials with the AWS CLI

```bash
aws configure
```

2. Choose which cloud provider you want to use

```bash
cd aws
```

3. Initialize Terraform

```bash
terraform init
```

4. Create the infrastructure

```bash
terraform apply
```

5. Destroy the infrastructure

```bash
terraform destroy
```
