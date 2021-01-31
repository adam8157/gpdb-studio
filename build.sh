# extra environment variables for macOS
export PATH="/usr/local/opt/apr/bin:/usr/local/opt/apr-util/bin:/usr/local/opt/libxml2/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/zstd/lib -L/usr/local/opt/libevent/lib -L/usr/local/opt/openssl/lib -L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/zstd/include -I/usr/local/opt/libevent/include -I/usr/local/opt/openssl/include -I/usr/local/opt/libxml2/include"

CFLAGS="-O0 -g3" ./configure --prefix=`echo ~`/greenplum-db-devel --with-python --with-gssapi --with-openssl --with-libxml --with-zstd --enable-depend --enable-cassert --enable-debug --enable-gpfdist --disable-gpcloud --disable-pxf --disable-orca --disable-ic-proxy

if command -v gmake >/dev/null 2>&1; then
	bear -- gmake -j2
else
	bear -- make -j2
fi
