#!/bin/bash
#只适配 CentOS Linux release 7.9.2009 (Core) Minimal 版本
#必须安装 gcc,libffi-devel，yum -y install gcc libffi-devel
#未安装libffi-devel：c/_cffi_backend.c:15:17: fatal error: ffi.h: No such file or directory

CURRENT_USER_HOME=$(cd ~;pwd)
PYTHON_BASE=$(cd `dirname $0`; pwd)
CURRENT_PY_PATH=`sed -n '1p' ${PYTHON_BASE}/bin/pip3 | awk -F '.' '{print $1}'`
OLD_BASE_PATH=`echo ${CURRENT_PY_PATH} | awk -F'#!' '{print $2}' | awk -F'/bin' '{print $1}'`

# 修改当前文件夹内python环境的二进制指向路径
echo "[info] 修改python环境二进制文件指向路径:"

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
    echo "export PATH" >> ~/.bash_profile
    echo "### python end ###" >> ~/.bash_profile
    # 添加libressl动态链接库
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${PYTHON_BASE}/vendor/libressl/lib" >> ~/.bash_profile
    # if [ -n "${is_el6}" ]
    # then
    #echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${PYTHON_BASE}/vendor/libressl/lib" >> ~/.bash_profile
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

#安装ansible依赖
if [ $? = "0" ]; then
    #安装setuptools
    tar xf $PYTHON_BASE/soft/setuptools-67.6.0.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/setuptools-67.6.0
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "python 环境运行失败!"
    exit 1
fi

#安装PyYAML
if [ $? = "0" ]; then
    tar xf $PYTHON_BASE/soft/PyYAML-6.0.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/PyYAML-6.0
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "setuptools安装失败,请检查"
    exit 1
fi

#安装MarkupSafe
if [ $? = "0" ]; then    
    tar xf $PYTHON_BASE/soft/MarkupSafe-2.1.2.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/MarkupSafe-2.1.2
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "PyYAML安装失败,请检查"
    exit 1
fi

#安装Jinja2
if [ $? = "0" ]; then    
    tar xf $PYTHON_BASE/soft/Jinja2-3.1.2.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/Jinja2-3.1.2
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "MarkupSafe安装失败,请检查"
    exit 1
fi

#安装pycparser
if [ $? = "0" ]; then    
    tar xf $PYTHON_BASE/soft/pycparser-2.21.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/pycparser-2.21
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "Jinja2安装失败,请检查"
    exit 1
fi

#安装cffi
if [ $? = "0" ]; then    
    tar xf $PYTHON_BASE/soft/cffi-1.15.1.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/cffi-1.15.1
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "pycparser安装失败,请检查"
    exit 1
fi

#安装tomli
if [ $? = "0" ]; then    
    pip3 install $PYTHON_BASE/soft/tomli-2.0.1-py3-none-any.whl
else
    echo "cffi安装失败,请检查"
    exit 1
fi

#安装typing_extensions
if [ $? = "0" ]; then    
    pip3 install $PYTHON_BASE/soft/typing_extensions-4.5.0-py3-none-any.whl
else
    echo "tomli安装失败,请检查"
    exit 1
fi

#安装packaging
if [ $? = "0" ]; then    
    pip3 install $PYTHON_BASE/soft/packaging-23.0-py3-none-any.whl
else
    echo "typing_extensions安装失败,请检查"
    exit 1
fi

#安装semantic_version
if [ $? = "0" ]; then
    pip3 install $PYTHON_BASE/soft/semantic_version-2.10.0-py2.py3-none-any.whl
else
    echo "setuptools_rust安装失败,请检查"
    exit 1
fi

#安装setuptools_scm
if [ $? = "0" ]; then    
    pip3 install $PYTHON_BASE/soft/setuptools_scm-7.1.0-py3-none-any.whl
else
    echo "packaging安装失败,请检查"
    exit 1
fi

#安装setuptools_rust
if [ $? = "0" ]; then    
    pip3 install $PYTHON_BASE/soft/setuptools_rust-1.5.2-py3-none-any.whl
else
    echo "setuptools_scm安装失败,请检查"
    exit 1
fi

#安装cryptography
if [ $? = "0" ]; then
    pip3 install $PYTHON_BASE/soft/cryptography-39.0.2-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
else
    echo "setuptools_rust安装失败,请检查"
    exit 1
fi

#安装pytest_runner
if [ $? = "0" ]; then
    pip3 install $PYTHON_BASE/soft/pytest_runner-6.0.0-py3-none-any.whl
else
    echo "cryptography安装失败,请检查"
    exit 1
fi

#安装protocol
if [ $? = "0" ]; then    
    tar xf $PYTHON_BASE/soft/protocol-0.1.0.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/protocol-0.1.0
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "cryptography安装失败,请检查"
    exit 1
fi

#安装ansible
if [ $? = "0" ]; then    
    tar xf $PYTHON_BASE/soft/ansible-2.9.27.tar.gz -C $PYTHON_BASE/soft/
    cd $PYTHON_BASE/soft/ansible-2.9.27
    python3 setup.py install --prefix=$PYTHON_BASE
else
    echo "protocol安装失败,请检查"
    exit 1
fi

echo "查看ansible版本"
ansible --version

if [ $? = "0" ]; then 
    echo "ansible安装成功"
else
    echo "ansible安装失败,请检查"
    exit 1
fi
