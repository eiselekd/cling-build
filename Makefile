all: cling-build


#   sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y;
#   sudo apt-get update -qq
#   sudo apt-get install g++-4.9
cling:
	wget https://root.cern.ch/download/cling/cling_2017-11-02_ubuntu16.tar.bz2
	wget https://root.cern.ch/download/cling/cling_2017-11-13_ubuntu16.tar.bz2


cling-build-prepare:
	apt-get install software-properties-common
	add-apt-repository ppa:ubuntu-toolchain-r/test
	apt-get update
	apt-get install -y build-essential
	apt-get install -y gcc-6 
	apt-get install -y g++-6

cling-build: cling-build-prepare
	mkdir -p $(CURDIR)/dep/cmake
	curl -k https://cmake.org/files/v3.8/cmake-3.8.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C $(CURDIR)/dep/cmake
	rm -rf cling
	git clone https://github.com/root-project/cling
	export CMAKE=$(CURDIR)/dep/cmake/bin/cmake; \
	export CXX="g++-6"; \
	export CC="gcc-6"; \
	cd cling; tools/packaging/cpt.py --no-test --tarball-tag=master --with-cling-url=https://github.com/root-project/cling --with-clang-url=http://root.cern.ch/git/clang.git --with-llvm-url=http://root.cern.ch/git/llvm.git '--with-cmake-flags=-DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DCXX_EXTENSIONS=OFF'

docker:
	sudo docker run -it --rm -v $(CURDIR):/home/build/share ubuntu:trusty bash -c 'cd /home/build/share/; apt-get update; apt install -y make; make all'
