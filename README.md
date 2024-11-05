# 适配 CentOS Linux release 7.9.2009 (Core) Minimal 版本
## 必须安装 gcc,libffi-devel
## yum -y install gcc libffi-devel
### python version: Python 3.9.16
### ansible version: 2.9.27

使用方式：

```
$ git clone https://github.com/JarboU/ansible-offline-CentOS.git
$ cd ansible-offline-CentOS/ansible/CentOS7.9/
$ mv python3_el7_ansible/ /data/
#将应用目录移动至你需要的安装位置，我这里是安装在 /data 目录下
$ cd /data/python3_el7_ansible/
$ sh init.sh
$ source ~/.bash_profile
$ ansible --version
```
