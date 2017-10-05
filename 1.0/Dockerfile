# Set the base image
FROM openjdk:8-jre-alpine

LABEL maintainer="MAINTAINER MQTT.Cool Development Team <support@lightstreamer.com>"

# Set environment variables to identify the right Lightstreamer version and edition
ENV MQTTCOOL_VERSION 1_0_3_b1_20170929
ENV MQTTCOOL_URL_DOWNLOAD http://www.lightstreamer.com/repo/distros/mqtt.cool_${MQTTCOOL_VERSION}.tar.gz

# Set the temporary working dir
WORKDIR /mqtt.cool

RUN set -x \
       apk add update \

# Install the required packages
        && apk add --no-cache --virtual .fetch-deps \
                gnupg \
                tar \
                openssl \

# Import Lighstreamer's public key (it seems that current gpg version has an issue while contacting keyserver, therefore a workaround is required)
        # && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 9B90BFD14309C7DA5EF58D7D4A8C08966F29B4D2 \
        && wget "https://ha.pool.sks-keyservers.net/pks/lookup?op=get&search=0x4A8C08966F29B4D2" -O - | gpg --import \

# Download the distribution from the Lightstreamer site, verify the signature, and unpack
        && wget -O mqtt.cool.tar.gz ${MQTTCOOL_URL_DOWNLOAD} \
        && wget -O mqtt.cool.tar.gz.asc ${MQTTCOOL_URL_DOWNLOAD}.asc \
        && gpg --batch --verify mqtt.cool.tar.gz.asc mqtt.cool.tar.gz \
        && tar -xvf mqtt.cool.tar.gz --strip-components=1 \

# Replace the fictitious jdk path with the JAVA_HOME environment variable in the launch script file
        && sed -i -- 's/\/usr\/jdk1.8.0/$JAVA_HOME/' bin/unix-like/mc.sh \

# Addjust logging configurations in order to log only on standard output
        && sed -i -e '123,$s/<appender-ref ref="LSDailyRolling" \/>/<appender-ref ref="LSConsole" \/>/' \
                  -e '/<appender-ref ref="LSDailyRolling" \/>/ d' conf/lightstreamer_log_conf.xml \
        && sed -i -e '67,$s/<appender-ref ref="MQTTCoolRolling" \/>/<appender-ref ref="LSConsole" \/>/' mqtt_connectors/mqtt_master_connector_log_conf.xml \

# Finally, remove no longer needed packages and files
        && apk del gnupg tar openssl \
        && rm mqtt.cool.tar.gz mqtt.cool.tar.gz.asc

# Export TCP port 8080
EXPOSE 8080

# Set the final working dir
WORKDIR /mqtt.cool/bin/unix-like

# Start the server
CMD ["./mc.sh", "run"]
