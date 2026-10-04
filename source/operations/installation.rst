Installation
============

All Ishtaria components are Debian packages for **Debian and Ubuntu on
x86-64**. Windows and macOS are not supported.

Packages
--------

.. list-table::
   :header-rows: 1

   * - Package
     - Contents
   * - ``ishtaria-server``
     - world server, systemd unit, ``/etc/ishtaria/server.toml``
   * - ``ishtaria-client``
     - game client (``ishtaria-client``), desktop entry
   * - ``ishtaria-worldgen``
     - planet generator command-line tool
   * - ``ishtaria-content``
     - base ruleset ``core-rules`` in ``/usr/share/ishtaria/content``
   * - ``ishtaria-protocol``
     - federation schemas in ``/usr/share/ishtaria/protocol``
   * - ``ishtaria-doc``
     - this documentation in HTML

Adding the repository
---------------------

Packages are published in the VitexSoftware APT repository:

.. code-block:: sh

   echo "deb http://repo.vitexsoftware.com $(lsb_release -sc) main" \
     | sudo tee /etc/apt/sources.list.d/vitexsoftware.list
   sudo wget -O /etc/apt/trusted.gpg.d/vitexsoftware.gpg \
     http://repo.vitexsoftware.com/keyring.gpg
   sudo apt update

Playing
-------

.. code-block:: sh

   sudo apt install ishtaria-client

Running a world
---------------

.. code-block:: sh

   sudo apt install ishtaria-server ishtaria-content
   sudoedit /etc/ishtaria/server.toml     # set server_name
   sudo systemctl enable --now ishtaria-server
   journalctl -u ishtaria-server -f
