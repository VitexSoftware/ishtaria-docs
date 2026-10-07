Backup, restore and upgrade
===========================

What to keep
------------

* **The PostgreSQL database** (default name ``ishtaria``): characters, inventories, graves, placed things, the
  imported planet and the signing key of the world. This is the whole state of the world.
* ``/etc/ishtaria/server.toml`` and ``/etc/ishtaria/federation/`` (agreements).
* The installed datadisks are packages and can be installed again, but note which ones and their
  versions: a world records them and pins them by hash.

A backup contains the private signing key of the world and all password hashes. Keep it encrypted and
off the server.

Back up
-------

.. code-block:: sh

   sudo -u postgres pg_dump --format=custom --file=/var/backups/ishtaria-$(date +%F).dump ishtaria

Run it daily from cron or a systemd timer and copy the file to another machine. It can run while the
world is online. Keep several generations: a corrupted world is often noticed days later.

Restore
-------

On a machine with the same (or a newer) ``ishtaria-server`` package and PostgreSQL:

.. code-block:: sh

   sudo systemctl stop ishtaria-server
   sudo -u postgres createdb ishtaria_restore
   sudo -u postgres pg_restore --dbname=ishtaria_restore --no-owner /var/backups/ishtaria-2026-10-07.dump
   # check it, then point server.toml (database_url) at ishtaria_restore, or restore over an empty ishtaria
   sudo systemctl start ishtaria-server

**Never restore over a live database** and never run the server of one world on two copies of the
database at once: both would sign as the same world.

Upgrade
-------

#. Read the changelog of the package.
#. Take a backup.
#. ``sudo apt update && sudo apt install ishtaria-server``. The package restarts the service and the server applies
   new migrations at start.
#. Check ``journalctl -u ishtaria-server``, ``/health`` and ``/metrics``.

Migrations are append-only and are never edited after a release, so an older backup restored into a newer
server is migrated forward at start. There is **no downgrade**: to go back, restore the backup taken
before the upgrade and install the older package.

Try the restore
---------------

A backup that was never restored is a hope, not a backup. Once, and after every change of the setup,
restore into a scratch database on another machine, start a server against it on a spare port and log in with a test
character.
