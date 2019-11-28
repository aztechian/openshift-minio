FROM alpine:3.9

ENV MINIO_VER=2019-10-12T01-39-57Z

LABEL maintainer="Ian Martin <ian@imartin.net>" license="MIT" description="Repackage of minio into an Openshift compatible image" \
  minio_version=${MINIO_VER}

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY="demoaccesskey"
ENV MINIO_SECRET_KEY="mysecret"

RUN apk -Uuv add curl && \
  mkdir -p /minio/.minio /data && \
  adduser -D -u 8991 -G root minio && \
  curl -kLo /minio/minio https://dl.minio.io/server/minio/release/linux-amd64/minio.RELEASE.${MINIO_VER} && \
  chown -R minio:root /minio /data && \
  chmod -R g=u /minio /data && \
  chmod +x /minio/minio && \
  apk --purge -v del curl && \
  rm -rf /var/cache/apk/* && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

USER 8991
WORKDIR /minio
VOLUME ["/data"]
EXPOSE 9000

ENTRYPOINT [ "/minio/minio" ]
CMD ["server", "/data"]
