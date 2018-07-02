# CentOS 7.4使用heketi-cli删除卷导致系统自动重启问题

## 系统环境

### 内核版本

```text
[root@k8s01 ~]# uname -a
Linux k8s01 3.10.0-693.21.1.el7.x86_64 #1 SMP Wed Mar 7 19:03:37 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```

* 操作系统CentOS 7.4，内核版本3.10.0-693.21.1.el7.x86_64。

### docker版本

```text
[root@k8s01 ~]# docker info
Containers: 20
 Running: 10
 Paused: 0
 Stopped: 10
Images: 23
Server Version: 17.12.1-ce
Storage Driver: overlay2
 Backing Filesystem: xfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 9b55aab90508bd389d7654c4baf173a981477d55
runc version: 9f9c96235cc97674e935002fc3d78361b696a69e
init version: 949e6fa
Security Options:
 seccomp
  Profile: default
Kernel Version: 3.10.0-693.21.1.el7.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
CPUs: 4
Total Memory: 3.831GiB
Name: k8s01
ID: E3KE:KV27:PVVK:KDRC:7EZK:ISXZ:KSI3:7EA5:A7GQ:KT7T:LERV:XZUH
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false

```

* docker 17.12.1-ce，使用overlay2存储驱动。

### 系统部署描述

Glusterfs采用Container Native的方式部署在kubernetes上，通过heketi为K8S提供REST API。部署过程如下：

[Glusterfs部署](https://github.com/iiitux/Kubernetes-1.9.4-Binary-Installation/blob/master/13.%E9%83%A8%E7%BD%B2Glusterfs.md)

## 问题描述

* 进入heketi pod，通过heketi-cli删除卷时，k8s节点自动重启，dmesg和/var/log/messages报类似以下错误信息：

```text
May  8 10:39:46 k8s01 kernel: =============================================================================
May  8 10:39:46 k8s01 kernel: BUG kmalloc-256(17:96f869e354e19d539450b844ba848b19ad0f601629e2524d352eb0a0217f0fc4) (Tainted: G    B          ------------ T): Objects remaining in kmalloc-256(17:96f869e354e19d539450b844ba848b19ad0f601629e2524d352eb0a0217f0fc
May  8 10:39:46 k8s01 kernel: -----------------------------------------------------------------------------
May  8 10:39:46 k8s01 kernel: INFO: Slab 0xffffea0002063200 objects=64 used=23 fp=0xffff8800818cac00 flags=0x1fffff00004080
May  8 10:39:46 k8s01 kernel: CPU: 1 PID: 7238 Comm: lvremove Tainted: G    B          ------------ T 3.10.0-693.21.1.el7.x86_64 #1
May  8 10:39:46 k8s01 kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
```

github有用户也反馈类似故障信息，可能由于内核版本老旧导致。
[github相关issue](https://github.com/moby/moby/issues/29879)

## 解决方法

* 从EPEL升级高版本的kernel-ml内核，目前kernel-ml内核未4.16.7，kernel-lt内核版本为4.4，经测试目前版本的ml和lt内核都能解决该问题，再通过heketi-cli删除卷，未在dmesg和/var/log/messages中出现以上错误信息。升级步骤如下：
```
[root@centos ~]# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
[root@centos ~]# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
[root@centos ~]# yum --enablerepo=elrepo-kernel -y install kernel-ml
[root@centos ~]# grub2-set-default 0
[root@centos ~]# grub2-mkconfig -o /boot/grub2/grub.cfg
```
升级后内核版本信息：

kernel-ml：

```text
[root@k8s01 ~]# uname -a
Linux k8s01 4.16.7-1.el7.elrepo.x86_64 #1 SMP Wed May 2 14:36:18 EDT 2018 x86_64 x86_64 x86_64 GNU/Linux
```

kernel-lt:

```text
[root@k8s01 ~]# uname -a
Linux k8s01 4.4.131-1.el7.elrepo.x86_64 #1 SMP Wed May 2 13:09:02 EDT 2018 x86_64 x86_64 x86_64 GNU/Linux
```
