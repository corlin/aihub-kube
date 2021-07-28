# 设置复制节点为0
kubectl scale statefulsets kafka --replicas=0 -n aihub
kubectl scale Deployment flink-jobmanager --replicas=0 -n aihub
kubectl scale Deployment flink-taskmanager --replicas=0 -n aihub
# 清理
#  taskmng deploy
kubectl delete -f flink-taskmanager-deployment.yaml
#  jobmng deploy
kubectl delete -f flink-jobmanager-deployment.yaml
#  jobmng svc
kubectl delete -f flink-jobmanager-service.yaml
# flink ConfigMap
kubectl delete -f flink-configmap.yaml
#  kafka app
kubectl delete -f kafka-app.yaml
#  kafka service
kubectl delete -f kafka-svc.yaml
# 持久化存储 PersistentVolumeClaim
kubectl delete -f pv-claim.yaml
# 持久化存 PersistentVolume
kubectl delete -f pv-volume.yaml
# 统一命名空间 NameSpace
kubectl delete -f namespace.yaml

# 列式 Svc,deployments,pods
kubectl get svc -n aihub
kubectl get deployments -n aihub
kubectl get pods -n aihub