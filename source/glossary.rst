Glossary
========

.. glossary::

   World
      One running Ishtaria server instance with its own planet, players,
      economy and rules configuration.

   Portal
      In-game structure that connects two federated worlds. Allowed by an
      agreement, built by players.

   Federation agreement
      Bilateral, per-side configuration that defines what may cross
      between two worlds. See :doc:`federation/agreement`.

   Travel ticket
      Signed, short-lived, single-use document that carries a player across
      a portal. See :doc:`federation/travel-ticket`.

   Home server
      The world that issued a player's identity (``@user:home``) and keeps
      the player's master record.

   Provenance
      Signed record of which world minted an item.

   Ruleset
      Versioned set of item kinds, categories, recipes and fallbacks
      (``core-rules@1.0``). Federating worlds must share its major version.

   Cell
      Hexagonal H3 cell on the planet surface; the unit of simulation,
      sharding and storage.

   Delta
      A stored change to the procedurally generated base world.

   Catch-up
      Materialising concrete entities from aggregate state when a region
      becomes observed again.
