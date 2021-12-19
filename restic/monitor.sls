# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.install' %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

include:
  - {{ sls_package_install }}

restic-tool-bin-file-managed:
  file.managed:
    - name: {{ restic.tool.bin.path }}/{{ restic.tool.bin.name }}
    - source: {{ restic.tool.bin.source }}
    - mode: {{ restic.tool.bin.configmode }}
    - user: {{ restic.rootuser }}
    - group: {{ restic.rootgroup }}
    - makedirs: True

restic-tool-config-directory:
  file.directory:
    - name: {{ restic.tool.path }}
    - mode : {{ restic.tool.configmode }}
    - user: {{ restic.rootuser }}
    - group: {{ restic.rootgroup }}
    - makedirs: True

restic-tool-config-file-managed:
  file.managed:
    - name: {{ restic.tool.path }}/{{ restic.tool.config_file }}
    - source: {{ restic.tool.config_file_tmpl }}
    - mode: {{ restic.tool.configmode }}
    - user: {{ restic.rootuser }}
    - group: {{ restic.rootgroup }}
    - makedirs: True
    - template: jinja

restic-tool-repo-file-managed:
  file.managed:
    - name: {{ restic.tool.path }}/{{ restic.tool.repo_file }}
    - source: {{ restic.tool.repo_file_tmpl }}
    - mode: {{ restic.tool.configmode }}
    - user: {{ restic.rootuser }}
    - group: {{ restic.rootgroup }}
    - makedirs: True
    - template: jinja

restic-tool-monitor-file-managed:
  file.managed:
    - name: {{ restic.tool.monitor.path }}/{{ restic.tool.monitor.script_name }}
    - source: {{ restic.tool.monitor.script_file_tmpl }}
    - mode: {{ restic.tool.monitor.configmode }}
    - user: {{ restic.rootuser }}
    - group: {{ restic.rootgroup }}
    - makedirs: True
    - template: jinja
