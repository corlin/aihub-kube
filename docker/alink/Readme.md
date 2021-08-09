flink:
docker build -t corlin/alink .
docker tag corlin/alink corlin/alink:1.13.1-scala_2.11-java8

docker pull corlin/alink:1.13.1-scala_2.11-java8

push-flink: flink
docker push corlin/alink
docker push corlin/alink:1.13.1-scala_2.11-java8

清理无效ns
https://blog.csdn.net/PWBGJX/article/details/90055339

NAMESPACE=aihub2
kubectl proxy &
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
