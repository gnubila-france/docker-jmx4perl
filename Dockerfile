
FROM ubuntu:16.04

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

ENV \
  TERM=xterm \
  PAGER=cat \
  VERSION=1.12

# ---------------------------------------------------------------------------------------

RUN \
  apt-get update && apt-get install -y \
    build-essential \
    openssl \
    perl \
    libssl-dev \
    libreadline-dev \
    libexpat1-dev && \
  cpan App::cpanminus < /dev/null && \
  cpanm --quiet --notest \
    LWP::Protocol::https \
    IO::Socket::Multicast \
    Config::General \
    Crypt::Blowfish_PP \
    Module::Find  \
    Monitoring::Plugin \
    Sys::SigAction \
    File::SearchPath \
    ExtUtils::MakeMaker \
    PJB/Term-Clui-1.70.tar.gz \
    Term::ReadLine::Gnu \
    Term::ShellUI \
    Term::Size \
    Net::HTTP \
    ROLAND/jmx4perl-${VERSION}.tar.gz && \
    apt-get -y purge build-essential libssl-dev libreadline-dev libexpat1-dev && \
    apt-get -y autoremove && \
  rm -rf \
    /root/.cpanm \
    /tmp/* \
    /var/lib/apt/lists/*

CMD [ "jmx4perl", "--version" ]

# ---------------------------------------------------------------------------------------

