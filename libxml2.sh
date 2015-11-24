package: libxml2
version: v2.9.2
source: git://git.gnome.org/libxml2
tag: v2.9.2
build_requires:
  - autotools
  - zlib
  - "GCC-Toolchain:(?!osx)"
---
#!/bin/sh
rsync -a $SOURCEDIR/ ./
autoreconf -i
./configure --disable-static \
            --prefix=$INSTALLROOT \
            --with-zlib="${ZLIB_ROOT}" --without-python

make ${JOBS+-j $JOBS}
make install
