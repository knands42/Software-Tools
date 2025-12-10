# Terraform

PUBLIC_IP := $(shell curl -s api.ipify.org)/32
SSH_PATH := $(shell echo $$HOME/.ssh)
VPN_CERTS_PATH := $(shell pwd)/vpn-certs

generate_certs:
	./certs.sh

ec2-setup:
	@echo "Setting up VPC and EC2 with IP: $(PUBLIC_IP)"
	terraform init
	$(MAKE) generate_certs
	terraform apply -target module.my-vpc -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -var="vpn_certs_path=$(VPN_CERTS_PATH)" -auto-approve
	terraform apply -target module.my-ec2 -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -var="vpn_certs_path=$(VPN_CERTS_PATH)" -auto-approve
	terraform apply -target module.my-acm -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -var="vpn_certs_path=$(VPN_CERTS_PATH)" -auto-approve

ec2-destroy:
	@echo "Destroying VPC and EC2"
	
	terraform destroy -target module.my-ec2 -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -var="vpn_certs_path=$(VPN_CERTS_PATH)" -auto-approve
	terraform destroy -target module.my-vpc -var="allowed_ip=$(PUBLIC_IP)" -var="ssh_path=$(SSH_PATH)" -var="vpn_certs_path=$(VPN_CERTS_PATH)" -auto-approve

connect-to-vpn:
	rm ./vpn-certs/base.ovpn | true
	$(eval VPN_ID := $(shell aws ec2 describe-client-vpn-endpoints --query "ClientVpnEndpoints[0].ClientVpnEndpointId" --output text))
	@echo "📡 Found Client VPN Endpoint ID: $(VPN_ID)"
	aws ec2 export-client-vpn-client-configuration \
		--client-vpn-endpoint-id $(VPN_ID) \
		--output text > ./vpn-certs/base.ovpn
	@echo "✅ VPN configuration written to base.ovpn"
	$(MAKE) merge-ovpn

merge-ovpn:
	rm ./vpn-certs/final.ovpn | true
	@echo "🔧 Merging certificates into final.ovpn..."
	@cp ./vpn-certs/base.ovpn ./vpn-certs/final.ovpn
	@echo "<ca>" >> ./vpn-certs/final.ovpn
	@cat ./vpn-certs/ca.crt >> ./vpn-certs/final.ovpn
	@echo "</ca>" >> ./vpn-certs/final.ovpn
	@echo "<cert>" >> ./vpn-certs/final.ovpn
	@cat ./vpn-certs/client.crt >> ./vpn-certs/final.ovpn
	@echo "</cert>" >> ./vpn-certs/final.ovpn
	@echo "<key>" >> ./vpn-certs/final.ovpn
	@cat ./vpn-certs/client.key >> ./vpn-certs/final.ovpn
	@echo "</key>" >> ./vpn-certs/final.ovpn
	rm ./vpn-certs/base.ovpn
	@echo "✅ final.ovpn created successfully."

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

