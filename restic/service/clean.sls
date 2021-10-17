# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as restic with context %}

restic-service-clean-service-dead:
  service.dead:
    - name: {{ restic.service.name }}
    - enable: False
