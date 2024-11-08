#!/bin/sh

# 修改当前文件夹内python环境的二进制指向路径
echo "[info] 修改python环境二进制文件指向路径:"
CURRENT_USER_HOME=$(cd ~;pwd)
PYTHON_BASE=$(cd `dirname $0`; pwd)
#CURRENT_PY_PATH=`sed -n '1p' ${PYTHON_BASE}/bin/pip3 | awk -F '.' '{print $1}'`
CURRENT_PY_PATH=`sed -n '1p' ${PYTHON_BASE}/bin/pip3`
OLD_BASE_PATH=`echo ${CURRENT_PY_PATH} | awk -F'#!' '{print $2}' | awk -F'/bin' '{print $1}'`

for py_file in `grep "${CURRENT_PY_PATH}" -rl ${PYTHON_BASE}`
do
        echo "修改${py_file}文件, 将Python原路径${OLD_BASE_PATH}变更为${PYTHON_BASE}."
        sed -i "1s:${OLD_BASE_PATH}:${PYTHON_BASE}:" ${py_file}
done

echo ""
echo "[info] 把python环境添加到当前用户环境变量中:"
# 检查python适用的系统版本
# is_el6=`echo ${PYTHON_BASE} | grep "el6"`
is_add=`cat ~/.bash_profile | grep "python start"`
if [ -z "${is_add}" ]
then
   echo "" >> ~/.bash_profile
   echo "### python start ###" >> ~/.bash_profile
   echo "PATH=\$PATH:${PYTHON_BASE}/bin" >> ~/.bash_profile
   echo "export PYTHONHOME=/data/python3_e17_ansible" >> ~/.bash_profile
   echo "export PYTHONPATH=/data/python3_e17_ansible/lib/python3" >> ~/.bash_profile
   echo "export PATH" >> ~/.bash_profile
        echo "### python end ###" >> ~/.bash_profile
   # 添加libressl动态链接库
   echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${PYTHON_BASE}/vendor/libressl/lib" >> ~/.bash_profile
        echo "PATH=${PYTHON_BASE}/bin/:\$PATH"
        echo "export PATH" >> ~/.bash_profile
   # if [ -n "${is_el6}" ]
   # then
   #   echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${PYTHON_BASE}/vendor/libressl/lib" >> ~/.bash_profile
   # fi
   echo "环境变量添加成功,请执行命令“source ~/.bash_profile”重新加载环境变量."
else
   echo "环境变量已存在,不需要添加."
fi

echo ""
echo "[info] 检查python是否可用:"
. ~/.bash_profile
${PYTHON_BASE}/bin/python3 -c "import _ssl;" &>/dev/null
if [ $? -eq 0 ]
then
   echo "python运行正常."
else
   echo "!!!python运行异常,请排查!!!"
   exit 1
fi

echo ""
echo "[info] 配置ansible:"
echo "复制${PYTHON_BASE}/etc/ansible.cfg文件到${CURRENT_USER_HOME}/.ansible.cfg"
cp -vf ${PYTHON_BASE}/etc/ansible.cfg ${CURRENT_USER_HOME}/.ansible.cfg
echo ""
echo "变更自定义plugins路径."
sed -i "s:{PYTHON_BASE}:${PYTHON_BASE}:g" ${CURRENT_USER_HOME}/.ansible.cfg
echo ""
echo "配置ansible完成."
