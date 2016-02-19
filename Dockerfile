FROM java:openjdk-7-jdk

MAINTAINER Edu Herraiz <ghark@gmail.com>

ENV GRAILS_VERSION 3.1.0

RUN  \
    echo "deb http://dl.bintray.com/rundeck/rundeck-deb /" | tee -a /etc/apt/sources.list.d/rundeck.list && \
    wget -qO- https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add -
COPY system-requirements.txt /root/system-requirements.txt
RUN  \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    xargs apt-get -y -q install < /root/system-requirements.txt && \
    apt-get clean

COPY requirements.txt /root/requirements.txt
RUN pip install -r /root/requirements.txt

# RUN curl -s get.sdkman.io | bash && \
#     chmod +x /root/.sdkman/bin/sdkman-init.sh && \
#     /root/.sdkman/bin/sdkman-init.sh && \
#     yes | sdk install grails

ENV HOME /var/lib/rundeck
ENV SHELL bash
ENV WORKON_HOME /var/lib/rundeck
WORKDIR /var/lib/rundeck

# Install grails necessary to send mails
RUN wget https://github.com/grails/grails-core/releases/download/v$GRAILS_VERSION/grails-$GRAILS_VERSION.zip && \
    unzip grails-$GRAILS_VERSION.zip && \
    rm -rf grails-$GRAILS_VERSION.zip && \
    ln -s grails-$GRAILS_VERSION grails
ENV GRAILS_HOME /var/lib/rundeck/grails
ENV PATH $GRAILS_HOME/bin:$PATH

VOLUME /data

COPY conf /root/rundeck-config
COPY conf-templates /root/rundeck-config-templates

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rundeck"]

EXPOSE 4440
 
