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

   sudo apt install ishtaria-server ishtaria-content ishtaria-worldgen postgresql
   sudoedit /etc/ishtaria/server.toml     # set server_name (permanent)
   sudo ishtaria-server-init              # generate a planet and import it (once)
   sudo systemctl enable --now ishtaria-server
   journalctl -u ishtaria-server -f

The package creates the PostgreSQL role and database ``ishtaria`` when
PostgreSQL is running during installation (peer authentication over the local
socket). It never touches an existing role or database. ``ishtaria-server-init
[seed] [face_size]`` runs ``ishtaria-worldgen`` and imports the result; the
server refuses to replace an already imported world.

Administration
--------------

.. code-block:: sh

   sudo apt install ishtaria-admin
   sudo -u ishtaria ishtaria-admin

``ishtaria-admin`` is a text-mode tool that works directly on the server's
database: save, load, rename, delete and export world maps; rename, ban and
delete players; manage portals to linked worlds; and schedule a server
shutdown. A scheduled shutdown shows players a non-dismissable system notice
with a countdown (``messages`` in ``GET /world``) and then stops the service
cleanly (exit status 0, so systemd does not restart it). Portals are records
only until federation is implemented. These functions are deliberately not part
of ``ishtaria-client``.
