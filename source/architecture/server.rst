Server
======

The server (``ishtaria-server``, AGPL-3.0) is authoritative: clients send
intentions, the server decides outcomes.

Sharding by cells
-----------------

The planet surface is divided into H3 cells. A *simulation node* owns a set
of cells. Empty cells run in an economy mode; busy cells can be split across
more nodes. When an entity crosses a cell boundary owned by another node,
it is handed over through NATS.

A small world runs everything in one process. Sharding is an operator
choice, not a requirement.

Tick rates
----------

* Active zone around players: 20–60 Hz, full physics.
* Surroundings: a few Hz, simplified entities, no physics.
* Rest of the planet: aggregate models, minutes to hours of game time per
  step. See :doc:`simulation`.

Process layout
--------------

* ``ishtaria-server`` – gateway, simulation, federation endpoint.
* systemd unit ``ishtaria-server.service`` running as user ``ishtaria``.
* Configuration in ``/etc/ishtaria/server.toml``,
  state in ``/var/lib/ishtaria``.
