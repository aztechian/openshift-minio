FROM golang:1.9.1-alpine3.6
LABEL maintainer="Ian Martin <ian@imartin.net>" license="MIT" description="Repackage of minio into an Openshift compatible image"

ENV MINIO_ACCESS_KEY="demoaccesskey"
ENV MINIO_SECRET_KEY="mysecret"

RUN useradd -d /opt/minio -g root minio

RUN mkdir -p /minio /data
  addgroup -u 8991 -S minio && \
  adduser -D -S -u 8991 -G minio minio && \
  chown -R minio:minio /minio /data && \
  cd /minio && \
  curl -kLO minio https://dl.minio.io/server/minio/release/linux-amd64/minio && \
  chmod +x minio && \

USER minio
WORKDIR /minio
VOLUME ["/data"]
EXPOSE 9000

ENTRYPOINT [ "/minio/minio" ]
