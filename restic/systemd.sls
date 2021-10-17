# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.install' %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

include:
  - {{ sls_package_install }}

restic-service-file-file-managed:
  file.managed:
    - name: {{ restic.config_service }}
    - source: {{ restic.config_service_tmpl }}
    - mode: {{ restic.configmode }}
    - user: {{ restic.rootuser }}
    - group: {{ restic.rootgroup }}
    - makedirs: True
    - template: jinja

restic-timer-file-file-managed:
  file.managed:
    - name: {{ restic.config_timer }}
    - source: {{ restic.config_timer_tmpl }}
    - mode: {{ restic.configmode }}
    - user: {{ restic.rootuser }}
    - group: {{ restic.rootgroup }}
    - makedirs: True
    - template: jinja
