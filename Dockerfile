FROM alpine:3.24.3 AS builder
WORKDIR /build
COPY . .
RUN --mount=type=secret,id=GH_TOKEN \
    apk update \
 && apk add bash curl file libarchive-tools \
 && mkdir -p bin/bin \
 && GH_TOKEN="$(cat /run/secrets/GH_TOKEN)" /build/binstall

FROM scratch
LABEL org.opencontainers.image.authors="https://github.com/ug1ybob"
COPY --link --from=builder --chmod=755 /build/bin /bin
ENTRYPOINT ["/bin/bash"]

