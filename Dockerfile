
FROM alpine:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

ENV \
  ALPINE_MIRROR="mirror1.hs-esslingen.de/pub/Mirrors" \
  ALPINE_VERSION="v3.6" \
  TERM=xterm \
  VERSION=1.12

# ---------------------------------------------------------------------------------------

RUN \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/main"       > /etc/apk/repositories && \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache upgrade && \
  apk --quiet --no-cache add \
    build-base \
    bind-tools \
    drill \
    curl \
    perl \
    perl-dev \
    perl-json \
    perl-lwp-useragent-determined \
    readline \
    readline-dev \
    ncurses-libs \
    ncurses-dev

COPY build/ /build/

RUN \
  curl \
    --silent \
    --location \
    --output /bin/cpanm \
    https://cpanmin.us/ -o cpanm && \
    chmod +x /bin/cpanm && \
  curl \
    --silent \
    --location \
    --output /tmp/jmx4perl-${VERSION}.tar.gz \
    http://search.cpan.org/CPAN/authors/id/R/RO/ROLAND/jmx4perl-${VERSION}.tar.gz

RUN \
  cd /tmp && \
  tar -xzf jmx4perl-${VERSION}.tar.gz

RUN \
  cpanm IO::Socket::Multicast && \
  cpanm Config::General && \
  cpanm Crypt::Blowfish_PP && \
  cpanm Module::Find && \
  cpanm Monitoring::Plugin && \
  cpanm Sys::SigAction && \
  cpanm File::SearchPath && \
  cpanm ExtUtils::MakeMaker && \
  cpanm PJB/Term-Clui-1.70.tar.gz && \
  cpanm Term::ReadLine::Gnu && \
  cpanm Term::ShellUI && \
  cpanm Term::Size

RUN \
  cd /tmp && \
  tar -xzf jmx4perl-${VERSION}.tar.gz && \
  cd /tmp/jmx4perl-${VERSION} && \
  mv /build/build.pl . && \
  perl ./build.pl && \
  ./Build && \
  ./Build test && \
  ./Build install

RUN \
  apk del --purge \
    build-base \
    curl \
    perl-dev \
    readline-dev \
    ncurses-dev && \
  rm -rf \
    /root/.cpanm \
    /tmp/* \
    /var/cache/apk/*

CMD /bin/sh

# ---------------------------------------------------------------------------------------
#   curl \
#     --silent \
#     --location \
#     --output /tmp/ExtUtils-MakeMaker-7.30.tar.gz \
#     http://search.cpan.org/CPAN/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.30.tar.gz
#
# RUN \
#   cd /tmp/ExtUtils-MakeMaker-7.30 && \
#   perl Makefile.PL && \
#   make && \
#   make test && \
#   make install
