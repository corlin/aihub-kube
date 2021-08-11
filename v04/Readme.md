## 操作

kubectl describe pv 
## nfs共享存储
```shell
yum install nfs-utils rpcbind -y
mkdir -p /data/nfs && chmod 755 /data/nfs/
cat /etc/exports
/data/nfs  *(rw,sync,no_root_squash)
systemctl start rpcbind nfs && systemctl enable rpcbind nfs


```
## 参数

◎ ReadWriteOnce（RWO）：读写权限，并且只能被单个Node挂
载。
◎ ReadOnlyMany（ROX）：只读权限，允许被多个Node挂载。
◎ ReadWriteMany（RWX）：读写权限，允许被多个Node挂载。

## 参考
https://kubernetes.io/docs/concepts/storage/persistent-volumes/
https://time.geekbang.org/column/article/42698
https://minikube.sigs.k8s.io/docs/commands/node/
NFS
https://blog.51cto.com/u_13777088/2471778
k8s接口
https://lxkaka.wang/k8s-kafka/

https://blog.csdn.net/carcoon/article/details/114228986