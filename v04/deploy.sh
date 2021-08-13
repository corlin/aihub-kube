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

kubectl port-forward -n aihub --address 0.0.0.0 flink-jobmanager-58cc7c4bb6-4p886 8081:8081
kubectl port-forward -n aihub --address 0.0.0.0 kafka-0 9092:9092

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

kafka-topics.sh --delete --topic gbdt  --bootstrap-server localhost:9092
kafka-topics.sh --delete --topic gbdtout --bootstrap-server localhost:9092


kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic gbdt --from-beginning --max-messages 10 -group test
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic gbdtout --from-beginning --max-messages 10 -group test

/home/flink/flink-1.13.1/bin/flink run -p 1  -m localhost:8081  -c cn.creditease.GbdtStreamTest  /home/flink/alinktest.jar

/home/flink/flink-1.13.1/bin/flink run -p 1  -m localhost:8081  -c cn.creditease.KafkaTestSource  /home/corlin/alinktest.jar

{"education":"HS-grad","education_num":9,"occupation":"Adm-clerical","race":"White","sex":"Male","label":"<=50K","hours_per_week":35,"fnlwgt":198613,"capital_loss":0,"native_country":"United-States","marital_status":"Married-civ-spouse","workclass":"Private","relationship":"Husband","age":31,"capital_gain":0}
{"education":"Masters","education_num":14,"occupation":"Prof-specialty","race":"White","sex":"Female","label":"<=50K","hours_per_week":40,"fnlwgt":104834,"capital_loss":1669,"native_country":"United-States","marital_status":"Never-married","workclass":"Private","relationship":"Not-in-family","age":26,"capital_gain":0}


kafka-console-producer.sh --bootstrap-server localhost:9092 --topic gbdt

flink run -d  -t remote -m remote  -c com.creditease.rongdan.flink.xiaoduan.lossrepair.LossRepairStream  /tmp/flink-1.0-SNAPSHOT.jar  --profile prod


kubectl scale statefulsets kafka --replicas=3 -n aihub
kubectl scale Deployment flink-jobmanager --replicas=1 -n aihub
kubectl scale Deployment flink-taskmanager --replicas=2 -n aihub