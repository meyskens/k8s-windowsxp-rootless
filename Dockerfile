FROM alpine:3.11


RUN apk add --no-cache qemu-system-i386 qemu-img bash
RUN apk add --no-cache tar # needed for kubectl cp

COPY run.sh /

ENTRYPOINT /run.sh