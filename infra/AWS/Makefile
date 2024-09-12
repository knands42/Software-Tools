# EKS cmds
kube-login:
    aws eks update-kubeconfig --region us-east-1 --name software-tools-dev-my-cluster --profile developer

check-eks-info:
    kubectl config view --minify
    # kubectl auth can-i get pods

# HPA cmds
check-pods:
    watch -t kubectl get pods -n my-namespace

check-hpa:
    watch -t kubectl get hpa -n my-namespace

port-forward-svc:
    svc_name=$(kubectl get svc -n my-namespace | grep ClusterIP | awk '{print $1}')
    kubectl port-forward svc/$svc_name 8080 -n my-namespace

