Architecture overview
=====================

.. graphviz::

   digraph overview {
     rankdir=LR;
     node [shape=box, style=rounded, fontname="sans-serif"];
     client [label="ishtaria-client\n(Godot 4 + core via GDExtension)"];
     subgraph cluster_world {
       label="One world (ishtaria-server)"; style=dashed; fontname="sans-serif";
       gw   [label="Gateway\n(UDP / QUIC)"];
       sim  [label="Simulation shards\n(H3 cells, Rapier)"];
       eco  [label="Coarse ecosystem\nmodel"];
       fed  [label="Federation\nendpoint"];
       pg   [label="PostgreSQL\nledger, accounts", shape=cylinder];
       kv   [label="Delta store\n(cells, objects)", shape=cylinder];
     }
     peer [label="Federated world"];
     client -> gw -> sim;
     sim -> eco [dir=both];
     sim -> kv; sim -> pg;
     fed -> peer [dir=both, label="signed\nHTTPS/QUIC"];
     sim -> fed;
   }

Building blocks
---------------

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Concern
     - Choice
     - Reason
   * - Shared rules
     - ``ishtaria-core`` (Rust)
     - One implementation for server and client prediction.
   * - Server runtime
     - Rust, ECS (``bevy_ecs`` headless)
     - Performance, memory safety, shares code with core.
   * - Physics
     - Rapier
     - Rust-native, optionally deterministic.
   * - Spatial index
     - H3 cells
     - Hierarchical tiling of the sphere, natural shards.
   * - Client
     - Godot 4 (double-precision build), Jolt in previews
     - MIT licence, strong community, Linux export.
   * - Networking
     - UDP (renet) / QUIC (quinn)
     - Reliable and unreliable channels, encryption.
   * - Inter-shard messaging
     - NATS
     - Entity handover, events.
   * - Accounts, economy
     - PostgreSQL
     - ACID transactions for trade, double-entry ledger.
   * - World deltas
     - Key-value store keyed by cell + object storage
     - Large volumes, simple access pattern.
   * - Chat
     - Matrix
     - Federated chat already solved.
   * - Avatars
     - VRM 1.0 / glTF 2.0
     - Open, customisable humanoid format.

Distribution
------------

Every component is a Debian package; see :doc:`../operations/installation`.
