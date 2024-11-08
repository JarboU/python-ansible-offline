# 测试平台：CentOS Linux release 7.9.2009 (Core) Minimal 版本
### python version: Python 3.11.0
### ansible version: 2.17.6

使用方式：

```
$ git clone https://github.com/JarboU/ansible-offline-CentOS.git
$ cd ansible-offline-CentOS/
$ mv python3_el7_ansible/ /data/
#将应用目录移动至你需要的安装位置，我这里是安装在 /data 目录下
$ cd /data/python3_el7_ansible/
$ sh init.sh
$ source ~/.bash_profile
$ ansible --version
```
