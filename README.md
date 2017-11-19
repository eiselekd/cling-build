# cling-build

Build cling in ubuntu:precise/trusty docker container with g++-4.8/g++-6.0. run

    make all

The build cling distribution will be placed in directory ./archives.
The compiled cling distribution is compatible with the Travis-ci enviroment and can be downloaded via

   wget -O - https://github.com/eiselekd/cling-build/raw/master/archives/cling-latest.tar.bz2 > cling-latest.tar.bz2


