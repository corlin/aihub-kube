# 创建统一命名空间 NameSpace
kubectl create -f namespace.yaml
# 持久化存 PersistentVolume
kubectl create -f pv-volume.yaml
# 持久化存储 PersistentVolumeClaim
kubectl create -f pv-claim.yaml
# 创建 kafka service
kubectl create -f kafka-svc.yaml
# deploy kafka
# deploy flink
kubectl create -f flink-configuration-configmap.yaml
kubectl create -f jobmanager-service.yaml
kubectl create -f jobmanager-session-deployment-ha.yaml
kubectl create -f taskmanager-session-deployment.yaml

# 开放外部访问端口
kubectl port-forward --address 0.0.0.0 flink-jobmanager 8081:8081