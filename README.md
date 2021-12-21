restic-formula
===========

Formula for install and configure Restic backup tool

This formula can configure a systemd timer in order to backup with Restic on ssh or local backend

OS families
-----------
Only tested on Debian 11

From
-------------
based on https://github.com/angristan/ansible-restic

and restic-tool : https://github.com/binarybucks/restic-tools

Available states
---------------------

``restic``

Meta-state to run all states in sequence: 'install', 'systemd' and 'service'.


``restic.install``

State to install Restic package and init Restic repository


``restic.systemd``

State to configure a systemd service and its timer


``restic.service``

State to enable and start systemd service


``restic.monitor``

State to install a Check_MK/Nagios check for verify last backup date
