#!/bin/sh

export RELEASE_TARBALL=$(ls ${HOME}/ci/build/cling*.tar.bz2)

b=`basename ${RELEASE_TARBALL}`
d=`expr match $b '\(.*\).tar.bz2`

cp ${RELEASE_TARBALL} archive/
chmod -R a+rwx archive/
