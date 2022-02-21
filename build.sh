# extra environment variables for macOS
if command -v brew >/dev/null 2>&1; then
	export PATH="`brew --prefix`/opt/apr/bin:`brew --prefix`/opt/apr-util/bin:`brew --prefix`/opt/libxml2/bin:$PATH"
	export LDFLAGS="-L`brew --prefix`/opt/zstd/lib -L`brew --prefix`/opt/libevent/lib -L`brew --prefix`/opt/openssl/lib -L`brew --prefix`/opt/libxml2/lib"
	export CPPFLAGS="-I`brew --prefix`/opt/zstd/include -I`brew --prefix`/opt/libevent/include -I`brew --prefix`/opt/openssl/include -I`brew --prefix`/opt/libxml2/include"
fi

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
