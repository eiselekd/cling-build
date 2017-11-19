all: docker-precise docker-trusty

#   sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y;
#   sudo apt-get update -qq
#   sudo apt-get install g++-4.9
cling:
	wget https://root.cern.ch/download/cling/cling_2017-11-02_ubuntu16.tar.bz2
	wget https://root.cern.ch/download/cling/cling_2017-11-13_ubuntu16.tar.bz2

##########################################
# llvm

##########################################
# trusty-llvm

cling-build-prepare-trusty-llvm:
	#apt-get install -y software-properties-common
	apt-get install -y software-properties-common python-software-properties wget
	add-apt-repository -y ppa:ubuntu-toolchain-r/test
	wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
	apt-add-repository "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.7 main"
	apt-get update
	apt-get install -y build-essential curl wget git python clang-3.7 libstdc++-6-dev


cling-build-trusty-llvm: cling-build-prepare-trusty-llvm
	mkdir -p $(CURDIR)/dep/cmake
	curl -k https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C $(CURDIR)/dep/cmake
	rm -rf cling
	git clone https://github.com/root-project/cling
	dpkg -l | grep libstdc
	ls -la /usr/lib/x86_64-linux-gnu/libstdc++.so.*
	strings /usr/lib/x86_64-linux-gnu/libstdc++.so.* | grep GLIBCXX
	export CMAKE=$(CURDIR)/dep/cmake/bin/cmake; \
	export CXX="clang++-3.7"; \
	export CC="clang-3.7"; \
	cd cling; tools/packaging/cpt.py --no-test --tarball-tag=master --with-cling-url=https://github.com/root-project/cling --with-clang-url=http://root.cern.ch/git/clang.git --with-llvm-url=http://root.cern.ch/git/llvm.git 

docker-trusty-llvm:
	sudo apt-get install -y docker.io
	sudo service docker restart
	sudo docker run -it --rm -v $(CURDIR):/home/build/share ubuntu:trusty bash -c 'cd /home/build/share/; apt-get update; apt-get install -y make; make cling-build-trusty-llvm; bash build.sh'


##########################################
# precise-llvm

cling-build-prepare-precise-llvm:
	#apt-get install -y software-properties-common
	apt-get install -y software-properties-common python-software-properties wget
	add-apt-repository -y ppa:ubuntu-toolchain-r/test
	apt-get update
	apt-get install -y build-essential curl wget git python clang libstdc++-6-dev


cling-build-precise-llvm: cling-build-prepare-precise-llvm
	mkdir -p $(CURDIR)/dep/cmake
	curl -k https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C $(CURDIR)/dep/cmake
	rm -rf cling
	git clone https://github.com/root-project/cling
	dpkg -l | grep libstdc
	ls -la /usr/lib/x86_64-linux-gnu/libstdc++.so.*
	strings /usr/lib/x86_64-linux-gnu/libstdc++.so.* | grep GLIBCXX
	export CMAKE=$(CURDIR)/dep/cmake/bin/cmake; \
	export CXX="clang++"; \
	export CC="clang"; \
	cd cling; tools/packaging/cpt.py --no-test --tarball-tag=master --with-cling-url=https://github.com/root-project/cling --with-clang-url=http://root.cern.ch/git/clang.git --with-llvm-url=http://root.cern.ch/git/llvm.git 

docker-precise-llvm:
	sudo apt-get install -y docker.io
	sudo service docker restart
	sudo docker run -it --rm -v $(CURDIR):/home/build/share ubuntu:precise bash -c 'cd /home/build/share/; apt-get update; apt-get install -y make; make cling-build-precise-llvm; bash build.sh'

##########################################
# gcc

##########################################
# precise

cling-build-prepare-precise:
	#apt-get install -y software-properties-common
	apt-get install -y software-properties-common python-software-properties
	add-apt-repository -y ppa:ubuntu-toolchain-r/test
	apt-get update
	apt-get install -y build-essential curl wget git python


#gcc-4.8 g++-4.8

cling-build-precise: cling-build-prepare-precise
	mkdir -p $(CURDIR)/dep/cmake
	curl -k https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C $(CURDIR)/dep/cmake
	rm -rf cling
	git clone https://github.com/root-project/cling
	ls -la /usr/lib/x86_64-linux-gnu/libstdc++.so.*
	strings /usr/lib/x86_64-linux-gnu/libstdc++.so.* | grep GLIBCXX
	export CMAKE=$(CURDIR)/dep/cmake/bin/cmake; \
	export CXX="g++"; \
	export CC="gcc"; \
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





##########################################
# trusty-custom
# create a docker container 'trusty-custom' that is lie Travis-CI, based on http://us-central1.gce.archive.ubuntu.com/ubuntu/
# run gen-trusty-prepare gen-trusty gen-trusty-docker

gen-trusty-prepare:
	sudo apt install debootstrap

gen-trusty:
	sudo debootstrap --variant=minbase --arch=amd64 trusty /tmp/trusty-rootfs http://us-central1.gce.archive.ubuntu.com/ubuntu/

#gen-trusty-roofs: 
#	cd /tmp/trusty-rootfs; sudo tar --transform="s|/tmp/trusty-rootfs/|/|" -Pczvf $(CURDIR)/rootfs.tar.gz  /tmp/trusty-rootfs
# use default gcc-4.8 

gen-trusty-docker: 
	sudo tar -C /tmp/trusty-rootfs -c . | docker import - trusty-custom

cling-build-prepare-trusty-custom:
	apt-get install -y software-properties-common
	#add-apt-repository -y ppa:ubuntu-toolchain-r/test
	apt-get update
	apt-get install -y build-essential curl wget git python 

cling-build-trusty-custom: cling-build-prepare-trusty-custom
	mkdir -p $(CURDIR)/dep/cmake
	curl -k https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C $(CURDIR)/dep/cmake
	rm -rf cling
	git clone https://github.com/root-project/cling
	ls -la /usr/lib/x86_64-linux-gnu/libstdc++.so.*
	strings /usr/lib/x86_64-linux-gnu/libstdc++.so.* | grep GLIBCXX
	export CMAKE=$(CURDIR)/dep/cmake/bin/cmake; \
	export CXX="g++"; \
	export CC="gcc"; \
	cd cling; tools/packaging/cpt.py --no-test --tarball-tag=master --with-cling-url=https://github.com/root-project/cling --with-clang-url=http://root.cern.ch/git/clang.git --with-llvm-url=http://root.cern.ch/git/llvm.git

#'--with-cmake-flags=-DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DCXX_EXTENSIONS=OFF'

docker-trusty-custom:
	sudo apt-get install -y docker.io
	sudo service docker restart
	sudo docker run -it --rm -v $(CURDIR):/home/build/share trusty-custom bash -c 'cd /home/build/share/; apt-get update; apt-get install -y make; make cling-build-trusty-custom; bash build.sh'

