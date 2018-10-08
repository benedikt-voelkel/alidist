package: MCStepLogger
version: "%(tag_basename)s"
tag: dev
source: https://github.com/benedikt-voelkel/mcsteplogger
requires:
  - boost
  - ROOT
build_requires:
  - CMake
---
#!/bin/bash -e

# Standard ROOT build
cmake $SOURCEDIR                                                                       \
      ${CMAKE_GENERATOR:+-G "$CMAKE_GENERATOR"}                                        \
      -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE                                             \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT                                              \

# Invoke build/install via CMake for standard builds (supports all generators)
make ${JOBS:+-j$JOBS} && make install

# Modulefile
mkdir -p etc/modulefiles
cat > etc/modulefiles/$PKGNAME <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0 ${ROOT_VERSION:+ROOT/$ROOT_VERSION-$ROOT_REVISION}     \\
                     ${BOOST_VERSION:+boost/$BOOST_VERSION-$BOOST_REVISION}
# Our environment
setenv MCSTEPLOGGER_RELEASE \$version
setenv MCSTEPLOGGER_BASEDIR \$::env(BASEDIR)/$PKGNAME
setenv MCSTEPLOGGER_ROOT \$::env(MCSTEPLOGGER_BASEDIR)/\$version
prepend-path PATH \$::env(MCSTEPLOGGER_ROOT)/bin
prepend-path LD_LIBRARY_PATH \$::env(MCSTEPLOGGER_ROOT)/lib
prepend-path ROOT_INCLUDE_PATH \$::env(MCSTEPLOGGER_ROOT)/include
$([[ ${ARCHITECTURE:0:3} == osx ]] && echo "prepend-path DYLD_LIBRARY_PATH \$::env(MCSTEPLOGGER_ROOT)/lib")
EoF
mkdir -p $INSTALLROOT/etc/modulefiles && rsync -a --delete etc/modulefiles/ $INSTALLROOT/etc/modulefiles
