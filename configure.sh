#!/bin/bash

mkdir dependencies

wget --directory-prefix=dependencies https://registrationcenter-download.intel.com/akdlm/irc_nas/17912/l_HPCKit_p_2021.3.0.3230_offline.sh
wget --directory-prefix=dependencies https://registrationcenter-download.intel.com/akdlm/irc_nas/17977/l_BaseKit_p_2021.3.0.3219_offline.sh
wget --directory-prefix=dependencies https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.gz

git clone https://github.com/firemodels/fds.git
tar -zcf fds.tar.gz fds
