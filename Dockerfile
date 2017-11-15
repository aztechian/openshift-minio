FROM alpine:3.6

ENV MINIO_VER=2017-10-27T18-59-02Z

LABEL maintainer="Ian Martin <ian@imartin.net>" license="MIT" description="Repackage of minio into an Openshift compatible image" \
  minio_version=${MINIO_VER}

ENV MINIO_ACCESS_KEY="demoaccesskey"
ENV MINIO_SECRET_KEY="mysecret"

RUN apk -Uuv add curl && \
  mkdir -p /minio /data && \
  addgroup -g 8991 minio && \
  adduser -D -u 8991 -G minio minio && \
  curl -kLo /minio/minio https://dl.minio.io/server/minio/release/linux-amd64/minio.RELEASE.${MINIO_VER} && \
  chown -R minio:minio /minio /data && \
  chmod +x /minio/minio && \
  apk --purge -v del curl && \
  rm -rf /var/cache/apk/*

USER minio
WORKDIR /minio
VOLUME ["/data"]
EXPOSE 9000

ENTRYPOINT [ "/minio/minio" ]
CMD ["server", "/data"]
