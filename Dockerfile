FROM java:8

ENV PORT 1389

ENV LDAPS_PORT 1636

ENV BASE_DN dc=example,dc=com

ENV ROOT_USER_DN cn=Directory Manager

ENV ROOT_PASSWORD password

ENV VERSION 4.1.5

WORKDIR /opt

RUN apt-get install -y wget unzip

RUN wget --quiet https://github.com/OpenIdentityPlatform/OpenDJ/releases/download/$VERSION/opendj-$VERSION.zip && unzip opendj-$VERSION.zip && rm -r opendj-$VERSION.zip

COPY base_example.ldif /opt

RUN /opt/opendj/setup --cli \
  -p $PORT \
  --ldapsPort $LDAPS_PORT \
  --enableStartTLS \
  --generateSelfSignedCertificate \
  --baseDN "$BASE_DN" \
  -h localhost \
  --rootUserDN "$ROOT_USER_DN" \
  --rootUserPassword $ROOT_PASSWORD \
  --ldifFile /opt/base_example.ldif \
  --acceptLicense \
  --no-prompt \
  --doNotStart

CMD ["/opt/opendj/bin/start-ds", "--nodetach"]