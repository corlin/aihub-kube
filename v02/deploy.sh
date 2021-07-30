minikube start --memory=6144 --cpus=4
kubectl apply -f 00-namespace/
kubectl apply -f 01-zookeeper/
kubectl apply -f 02-kafka/
kubectl apply -f 03-yahoo-kafka-manager/
kubectl apply -f 04-kafka-monitor/
kubectl apply -f 05-kafka-mirrormaker/

kubectl apply -f 06-flink/

watch -n 1 kubectl -n aihub1 gl et deployments
watch -n 1 kubectl -n aihub1 get statefulsets
watch -n 1 kubectl -n aihub1 get services
watch -n 1 kubectl -n aihub1 get pods
watch -n 1 minikube service list --namespace aihub1

kafka-0                          1/1     Running   0          14m
kafka-1                          1/1     Running   0          14m
kafka-2                          1/1     Running   0          14m
kafka-manager-7b8fb9f6c6-4c7lg   1/1     Running   0          14m
kafka-monitor-6795444469-cm6sd   1/1     Running   0          14m
zookeeper-7b69697846-clg8s       1/1     Running   0          14m


kubectl -n aihub1 exec kafka-monitor-6795444469-cm6sd  -i -t bash

kubectl port-forward -n aihub1 --address 0.0.0.0 kafka-monitor-6795444469-cm6sd 8000:8000


### Monitor end-to-end a single cluster + JMX

Run the following:
```bash
KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9999 -Djava.rmi.server.hostname=127.0.0.1 " \
  exec ./bin/end-to-end-test.sh --broker-list kafka-0.kafka.aihub1.svc.cluster.local:9092,kafka-1.kafka.aihub1.svc.cluster.local:9092,kafka-2.kafka.aihub1.svc.cluster.local:9092 --zookeeper zookeeper-service.aihub1.svc.cluster.local:2181 \
  --topic testtopic
```

### Monitor a single cluster + JMX using more detailed configuration kafka-monitor.properties

```bash
KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9999 -Djava.rmi.server.hostname=127.0.0.1 " \
  exec ./bin/kafka-monitor-start.sh config/kafka-monitor.properties
```


kubectl port-forward -n aihub1 --address 0.0.0.0 kafka-manager-7b8fb9f6c6-4c7lg 9000:9000


kubectl -n aihub1 exec kafka-0 -- tail -f /opt/kafka/logs/state-change.log
kubectl -n aihub1 exec kafka-0 -- tail -f /opt/kafka/logs/server.log
kubectl -n aihub1 exec kafka-0 -- tail -f /opt/kafka/logs/controller.log