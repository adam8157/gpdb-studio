# extra environment variables for macOS
export PATH="/usr/local/opt/apr/bin:$PATH"
export PATH="/usr/local/opt/apr-util/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/zstd/lib -L/usr/local/opt/libevent/lib -L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/zstd/include -I/usr/local/opt/libevent/include -I/usr/local/opt/openssl/include"

CFLAGS="-O0 -g3" ./configure --prefix=`echo ~`/greenplum-db-devel --with-python --with-gssapi --with-openssl --with-libxml --with-zstd --enable-depend --enable-cassert --enable-debug --enable-gpfdist --disable-gpcloud --disable-pxf --disable-orca

bear gmake -j2
