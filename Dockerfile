FROM java:openjdk-7-jdk

MAINTAINER Edu Herraiz <ghark@gmail.com>

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
    
ENV HOME /var/lib/rundeck
ENV SHELL bash
ENV WORKON_HOME /var/lib/rundeck
WORKDIR /var/lib/rundeck

VOLUME /data

COPY conf /root/rundeck-config
COPY conf-templates /root/rundeck-config-templates

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rundeck"]

EXPOSE 4440
 
