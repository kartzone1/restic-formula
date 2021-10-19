{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

restic-package-install-pkg-installed:
  pkg.installed:
    - name: {{ restic.pkg.name }}

restic-ssh-repo-accept-key:
  cmd.run:
    - name: ssh -o StrictHostKeyChecking=accept-new {{ restic.user }}@{{ restic.ssh_host }} exit
    - runas: {{ restic.rootuser }}
    - unless: ssh-keygen -F {{ restic.ssh_host }}

restic-repo-init:
  cmd.run:
    - name: RESTIC_PASSWORD={{ restic.password }} {{ restic.path }} -r sftp:{{ restic.user }}@{{ restic.ssh_host }}:{{ restic.ssh_host_path }}/{{ grains['id'] }} init
    - runas: {{ restic.rootuser }}
    - unless: RESTIC_PASSWORD={{ restic.password }} {{ restic.path }} -r sftp:{{ restic.user }}@{{ restic.ssh_host }}:{{ restic.ssh_host_path }}/{{ grains['id'] }} snapshots
