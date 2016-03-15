#!/usr/bin/env groovy

// loglevel.default is the default log level for jobs: ERROR,WARN,INFO,VERBOSE,DEBUG
loglevel.default="{{ RUNDECK_LOG_LEVEL | default('INFO') }}"
rdeck.base="/var/lib/rundeck"

// rss.enabled if set to true enables RSS feeds that are public (non-authenticated)
rss.enabled="false"

grails.serverURL="{{ RUNDECK_SERVER_URL | default('http://localhost:4440') }}"

{% if RUNDECK_DATABASE_ENGINE == 'postgresql' %}
dataSource {
  dbCreate="update"
  driverClassName="org.postgresql.Driver"
  url="jdbc:postgresql://{{ RUNDECK_POSTGRES_HOST | default('postgres') }}/{{ RUNDECK_POSTGRES_DATABASE | default('rundeckdb') }}?autoReconnect=true"
  username="{{ RUNDECK_POSTGRES_USER | default('urundeck') }}"
  password="{{ RUNDECK_POSTGRES_PASSWORD | default('rundeckpass') }}"
}
{% endif %}

{% if RUNDECK_DATABASE_ENGINE == 'mysql' %}
dataSource {
  dbCreate="update"
  url="jdbc:mysql://{{ RUNDECK_MYSQL_HOST | default('mysql') }}/{{ RUNDECK_MYSQL_DATABASE | default('rundeckdb') }}?autoReconnect=true"
  username="{{ RUNDECK_MYSQL_USER | default('urundeck') }}"
  password="{{ RUNDECK_MYSQL_PASSWORD | default('rundeckpass') }}"
}
{% endif %}

grails {
  mail {
    host = "{{ RUNDECK_MAIL_HOST }}"
    username = "{{ RUNDECK_MAIL_USERNAME }}"
    port = {{ RUNDECK_MAIL_PORT }}
    password = "{{ RUNDECK_MAIL_PASSWORD }}"
    props = ["mail.smtp.auth":"{{ RUNDECK_MAIL_SMTP_AUTH }}",
      "mail.smtp.starttls.enable":"{{ RUNDECK_MAIL_STARTTLS }}",
      "mail.smtp.socketFactory.port":"{{ RUNDECK_MAIL_PORT }}",
      "mail.smtp.socketFactory.fallback":"false"]
  }
}
grails.mail.default.from = "{{ RUNDECK_MAIL_DEFAULT_FROM }}"

// "mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",