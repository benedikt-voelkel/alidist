package: Eigen
version: "%(tag_basename)s"
tag: 3.3.5
source: https://github.com/eigenteam/eigen-git-mirror.git
requires:
 - "GCC-Toolchain:(?!osx)"
build_requires:
 - CMake
prefer_system: (?!slc5)
---
#!/bin/bash -e
cmake "$SOURCEDIR" -DCMAKE_INSTALL_PREFIX="$INSTALLROOT"

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
module load BASE/1.0 ${EIGEN_VERSION:+lwtnn/$EIGEN_VERSION-$EIGEN_REVISION}
# Our environment
setenv EIGEN_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
EoF
