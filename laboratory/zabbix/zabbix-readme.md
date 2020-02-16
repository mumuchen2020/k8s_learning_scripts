# zabbix部署说明

## zabbix-mysql
- 部署时使用mysql作为数据库后端。

## zabbix-agent
- 部署时，使用daemonset方式部署，还需要挂载本地碰盘目录，用于存放自定义监控项。

## zabbix-server
- 部署时，需在在pod里指定两个容器，一个是zabbi-agent，另一个是zabbix-server，这样的话zabbix-agent和zabbix-server共享pod ip地址，所以就能实现监控zabbix-server本身了。
- zabbix-agent要挂pvc，用于存放自定义监控项。

## zabbix-web
- 按正常pod配置即可。

## 环境变量
- 使用configMap存放基础变量，secret来存放数据库密码。但是secret是base64位加密，其实也不安全，因为解密很快，为了方便实验，就全用confiMap来实现。

## 部署方式，感觉使用statefulset方式部署更合理，但是还没有试过这种方式部署这一套逻辑。

## 细节问题
- zabbix-server部署时，必须要使用headless来暴露服务，这时候服务域名解析出来的就是pod ip地址，这样在web界面上设置zabbix-server地址时使用域名即能解决zabbix-agent unreachable on zabbix-server的问题了。

- 部署zabbix-agent在node上时，需要把配置文件中的zabbix-server地址改成node节点的网段这样才能解决节点上报zabbix-agent unreachable的问题了。否则就会在某些节点报类似于这样的错误：`62:20200215:162503.203 failed to accept an incoming connection: connection from "192.168.255.250" rejected, allowed hosts: "zabbix.k8s.example.com"`，这里要思考下，zabbix-server明显是使用pod地址与其他pod，node来通信的，为什么在这里会是zabbix-server pod所在的node地址呢，这是因为flannel网络组件工作原理机制，pod与其他节点通信时，会经过自己所在的节点网桥把地址改写node地址，并把pod地址与在数据包中，所以对外通信时就显示为node的地址了，也就是本条消息中的192.168.255.250了。

## 后续
- 目前仅完成了部署，像一些自定义的监控还没有部署，只需要修改zabbix-agent的volume挂载到自定义监控目录即可。
