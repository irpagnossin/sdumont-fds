FROM ubuntu:20.04 AS dependencies

ENV USER=root

# Install gcc and make
RUN apt update && apt install -y build-essential

COPY dependencies/*.sh /tmp/
COPY dependencies/openmpi-4.1.1.tar.gz /opt/

# Intel FORTRAN compiler: ifort
# https://registrationcenter-download.intel.com/akdlm/irc_nas/17912/l_HPCKit_p_2021.3.0.3230_offline.sh
RUN bash /tmp/l_HPCKit_p_2021.3.0.3230_offline.sh -s -a --action install \
    --components default --silent --eula accept

# OpenMPI
# https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.gz
WORKDIR /opt/
RUN tar -xf openmpi-4.1.1.tar.gz
WORKDIR /opt/openmpi-4.1.1
# ./configure --target=/my/preferred/location
RUN ./configure &&\
    make &&\
    make install

# Intel Math Kernel Libraries
# https://registrationcenter-download.intel.com/akdlm/irc_nas/17977/l_BaseKit_p_2021.3.0.3219_offline.sh
# Instructions: https://software.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-with-command-line.html#install-with-command-line
RUN bash /tmp/l_BaseKit_p_2021.3.0.3219_offline.sh -s -a --action install \
    --components intel.oneapi.lin.mkl.devel:intel.oneapi.lin.dpcpp-cpp-compiler:intel.oneapi.lin.tbb.devel:intel.oneapi.lin.ipp.devel:intel.oneapi.lin.ccl.devel \
    --silent --eula accept

FROM dependencies

COPY fds.tar.gz /opt/
COPY startup.sh /root/

# FDS
WORKDIR /opt/
RUN tar -xf fds.tar.gz
WORKDIR /opt/fds/Build/impi_intel_linux_64
RUN MKL_ROOT=/opt/intel/oneapi/mkl/2021.3.0 \
    INTEL_COMPILERS_AND_LIBS=/opt/intel/oneapi/ \
    . /opt/intel/oneapi/setvars.sh &&\
    ./make_fds.sh

VOLUME /root/fds/projects
ENTRYPOINT /root/startup.sh
