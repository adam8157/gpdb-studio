KCFLAGS=-ggdb3 CFLAGS="-O0 -g3" ./configure --prefix=`echo ~`/greenplum-db-devel --with-gssapi --with-pgport=5432 --with-libedit-preferred --with-perl --with-python --with-openssl --with-pam --with-krb5 --enable-cassert --enable-debug --enable-testutils --enable-debugbreak --enable-depend --enable-gpfdist

make -j
