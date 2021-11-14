FROM alpine AS builder

RUN apk --no-cache upgrade \
 && apk --no-cache add git build-base cmake libuv-dev libmicrohttpd-dev openssl-dev util-linux-dev \
 && git clone https://github.com/xmrig/xmrig-proxy.git \
 && mkdir xmrig-proxy/build \
 && cd xmrig-proxy/build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j$(nproc)

FROM alpine

RUN apk add --no-cache libuv libmicrohttpd util-linux

COPY --from=builder /xmrig-proxy/build/xmrig-proxy /usr/local/bin/xmrig-proxy

CMD [ "/usr/local/bin/xmrig-proxy" ]
