# 创建统一命名空间 NameSpace
kubectl create -f namespace.yaml
# 持久化存 PersistentVolume
kubectl create -f pv-volume.yaml
# 持久化存储 PersistentVolumeClaim
kubectl create -f pv-claim.yaml
# 创建 kafka service
kubectl create -f kafka-svc.yaml
# 创建 kafka app
kubectl create -f kafka-app.yaml
# deploy flink
# 创建 ConfigMap
kubectl create -f flink-configmap.yaml
# 创建 jobmng svc
kubectl create -f flink-jobmanager-service.yaml
# 创建 jobmng deploy
kubectl create -f flink-jobmanager-deployment.yaml
# 创建 taskmng deploy
kubectl create -f flink-taskmanager-deployment.yaml

# 列式 Svc,deployments,pods
kubectl -n aihub get svc
kubectl -n aihub get deployments
watch kubectl -n aihub  get pods

# 开放外部访问端口
echo 'kubectl port-forward --address 0.0.0.0 flink-jobmanager 8081:8081'

# 清理资源
echo 'kubectl scale statefulsets kafka --replicas=3 -n aihub'
echo 'kubectl scale Deployment flink-jobmanager --replicas=1 -n aihub'
echo 'kubectl scale Deployment flink-taskmanager --replicas=2 -n aihub'