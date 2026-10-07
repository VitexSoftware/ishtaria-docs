Roadmap
=======

Each milestone produces something that can be installed and played or
operated on its own.

.. list-table::
   :header-rows: 1
   :widths: 8 30 62

   * - #
     - Milestone
     - Scope
   * - M0
     - Foundations
     - Repositories, Debian packaging, CI, documentation, identifiers and
       ruleset versions in ``ishtaria-core``, cube-sphere generator.
   * - M1
     - Single world, single biome
     - Authoritative server, client connects and walks on generated
       terrain, gathering and primitive crafting, persistence of deltas.
   * - M2
     - Living world
     - Simulation levels of detail, cell-level ecosystem, offline avatars,
       day/night and seasons.
   * - M3
     - Economy
     - Inventories, barter, player-made currency, double-entry ledger.
   * - M4
     - Federation: avatars
     - ``@user:server`` identities, server keys, portals carrying avatar
       and cosmetics only.
   * - M5
     - Federation: items
     - Item provenance, import/export policies, two-phase handover.
   * - M6
     - Federation: currencies
     - Exchange between world currencies with caps.
   * - M7
     - Custom content
     - Hash-addressed content packs, fallbacks for unknown kinds,
       sandboxed WASM server logic.
   * - M8
     - Community and visibility
     - Achievements and share links for social networks
       (:doc:`decisions/0011-sharing-achievements`), memorial and hall of
       fame pages, a showcase on the web portal, the chronicle of a world,
       creator tools. Supported by a developer guide
       (:doc:`development/contributing`) and a hardened, observable server
       (:doc:`operations/hardening`).
