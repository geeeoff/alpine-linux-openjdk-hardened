FROM gyaworski/alpine-linux-hardened:alpine-3.6-hardened-1.0 AS alpine-linux-hardened

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:$JAVA_HOME/bin

# since image is hardened, we don't have APK
# run it from a static binary
ADD apk-tools-static-2.7.2-r0-x86_64.apk ./apk-tools-static-2.7.2-r0-x86_64.apk

# install JRE
RUN set -x \
    && ./apk-tools-static-2.7.2-r0-x86_64.apk/sbin/apk.static \
                    -X http://dl-cdn.alpinelinux.org/alpine/v3.6/community \
                    -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main  \
                    -U --allow-untrusted  \
                    --initdb  --progress --no-cache \
                    add openjdk8-jre=8.131.11-r2 \
    && rm -rf ./apk-tools-static-2.7.2-r0-x86_64.apk \ 
# Remove apk configs.
    && sysdirs=" \
	  	/bin \
  		/etc \
  		/lib \
  		/sbin \
  		/usr \
	" \
	&& find $sysdirs -xdev -regex '.*apk.*' -exec rm -fr {} +