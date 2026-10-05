0008 – Story datadisks
======================

:Status: Accepted; a first vertical slice is implemented (see :doc:`../architecture/story`)
:Date: 2026-10-05

Context
-------

Ishtaria needs characters, dialogues, decision trees and scenarios that an author
can write without changing the server, and that fit the rule that the **server owns
every outcome**. The first story is The End Land, written by a different author as a
free-text wiki. Several story packs must be usable in one world, and the places and
characters they describe must exist on the generated planet.

Decision
--------

* A **datadisk** is a versioned directory of YAML files and media: places, characters
  (NPCs), dialogue trees, quests, lore, translations, portraits and music. It is data,
  not code; conditions and effects are structured (``flag``, ``quest_stage``,
  ``has_item``, ``gold_at_least``; ``give_item``, ``take_item``, ``gold``,
  ``set_flag``, ``set_stage``, ``once``). There is no scripting.
* The format is defined by ``ishtaria-protocol/schemas/datadisk.schema.json`` and
  checked by ``tests/validate_datadisk.py``; the server validates the same rules and
  rejects a disk it cannot fully understand, including unreviewed ``draft`` dialogues.
* **Several datadisks can be combined.** Every id is qualified ``<disk>:<id>``; a disk
  may refer to another only through a declared dependency; disks may declare
  conflicts. The order of application is by dependency, then by id, so placement is
  reproducible.
* The disks a world uses are chosen **when the world is generated** (the
  ``ishtaria-admin`` map dialog shows one checkbox per installed disk) and are part of
  the world: the content hash of each disk is pinned the first time the server loads
  it, and a changed disk is refused instead of silently used.
* **Places** are placed deterministically from the world seed and persisted as anchors;
  they never move. Requirements (biome, height, slope, distance to other places) are
  honoured; a place that cannot be placed stops the story with a clear error.
* Dialogue state, quest stages, flags and ``once`` rewards are **server state** per
  player. A client names a choice and the sequence number of the answer it saw; it
  never sends gold, items or stages.
* The server does not know the player's language. It serves the translations of every
  language and sends only translation keys.
* A dialogue may show a portrait and play music. Media files are served only from the
  list a loaded disk names, with a fixed set of types (PNG, JPEG, OGG).
* Missing dialogue text may be drafted **once**, offline, with a local LLM
  (``status: draft``) and must be reviewed by a person. No LLM runs on the game server.

Consequences
------------

* The first disk can be replaced or extended without a server release; new
  conditions or effects need a new server version and a schema change.
* Story state is not carried through portals yet; whether and how it travels between
  worlds is a separate decision.
* Artwork and texts of a disk belong to its author: the disk carries its own licence
  and attribution, and the pilot disk is kept private.
