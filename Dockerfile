#
# This Dockerfile builds a recent curl with HTTP/2 client support, using
# a recent nghttp2 build.
#
# See the Makefile for how to tag it. If Docker and that image is found, the
# Go tests use this curl binary for integration tests.
#

FROM docker.io/library/ibmjava:11-jdk

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git-core build-essential wget

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

#RUN apt-get remove python2

RUN apt-get install -y --no-install-recommends \
       autotools-dev libtool pkg-config zlib1g-dev \
       libcunit1-dev libssl-dev libxml2-dev libevent-dev \
       automake autoconf 

# The list of packages nghttp2 recommends for h2load:
RUN apt-get install -y --no-install-recommends make binutils \
        autoconf automake autotools-dev \
        libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev \
        libev-dev libevent-dev libjansson-dev libjemalloc-dev \
        python3 python3-dev python3-setuptools zip unzip nghttp2


WORKDIR /root

RUN wget https://github.com/nghttp2/nghttp2/releases/download/v1.55.1/nghttp2-1.55.1.tar.gz && \
tar -xvf nghttp2-1.55.1.tar.gz

RUN cd /root/nghttp2-1.55.1  && \
./configure && make && \
make install

WORKDIR /root
RUN wget  https://curl.se/download/curl-8.2.1.tar.gz
RUN tar -zxvf curl-8.2.1.tar.gz
WORKDIR /root/curl-8.2.1
RUN ./configure --with-ssl --with-nghttp2=/usr/local
RUN make
RUN make install
RUN ldconfig



### copy start ###

COPY start.sh /opt/jboss/start

RUN chmod a+rwx /opt/jboss/start



############ SSO ################## 
### unzip distribution of sso here




# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss


WORKDIR /tmp
COPY rh-sso-7.6.0-server-dist.zip rh-sso.zip
COPY /extentions  /tmp/extentions
RUN unzip rh-sso.zip && \
mv rh-sso-7.6 /opt/jboss/sso &&  \
chown -R jboss:jboss /opt/jboss /tmp/extentions



USER jboss

RUN id && cd /opt/jboss/sso && \
./bin/jboss-cli.sh --file=/tmp/extentions/postgres.cli




EXPOSE 8080/tcp


ENTRYPOINT ["/opt/jboss/start"]


