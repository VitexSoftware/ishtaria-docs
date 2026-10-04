Configuration
=============

``/etc/ishtaria/server.toml``

.. code-block:: toml

   # DNS name of this world; becomes part of every player and item id.
   server_name = "ishtaria.example.org"
   # Rules shared with federated worlds (must match peers' major version).
   ruleset = "core-rules@1.0"
   listen = "0.0.0.0:7400"

.. warning::

   ``server_name`` is permanent. Player ids (``@user:server``) and item ids
   (``server/uuid``) embed it, so changing it later breaks identities and
   federation. Choose a domain you will keep.

Federation agreements
---------------------

Agreements live in ``/etc/ishtaria/federation/<peer>.yaml`` and follow the
schema in :doc:`../federation/agreement`. Validate before reloading:

.. code-block:: sh

   python3 -m jsonschema \
     -i /etc/ishtaria/federation/svet-b.example.org.yaml \
     /usr/share/ishtaria/protocol/schemas/federation-agreement.schema.json

.. todo:: Federation loading is not implemented yet (milestone M4).
