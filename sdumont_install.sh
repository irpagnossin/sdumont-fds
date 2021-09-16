#!/bin/bash

# Este script instala o FDS (e suas dependências) via código-fonte no cluster
# Santos Dumont (SDumont). Ele supõe que algum compilador C++ e o make estejam
# disponíveis no sistema. Esse é de fato o caso no SDumont, em 2021-09-16.
#
# ATENÇÃO: se você já tem instaladas as dependências, em /prj/<projeto>/opt,
# pode pular as primeiras etapas e ir diretamente para a instalação do FDS,
# no final do script. Não se esqueça de definir as variáveis de ambiente
# usadas.
#
# Este script supõe a existência dos arquivos abaixo em
# $INSTALLATION_FILES_FOLDER (veja preinstall.sh):
# - l_BaseKit_p_2021.3.0.3219_offline.sh
# - l_HPCKit_p_2021.3.0.3230_offline.sh
# - openmpi-4.1.1.tar.gz
# - fds.tar.gz
INSTALLATION_FILES_FOLDER=$HOME

# Os componentes Intel (compilador FORTRAN, Math Kernel Libraries etc)
# e OpenMPI, de uso compartilhado, serão instaladas numa pasta de acesso
# comum aos memebros do projeto.
USR=$HOME/../opt
INTEL_PATH=$USR/intel
MPI_PATH=$USR/openmpi

# Os códigos-fonte do FDS serão instalados e compilados numa pasta exclusiva
# do usuário.
FDS_INSTALLATION_PATH=$HOME/opt

# Intel FORTRAN compiler: ifort
# obs.: conforme a documentação do FDS, é possível usar gfortran ao invés do
# compilador da Intel. Porém, não obtive êxito nisso.
mkdir -p $INTEL_PATH
$INSTALLATION_FILES_FOLDER/l_HPCKit_p_2021.3.0.3230_offline.sh -s -a --action install \
    --components default \
    --install-dir $INTEL_PATH \
    --silent --eula accept

# OpenMPI
mkdir -p $MPI_PATH
tar -xf openmpi-4.1.1.tar.gz -C $MPI_PATH
cd $MPI_PATH/openmpi-4.1.1
./configure --prefix=$MPI_PATH && make && make install

# Intel Math Kernel Libraries
# Instructions: https://software.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-with-command-line.html#install-with-command-line
# TODO: otimizar. Acho que não preciso de todos os componentes indicados no comando
$INSTALLATION_FILES_FOLDER/l_BaseKit_p_2021.3.0.3219_offline.sh -s -a --action install \
    --components intel.oneapi.lin.mkl.devel:intel.oneapi.lin.dpcpp-cpp-compiler:intel.oneapi.lin.tbb.devel:intel.oneapi.lin.ipp.devel:intel.oneapi.lin.ccl.devel \
    --install-dir $INTEL_PATH \
    --silent --eula accept

# FDS
# Após a instalação, copie as 3 linhas seguintes para o final do seu ~/.bashrc
export INTEL_COMPILERS_AND_LIBS=$INTEL_PATH
source $INTEL_COMPILERS_AND_LIBS/setvars.sh
export MKL_ROOT=$MKLROOT

mkdir -p $FDS_INSTALLATION_PATH
tar -xf $INSTALLATION_FILES_FOLDER/fds.tar.gz -C $FDS_INSTALLATION_PATH
cd $FDS_INSTALLATION_PATH/fds/Build/impi_intel_linux_64
./make_fds.sh
