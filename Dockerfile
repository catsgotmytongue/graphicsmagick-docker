FROM node:10.15.3-alpine
ENV PKGNAME=graphicsmagick
ENV PKGVER=1.3.31
ENV SIMPLE_NAME=GraphicsMagick-$PKGVER
ENV FILENAME=$SIMPLE_NAME.tar.lz
ENV PKGSOURCE=https://sourceforge.net/projects/$PKGNAME/files/$PKGNAME/$PKGVER/$FILENAME/download

RUN apk add --update g++ \
                     gcc \
                     ca-certificates \
                     make \
                     lzip \
                     wget \
                     libjpeg-turbo-dev \
                     libpng-dev \
                     libtool \
                     libgomp && \
    wget $PKGSOURCE && \
    mv download $FILENAME && \
    lzip -d -c $FILENAME | tar -xvf - && \
    cd $SIMPLE_NAME && \
    ./configure \
      --build=$CBUILD \
      --host=$CHOST \
      --prefix=/usr \
      --sysconfdir=/etc \
      --mandir=/usr/share/man \
      --infodir=/usr/share/info \
      --localstatedir=/var \
      --enable-shared \
      --disable-static \
      --with-modules \
      --with-threads \
      --with-gs-font-dir=/usr/share/fonts/Type1 \
      --with-quantum-depth=16 && \
    make && \
    make install && \
    cd / && \
    rm -rf $SIMPLE_NAME && \
    rm $FILENAME && \
    apk del g++ \
            gcc \
            ca-certificates \
            make \
            lzip \
            wget
RUN npm install -g grunt-cli

ENTRYPOINT [ "/bin/bash" ]