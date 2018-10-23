package: lwtnn
version: "%(tag_basename)s"
tag: v2.7.1
source: https://github.com/lwtnn/lwtnn.git
requires:
 - "GCC-Toolchain:(?!osx)"
 - boost
 - Eigen
build_requires:
 - CMake
prefer_system: (?!slc5)
---
#!/bin/bash -e

cmake "$SOURCEDIR" \
      -DBOOST_DIR="$BOOST_ROOT" \
      -DEIGEN_ROOT="$EIGEN_ROOT" \
      -DEIGEN3_INCLUDE_DIR="$EIGEN_ROOT/include/eigen3" \
      -DCMAKE_INSTALL_PREFIX="$INSTALLROOT"
make ${JOBS+-j $JOBS} install


# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
cat > "$MODULEFILE" <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0 ${LWTNN_VERSION:+lwtnn/$LWTNN_VERSION-$LWTNN_REVISION} ${BOOST_VERSION:+boost/$BOOST_VERSION-$BOOST_REVISION} Eigen/$EIGEN_VERSION-$EIGEN_REVISION
# Our environment
setenv LWTNN_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path LD_LIBRARY_PATH \$::env(LWTNN_ROOT)/lib
$([[ ${ARCHITECTURE:0:3} == osx ]] && echo "prepend-path DYLD_LIBRARY_PATH \$::env(LWTNN_ROOT)/lib")
EoF
