# Set the base image
FROM openjdk:8-jre

LABEL maintainer="Lightstreamer Server Development Team <support@lightstreamer.com>"

# Set environment variables to identify the right Lightstreamer version and edition
ENV MQTTCOOL_VERSION 1_0_3_b3_20180111
ENV MQTTCOOL_URL_DOWNLOAD http://www.lightstreamer.com/repo/distros/mqtt.cool_${MQTTCOOL_VERSION}.tar.gz

# Set the temporary working dir
WORKDIR /mqtt.cool

# Install the required packages
RUN set -ex; \

# Import Lighstreamer's public key
        gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 9B90BFD14309C7DA5EF58D7D4A8C08966F29B4D2 \

# Download the distribution from the Lightstreamer site, verify the signature, and unpack
        && curl -fSL -o mqtt.cool.tar.gz ${MQTTCOOL_URL_DOWNLOAD} \
        && curl -fSL -o mqtt.cool.tar.gz.asc ${MQTTCOOL_URL_DOWNLOAD}.asc \
        && gpg --batch --verify mqtt.cool.tar.gz.asc mqtt.cool.tar.gz \
        && tar -xvf mqtt.cool.tar.gz --strip-components=1 \

# Replace the fictitious jdk path with the JAVA_HOME environment variable in the launch script file
        && sed -i -- 's/\/usr\/jdk1.8.0/$JAVA_HOME/' bin/unix-like/mc.sh \

# Addjust logging configurations in order to log only on standard output
        && sed -i -e '123,$s/<appender-ref ref="LSDailyRolling" \/>/<appender-ref ref="LSConsole" \/>/' \
                  -e '/<appender-ref ref="LSDailyRolling" \/>/ d' conf/lightstreamer_log_conf.xml \
        && sed -i -e '67,$s/<appender-ref ref="MQTTCoolRolling" \/>/<appender-ref ref="LSConsole" \/>/' mqtt_connectors/mqtt_master_connector_log_conf.xml \

# Finally, remove no longer needed files
        && rm mqtt.cool.tar.gz mqtt.cool.tar.gz.asc

# Export TCP port 8080
EXPOSE 8080

# Set the final working dir
WORKDIR /mqtt.cool/bin/unix-like

# Start the server
CMD ["./mc.sh", "run"]
