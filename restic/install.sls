{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import restic with context %}

{%- if restic.backendtype == "ssh" %}
{%- set backup_restic_path = 'sftp:' + restic.user + '@' + restic.ssh_host + ':' + restic.host_path %}
{%- else %}
{%- set backup_restic_path = restic.host_path %}
{%- endif %}

restic-package-install-pkg-installed:
  pkg.installed:
    - name: {{ restic.pkg.name }}

{% if restic.backendtype == 'ssh' %}
restic-ssh-repo-accept-key:
  cmd.run:
    - name: ssh -o StrictHostKeyChecking=accept-new {{ restic.user }}@{{ restic.ssh_host }} exit
    - runas: {{ restic.rootuser }}
    - unless: ssh-keygen -F {{ restic.ssh_host }}
{% endif %}

restic-repo-init:
  cmd.run:
    - name: RESTIC_PASSWORD={{ restic.password }} {{ restic.path }} -r {{ backup_restic_path }}/{{ grains['id'] }} init
    - runas: {{ restic.rootuser }}
    - unless: RESTIC_PASSWORD={{ restic.password }} {{ restic.path }} -r {{ backup_restic_path }}/{{ grains['id'] }} snapshots
