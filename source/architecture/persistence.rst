Persistence
===========

Base world is a function
------------------------

At 1 m resolution an Earth-sized height map would have about
5·10\ :sup:`14` samples. Ishtaria never stores it: base terrain is a pure
function of ``(seed, position)``. Only **deltas** are stored.

Stores
------

.. list-table::
   :header-rows: 1

   * - Data
     - Store
   * - Accounts, inventories, trades, currency ledger
     - PostgreSQL (with PostGIS for spatial queries)
   * - Cell deltas, placed objects, aggregate cell state
     - key-value store keyed by H3 cell id
   * - Avatars, content packs, large blobs
     - S3-compatible object storage, content-addressed

Economy ledger
--------------

Every transfer of currency or traded goods is a double-entry transaction:
nothing appears or disappears without a matching entry. This is also what
makes federated exchange auditable (see :doc:`../federation/items-and-economy`).
