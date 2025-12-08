# Terraform

PUBLIC_IP := $(shell curl -s api.ipify.org)/32
SSH_PATH := $(shell echo $$HOME/.ssh)

tes:
	@echo " $(SSH_PATH)"

.PHONY: ec2-setup
ec2-setup:
	@echo "Setting up VPC and EC2 with IP: $(PUBLIC_IP)"
	terraform init
	terraform apply -target module.my-vpc -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -auto-approve
	terraform apply -target module.my-ec2 -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -auto-approve

ec2-destroy:
	@echo "Destroying VPC and EC2"
	terraform destroy -target module.my-ec2 -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -auto-approve
	terraform destroy -target module.my-vpc -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -auto-approve

# EKS cmds
kube-login:
	aws eks update-kubeconfig --region us-east-1 --name software-tools-dev-my-cluster --profile default

kube-setup-users: kube-login
	kubectl apply -f ./eks/users/templates/viewer-cluster-role.yaml
	kubectl apply -f ./eks/users/templates/viewer-cluster-role-binding.yaml
	kubectl apply -f ./eks/users/templates/admin-cluster-role-binding.yaml
	# aws sts assume-role --role-arn <ROLE_ARN> --role-session-name manager-session --profile manager

kube-setup-hpa: kube-login
	kubectl apply -f ./eks/hpa/templates/namespace.yaml
	kubectl apply -f ./eks/hpa/templates/service.yaml
	sleep 5
	kubectl apply -f ./eks/hpa/templates/deployment.yaml
	kubectl apply -f ./eks/hpa/templates/hpa.yaml

check-eks-info:
	kubectl config view --minify
	# kubectl auth can-i get pods

kube-check-metrics:
	kubectl get pods -n kube-system
	kubectl top pods -n kube-system
	kubectl logs -l app.kubernetes.io/instance=metrics-server -f -n kube-system

# HPA cmds
check-pods:
	watch -t kubectl get pods -n my-namespace

check-hpa:
	watch -t kubectl get hpa -n my-namespace

port-forward-svc:
	svc_name=$(kubectl get svc -n my-namespace | grep ClusterIP | awk '{print $1}')
	kubectl port-forward svc/$svc_name 8080 -n my-namespace

