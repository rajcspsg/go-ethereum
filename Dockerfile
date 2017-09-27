FROM ubuntu:latest as builder

ENV DEBIAN_FRONTEND=noninteractive \
 INITRD=No \
 LANG=en_US.UTF-8 \
 GOVERSION=1.9 \
 GOROOT=/opt/go \
 GOPATH=/root/.go 
RUN  apt-get update \
  && apt-get install -y software-properties-common \
  && apt-get install -y wget \
  && apt-get install -y make \
  && rm -rf /var/lib/apt/lists/* \
  && add-apt-repository ppa:jonathonf/gcc-7.2 \
  && apt-get update \
  && apt-get install -y gcc g++ \
  && apt-get install -y linux-headers-4.11.0-14-generic \
  && apt-get install -y musl-dev \
  && cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/bin/ && \
    mkdir $GOPATH

ADD . /go-ethereum
RUN mkdir -p /usr/local/config \
    && mkdir -p /home/ubuntu/eth-dev \
    && mkdir -p /usr/local/scripts \
    && cd /go-ethereum && make geth


COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/
COPY --from=builder /go-ethereum/scripts/entry-point.sh /usr/local/bin/
COPY --from=builder /go-ethereum/genesis/genesis.json /usr/local/config/
           
EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["entry-point.sh"]


