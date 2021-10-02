# TODO: usar alpine (problema: instaladores Intel requerem bootstrap)
FROM ubuntu:20.04 AS builder

# Install gcc and make
RUN apt update && apt install -y build-essential

#------------------------------------------
# Intel FORTRAN compile (ifort)
# It is installed at /opt/intel
FROM builder AS ifort
ENV INSTALLER=l_HPCKit_p_2021.3.0.3230_offline.sh
COPY dependencies/$INSTALLER /tmp/
RUN sh /tmp/$INSTALLER -s -a --action install \
        --components default \
        --silent --eula accept \
    && rm /tmp/$INSTALLER

#------------------------------------------
# OpenMPI
# It is installed at /opt/openmpi
FROM builder AS openmpi
COPY --from=ifort /opt /opt
ENV TAR=openmpi-4.1.1.tar.gz
WORKDIR /opt/openmpi/openmpi-4.1.1
COPY dependencies/$TAR /opt/
RUN tar -xf /opt/$TAR -C /opt/openmpi \
    && ./configure \
    && make \
    && make install \
    && rm /opt/$TAR

#------------------------------------------
# Intel Math Kernel Libraries
# It is installed at /opt/intel
# TODO: minimizar a quantidade de componentes instalados.
FROM builder AS mkl
COPY --from=openmpi /opt /opt
ENV INSTALLER=l_BaseKit_p_2021.3.0.3219_offline.sh
COPY dependencies/$INSTALLER /tmp/
RUN sh /tmp/$INSTALLER -s -a --action install \
        --components intel.oneapi.lin.mkl.devel:intel.oneapi.lin.dpcpp-cpp-compiler:intel.oneapi.lin.tbb.devel:intel.oneapi.lin.ipp.devel:intel.oneapi.lin.ccl.devel \
        --silent --eula accept \
    && rm /tmp/$INSTALLER

#------------------------------------------
FROM builder
COPY --from=mkl /opt /opt
COPY startup.sh /root
VOLUME /root/fds/src
ENTRYPOINT ["/root/startup.sh"]
