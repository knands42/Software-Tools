# Terraform
terraform-setup:
	terraform init
	terraform apply -target module.my-vpc -auto-approve
	terraform apply -target module.my-eks -auto-approve
	terraform apply -target module.my-users -auto-approve
	$(MAKE) kube-setup-users
	terraform apply -target module.my-hpa -auto-approve
	$(MAKE) kube-setup-hpa
	terraform apply -target module.my-autoscaler -auto-approve

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

