all: docker-precise docker-trusty

#   sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y;
#   sudo apt-get update -qq
#   sudo apt-get install g++-4.9
cling:
	wget https://root.cern.ch/download/cling/cling_2017-11-02_ubuntu16.tar.bz2
	wget https://root.cern.ch/download/cling/cling_2017-11-13_ubuntu16.tar.bz2

##########################################
# precise

cling-build-prepare-precise:
	#apt-get install -y software-properties-common
	apt-get install -y software-properties-common python-software-properties
	add-apt-repository -y ppa:ubuntu-toolchain-r/test
	apt-get update
	apt-get install -y build-essential curl wget git python gcc-4.8 g++-4.8

cling-build-precise: cling-build-prepare-precise
	mkdir -p $(CURDIR)/dep/cmake
	curl -k https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C $(CURDIR)/dep/cmake
	rm -rf cling
	git clone https://github.com/root-project/cling
	ls -la /usr/lib/x86_64-linux-gnu/libstdc++.so.*
	strings /usr/lib/x86_64-linux-gnu/libstdc++.so.* | grep GLIBCXX
	export CMAKE=$(CURDIR)/dep/cmake/bin/cmake; \
	export CXX="g++-4.8"; \
	export CC="gcc-4.8"; \
	cd cling; tools/packaging/cpt.py --no-test --tarball-tag=master --with-cling-url=https://github.com/root-project/cling --with-clang-url=http://root.cern.ch/git/clang.git --with-llvm-url=http://root.cern.ch/git/llvm.git 

docker-precise:
	sudo apt-get install -y docker.io
	sudo service docker restart
	sudo docker run -it --rm -v $(CURDIR):/home/build/share ubuntu:precise bash -c 'cd /home/build/share/; apt-get update; apt-get install -y make; make cling-build-precise; bash build.sh'

##########################################
# trusty

cling-build-prepare-trusty:
	apt-get install -y software-properties-common
	add-apt-repository -y ppa:ubuntu-toolchain-r/test
	apt-get update
	apt-get install -y build-essential curl wget git python gcc-6 g++-6

cling-build-trusty: cling-build-prepare-trusty
	mkdir -p $(CURDIR)/dep/cmake
	curl -k https://cmake.org/files/v3.8/cmake-3.8.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C $(CURDIR)/dep/cmake
	rm -rf cling
	git clone https://github.com/root-project/cling
	ls -la /usr/lib/x86_64-linux-gnu/libstdc++.so.*
	strings /usr/lib/x86_64-linux-gnu/libstdc++.so.* | grep GLIBCXX
	export CMAKE=$(CURDIR)/dep/cmake/bin/cmake; \
	export CXX="g++-6"; \
	export CC="gcc-6"; \
	cd cling; tools/packaging/cpt.py --no-test --tarball-tag=master --with-cling-url=https://github.com/root-project/cling --with-clang-url=http://root.cern.ch/git/clang.git --with-llvm-url=http://root.cern.ch/git/llvm.git '--with-cmake-flags=-DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DCXX_EXTENSIONS=OFF'

docker-trusty:
	sudo apt-get install -y docker.io
	sudo service docker restart
	sudo docker run -it --rm -v $(CURDIR):/home/build/share ubuntu:trusty bash -c 'cd /home/build/share/; apt-get update; apt-get install -y make; make cling-build-trusty; bash build.sh'

