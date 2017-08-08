
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
    perl \
    perl-dev \
    readline \
    readline-dev \
    ncurses-libs \
    ncurses-dev \
    libxml2-dev \
    expat-dev \
    gnupg1 \
    openssl-dev \
    wget && \
  cpan App::cpanminus < /dev/null && \
  cpanm --quiet IO::Socket::Multicast && \
  cpanm --quiet Config::General && \
  cpanm --quiet Crypt::Blowfish_PP && \
  cpanm --quiet Module::Find && \
  cpanm --quiet Monitoring::Plugin && \
  cpanm --quiet Sys::SigAction && \
  cpanm --quiet File::SearchPath && \
  cpanm --quiet ExtUtils::MakeMaker && \
  cpanm --quiet PJB/Term-Clui-1.70.tar.gz && \
  cpanm --quiet Term::ReadLine::Gnu && \
  cpanm --quiet Term::ShellUI && \
  cpanm --quiet Term::Size && \
  cpanm --quiet ROLAND/jmx4perl-${VERSION}.tar.gz && \
  apk del --purge \
    build-base \
    perl-dev \
    readline-dev \
    ncurses-dev \
    libxml2-dev \
    expat-dev \
    gnupg1 \
    openssl-dev \
    wget && \
  rm -rf \
    /root/.cpanm \
    /tmp/* \
    /var/cache/apk/*

CMD [ "jmx4perl", "--version" ]

# ---------------------------------------------------------------------------------------
