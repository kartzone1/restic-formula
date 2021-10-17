# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_systemd_file = tplroot ~ '.systemd' %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

include:
  - {{ sls_systemd_file }}

restic-service-running-service-running:
  service.running:
    - name: {{ restic.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_systemd_file }}
