## [kubernetes1.10.3离线安装包](https://zdcloud.oss-cn-hangzhou.aliyuncs.com/kube1.10.3.tar.gz)

- 1.10.3版本k8s优化了很多东西，如存储，大内存页等，比如你要对接ceph等，那一定不要用1.10以下版本的
- 全部使用当前最新版本组建
- Cgroup driver自动检测
- 优化dashboard grafana等yaml配置
- DNS双副本高可用

## kubernetes离线包安装教程：
```
1. master上： cd shell && sh init.sh && sh master.sh
2. node上：cd shell && sh init.sh
3. 在node上执行master输出的join命令即可 (重建命令kubeadm token create --print-join-command)
```
