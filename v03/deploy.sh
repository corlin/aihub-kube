kubectl apply -f 00-namespace/
kubectl apply -f 01-zookeeper/
kubectl apply -f 02-kafka/
kubectl apply -f 03-yahoo-kafka-manager/
kubectl apply -f 04-kafka-monitor/
kubectl apply -f 05-kafka-mirrormaker/
kubectl apply -f 06-flink/

kubectl get all  -n aihub
kubectl get event -n aihub

watch  kubectl get po -n aihub

kubectl port-forward -n aihub --address 0.0.0.0 flink-jobmanager-779d9559c7-tmlvd 8081:8081
kubectl port-forward -n aihub --address 0.0.0.0 kafka-manager-7b8fb9f6c6-ztz4c 9000:9000

kubectl -n aihub exec kafka-0 -- tail -f /opt/kafka/logs/state-change.log
kubectl -n aihub exec kafka-0 -- tail -f /opt/kafka/logs/server.log
kubectl -n aihub exec kafka-0 -- tail -f /opt/kafka/logs/controller.log


kubectl exec flink-jobmanager-797c75fbc7-8mxhk -n aihub  -i -t -- bash -il

/home/corlin/flink-1.13.1/bin/flink run -p 1  -m localhost:8081  -c com.alibaba.alink.GBDTExample  /home/corlin/demo/alinktest.jar
/home/corlin/flink-1.13.1/bin/flink run -p 1  -m localhost:8081  -c cn.creditease.KafkaTestSource  /home/corlin/demo/alinktest.jar

kubectl -n aihub exec kafka-0  -i -t -- bash -il
 kubectl describe  kafka -n aihub

kubectl port-forward service/kafka --address 0.0.0.0 9092:9092 -n aihub

kubectl exec -it kafka-0 -n aihub -- /bin/sh

kafka-topics.sh --create --topic gbdtout --partitions 3 --replication-factor 3 --bootstrap-server localhost:9092
kafka-topics.sh --create --topic gbdt --partitions 3 --replication-factor 3 --bootstrap-server localhost:9092
kafka-topics.sh --describe --topic gbdt --bootstrap-server localhost:9092


kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic gbdt
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic gbdtout

/home/corlin/flink-1.13.1/bin/flink run -p 1  -m localhost:8081  -c cn.creditease.GbdtStreamTest  /home/corlin/demo/alinktest.jar



