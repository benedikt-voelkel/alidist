package: LWTNN
version: "%(tag_basename)s"
tag: v2.6
source: https://github.com/lwtnn/lwtnn
requires:
 - "GCC-Toolchain:(?!osx)"
 - boost
 - Eigen
---
#!/bin/bash -e


rsync -a --exclude='**/.git' --delete --delete-excluded "$SOURCEDIR/" $INSTALLROOT/


pushd $INSTALLROOT
echo $EIGEN_ROOT
echo $EIGEN_ROOT
make CPATH="$EIGEN_ROOT:$BOOST_ROOT/include"
popd


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
module load BASE/1.0 ${GCC_TOOLCHAIN_VERSION:+GCC-Toolchain/$GCC_TOOLCHAIN_VERSION-$GCC_TOOLCHAIN_REVISION} Eigen/$EIGEN_VERSION-$EIGEN_REVISION boost/$BOOST_VERSION-$BOOST_REVISION
# Our environment
setenv LWTNN_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path PATH \$::env(LWTNN_ROOT)/bin
prepend-path ROOT_INCLUDE_PATH \$::env(LWTNN_ROOT)/include
prepend-path LD_LIBRARY_PATH \$::env(LWTNN_ROOT)/lib
$([[ ${ARCHITECTURE:0:3} == osx ]] && echo "prepend-path DYLD_LIBRARY_PATH \$::env(LWTNN_ROOT)/lib")
EoF

