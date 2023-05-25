FROM oraclelinux:8.8 as build

ARG VERSION=18.13.0
ARG PSQLODBC_URL=https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-13.02.0000.tar.gz
ARG ASTERISK_URL=http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz

RUN dnf -y in --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum -y groupinstall "Development Tools" && \
    dnf config-manager --set-enabled ol8_codeready_builder && \
    dnf -y install wget curl mutt unzip tree  && \
    dnf -y install git svn patch gcc gcc-c++ ncurses-devel \
    libxml2-devel sqlite-devel unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel \
    libtiff-devel libuuid-devel jansson-devel pjproject-devel ImageMagick ghostscript \
    openssl-devel bzip2  mariadb-connector-odbc libedit-devel libcurl-devel libubsan lua lua-devel \
    libpq-devel libpq && \
    dnf clean all

RUN curl -fsSL $PSQLODBC_URL -o /usr/src/psqlodbc.tar.gz \
  && mkdir -p /usr/src/psqlodbc \
  && tar -xf /usr/src/psqlodbc.tar.gz -C /usr/src/psqlodbc --strip-component=1 \
  && mkdir /usr/src/psqlodbc-build-dir/ \
  && cd /usr/src/psqlodbc && ./configure --libdir=/usr/lib64 && make &&  make DESTDIR=/usr/src/psqlodbc-build-dir install

WORKDIR /usr/src

RUN cd /usr/src && mkdir -p /usr/src/asterisk \
  && curl -fsSL $ASTERISK_URL -o /usr/src/asterisk-18-current.tar.gz \
  && tar -xf asterisk-18-current.tar.gz -C ./asterisk --strip-components=1 \
  && cd /usr/src/asterisk/ \
  && ./configure NOISY_BUILD=yes --libdir=/usr/lib64 --without-dahdi --without-pri --without-gtk2 \
    --without-radius --without-x11 --without-speex --with-pjproject-bundled && \
    sed -i 's/30\.30/50.50/g' menuselect/menuselect.c && make menuselect.makeopts

COPY prepare-menuselect.sh /usr/src/asterisk/prepare-menuselect.sh

COPY options.conf /usr/src/options.conf

RUN chmod +x /usr/src/asterisk/prepare-menuselect.sh && cd /usr/src/asterisk && \
    ./prepare-menuselect.sh && contrib/scripts/get_mp3_source.sh && \
    make && make install && make basic-pbx && \
    groupadd  --gid 1001 asterisk && useradd --gid 1001 --uid 1001 asterisk && \
    curl http://asterisk.hosting.lv/bin/codec_g729-ast180-gcc4-glibc-x86_64-pentium4.so -o /usr/lib64/asterisk/modules/codec_g729-ast180-gcc4-glibc-x86_64-pentium4.so && \
    sed -i '/; Codecs/a load = codec_g729-ast180-gcc4-glibc-x86_64-pentium4.so' /etc/asterisk/modules.conf && \
    chown asterisk:asterisk -R /usr/lib64/asterisk && \
    chown asterisk:asterisk -R /var/lib/asterisk && \
    chown asterisk:asterisk -R /var/spool/asterisk && \
    chown asterisk:asterisk -R /etc/asterisk && \
    chown asterisk:asterisk /usr/sbin/asterisk && \
    chown asterisk:asterisk -R /var/log/asterisk && \
    mkdir -p /usr/src/install && \
    tar -cf /usr/src/install_asterisk.tar \
    /usr/share/man/man8/astdb2bdb.8 \
    /usr/share/man/man8/astdb2sqlite3.8 \
    /usr/share/man/man8/asterisk.8 \
    /usr/share/man/man8/astgenkey.8 \
    /usr/share/man/man8/autosupport.8 \
    /usr/share/man/man8/safe_asterisk.8 \
    /usr/lib64/asterisk \
    /usr/lib64/libasteriskpj.so.2 \
    /usr/lib64/libasteriskssl.so.1 \
    /usr/lib64/libasteriskpj.so \
    /usr/lib64/libasteriskssl.so \ 
    /var/lib/asterisk \
    /var/log/asterisk \
    /var/spool/asterisk \
    /etc/asterisk \
    /usr/sbin/asterisk && \
    tar xf /usr/src/install_asterisk.tar -C /usr/src/install && rm /usr/src/install_asterisk.tar


FROM oraclelinux:8.8

RUN dnf -y in --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf config-manager --set-enabled ol8_codeready_builder && \
    dnf -y install wget curl mutt unzip git svn nfs-utils ncurses \
    libxml2 sqlite unixODBC libtool-ltdl libtool-ltdl \
    libtiff libuuid jansson ImageMagick ghostscript \
    openssl tar bzip2 mariadb-connector-odbc libedit libcurl libubsan lua \
    libpq && \
    dnf clean all &&  \
    groupadd  --gid 1001 asterisk && useradd --gid 1001 --uid 1001 asterisk 

COPY --from=build /usr/src/psqlodbc-build-dir /
COPY --from=build /usr/src/install /
COPY odbcinst.ini /etc/odbcinst.ini

USER asterisk

CMD [ "/bin/bash" , "-c", "asterisk -gcvvv" ]

