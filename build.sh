# extra environment variables for macOS
export PATH="/usr/local/opt/apr/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

CFLAGS="-O0 -g3" ./configure --prefix=`echo ~`/greenplum-db-devel --with-python --with-gssapi --with-openssl --with-libxml --enable-cassert --enable-debug --enable-gpfdist --disable-gpcloud --disable-pxf --disable-orca

make -j2
