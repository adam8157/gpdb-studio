# extra environment variables for macOS
export PATH="/usr/local/opt/apr/bin:/usr/local/opt/apr-util/bin:/usr/local/opt/libxml2/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/zstd/lib -L/usr/local/opt/libevent/lib -L/usr/local/opt/openssl/lib -L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/zstd/include -I/usr/local/opt/libevent/include -I/usr/local/opt/openssl/include -I/usr/local/opt/libxml2/include"

CFLAGS="-O0 -g3" ./configure --prefix=`echo ~`/greenplum-db-devel --disable-gpcloud --disable-ic-proxy --disable-orca --disable-pxf --enable-cassert --enable-debug --enable-depend --enable-gpfdist --enable-tap-tests --with-gssapi --with-libxml --with-openssl --with-python --with-zstd

if command -v gmake >/dev/null 2>&1; then
	MAKE=gmake
else
	MAKE=make
fi

if command -v bear >/dev/null 2>&1; then
	bear -- $MAKE -j2
else
	$MAKE -j2
fi
