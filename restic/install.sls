{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

restic-package-install-pkg-installed:
  pkg.installed:
    - name: {{ restic.pkg.name }}

restic-repo-init:
  cmd.run:
    - name: {{ restic.path }} -p {{ restic.password }} -r sftp:{{ restic.user }}:{{ restic.ssh_host }}:{{ restic.ssh_host_path }}/{{ grains['id'] }} init > ./restic-state
    - runas: {{ restic.rootuser }}
    - cwd: {{ restic.path }}
    - unless: grep -q "created restic repository" ./restic-state
