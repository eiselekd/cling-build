# cling-build

Build cling in ubuntu:precise/trusty docker container that matches TravisCI's
http://us-central1.gce.archive.ubuntu.com based setup. Run

    make gen-trusty-prepare
    make gen-trusty
    make gen-trusty-docker

to create cocker container.
Then run

    make docker-trusty-custom

To build cling inside the newly created container.
The compiled cling distribution is compatible with the Travis-ci enviroment and can be downloaded via

   wget -O - https://github.com/eiselekd/cling-build/raw/master/archives/cling-latest.tar.bz2 > cling-latest.tar.bz2
