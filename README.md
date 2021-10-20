restic-formula
===========

Formula for install and configure Restic backup tool

This formula can configure a systemd timer in order to backup with Restic on ssh or local backend

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

``OS families``

Only tested on Debian 11

From
-------------
based on https://github.com/angristan/ansible-restic

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
