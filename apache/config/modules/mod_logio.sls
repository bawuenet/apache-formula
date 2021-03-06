# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import apache with context %}

    {%- if grains['os_family'] in ('Suse', 'Debian',) %}

include:
  - {{ sls_service_running }}
  - {{ sls_package_install }}

apache-config-modules-logio-pkg:
  cmd.run:
    - name: a2enmod logio
    - unless: ls {{ apache.moddir }}/logio.load || egrep "^APACHE_MODULES=" /etc/sysconfig/apache2 | grep logio
    - order: 255
    - require:
      - pkg: apache-package-install-pkg-installed
    - watch_in:
      - module: apache-service-running-restart
    - require_in:
      - module: apache-service-running-restart
      - module: apache-service-running-reload
      - service: apache-service-running

    {%- endif %}
