package: concurrent-engines
version: v1
requires:
  - generators
  - GEANT3
  - GEANT4_VMC
valid_defaults:
  - concurrent-engines
---
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
module load BASE/1.0                                                                           \\
	${GCC_TOOLCHAIN_VERSION:+GCC-Toolchain/$GCC_TOOLCHAIN_VERSION-$GCC_TOOLCHAIN_REVISION} \\
	${PYTHIA6_VERSION:+pythia6/$PYTHIA6_VERSION-$PYTHIA6_REVISION}			       \\
	${PYTHIA_VERSION:+pythia/$PYTHIA_VERSION-$PYTHIA_REVISION}			       \\
        ${GEANT3_VERSION:+GEANT3/$GEANT3_VERSION-$GEANT3_REVISION}                             \\
        ${GEANT4_VMC_VERSION:+GEANT4_VMC/$GEANT4_VMC_VERSION-$GEANT4_VMC_REVISION}
# Our environment
setenv CE_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
EoF
mkdir -p $INSTALLROOT/etc/modulefiles && rsync -a --delete etc/modulefiles/ $INSTALLROOT/etc/modulefiles
