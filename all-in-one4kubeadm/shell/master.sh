#kubeadm init --config ../conf/kubeadm.yaml
kubeadm init --kubernetes-version=v1.10.3 --feature-gates=CoreDNS=true --pod-network-cidr=10.244.0.0/16
mkdir ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
#kubectl apply -f ../conf/net/calico.yaml
kubectl apply -f ../conf/net/rbac.yaml
kubectl apply -f ../conf/net/canal.yaml

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl apply -f ../conf/heapster/
kubectl apply -f ../conf/heapster/rbac

kubectl apply -f ../conf/dashboard
