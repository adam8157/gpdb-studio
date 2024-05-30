# extra environment variables for macOS
if command -v brew >/dev/null 2>&1; then
	export PATH="`brew --prefix`/opt/apr/bin:`brew --prefix`/opt/apr-util/bin:`brew --prefix`/opt/libxml2/bin:$PATH"
	export LDFLAGS="-L`brew --prefix`/opt/zstd/lib -L`brew --prefix`/opt/libevent/lib -L`brew --prefix`/opt/openssl/lib -L`brew --prefix`/opt/libxml2/lib -L`brew --prefix`/opt/libyaml/lib -L`brew --prefix`/opt/xerces-c/lib"
	export CPPFLAGS="-I`brew --prefix`/opt/zstd/include -I`brew --prefix`/opt/libevent/include -I`brew --prefix`/opt/openssl/include -I`brew --prefix`/opt/libxml2/include -I`brew --prefix`/opt/libyaml/include -I`brew --prefix`/opt/xerces-c/include"
fi

OPTION_ICPROXY="--disable-ic-proxy"
OPTION_ORCA="--disable-orca"
OPTION_TAP="--disable-tap-tests"

while [[ $# -gt 0 ]]
do
	case "$1" in
		--icproxy)
			OPTION_ICPROXY="--enable-ic-proxy"
			shift;;
		--orca)
			OPTION_ORCA="--enable-orca"
			shift;;
		--tap)
			OPTION_TAP="--enable-tap-tests"
			shift;;
		--)
			shift
			break;;
		*)
			echo "Only --icproxy, --orca and --tap are valid options" >&2
			exit 1;;
	esac
done

CFLAGS="-O0 -g3 -fno-omit-frame-pointer" ./configure --prefix=`echo ~`/greenplum-db-devel \
	--disable-gpcloud \
	--disable-pxf \
	--enable-cassert \
	--enable-debug \
	--enable-depend \
	--enable-gpfdist \
	$OPTION_ICPROXY \
	$OPTION_ORCA \
	$OPTION_TAP \
	--with-gssapi \
	--with-libxml \
	--with-openssl \
	--with-python \
	--with-perl \
	--with-zstd \
	--with-includes=/usr/local/include \
	--with-libraries=/usr/local/lib

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
