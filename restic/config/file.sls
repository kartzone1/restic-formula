# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as restic with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

restic-service-file-file-managed:
  file.managed:
    - name: {{ restic.config-service }}
    - source: {{ files_switch(['restic-backup.service.tmpl'],
                              lookup='restic-service-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ restic.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        restic: {{ restic | json }}

restic-timer-file-file-managed:
  file.managed:
    - name: {{ restic.config-timer }}
    - source: {{ files_switch(['restic-backup.timer.tmpl'],
                              lookup='restic-timer-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ restic.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        restic: {{ restic | json }}
