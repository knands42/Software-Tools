connect-eks:
    aws eks update-kubeconfig --name software-tools-dev-my-cluster --region us-east-1

check-eks-info:
    kubectl config view --minify
    # kubectl auth can-i get pods