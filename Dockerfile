FROM ubuntu:20.04 AS dependencies

ENV USER=root

# Install gcc and make
RUN apt update && apt install -y build-essential

COPY dependencies/*.sh /tmp/
COPY dependencies/openmpi-4.1.1.tar.gz /opt/

# Intel FORTRAN compiler: ifort
RUN bash /tmp/l_HPCKit_p_2021.3.0.3230_offline.sh -s -a --action install \
    --components default --silent --eula accept

# OpenMPI
WORKDIR /opt/
RUN tar -xf openmpi-4.1.1.tar.gz
WORKDIR /opt/openmpi-4.1.1
RUN ./configure &&\
    make &&\
    make install

# Intel Math Kernel Libraries
# Instructions: https://software.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-with-command-line.html#install-with-command-line
RUN bash /tmp/l_BaseKit_p_2021.3.0.3219_offline.sh -s -a --action install \
    --components intel.oneapi.lin.mkl.devel:intel.oneapi.lin.dpcpp-cpp-compiler:intel.oneapi.lin.tbb.devel:intel.oneapi.lin.ipp.devel:intel.oneapi.lin.ccl.devel \
    --silent --eula accept

FROM dependencies

COPY fds.tar.gz /opt
COPY vars.sh /root
COPY startup.sh /root

# FDS
WORKDIR /opt/
RUN tar -xf fds.tar.gz
WORKDIR /opt/fds/Build/impi_intel_linux_64
RUN MKL_ROOT=/opt/intel/oneapi/mkl/2021.3.0 \
    INTEL_COMPILERS_AND_LIBS=/opt/intel/oneapi/ \
    . /opt/intel/oneapi/setvars.sh &&\
    ./make_fds.sh

RUN cat /root/vars.sh >> ~/.bashrc &&\
    rm /tmp/*.sh &&\
    rm /opt/openmpi-4.1.1.tar.gz &&\
    rm /opt/fds.tar.gz

VOLUME /root/fds/projects
ENTRYPOINT ["/root/startup.sh"]
