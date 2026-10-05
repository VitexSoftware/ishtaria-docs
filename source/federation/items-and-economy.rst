Items and economy across worlds
===============================

The core risk
-------------

A modified server can mint unlimited currency or legendary items. Every
agreement therefore acts as a **customs policy**.

Provenance
----------

Items have a global id ``origin.server/uuidv7``. The origin world signs the
item at creation; the signature travels with it. When an item returns to its
origin, it is checked against the origin's own records, which prevents
duplication.

Unknown item kinds
------------------

Worlds may define their own kinds (``svet-a:dragon_axe``). Each such kind
must declare a ``fallback`` from the shared ``core:`` namespace. A world
that does not know the kind either accepts it as the fallback with the
given parameters or rejects it, according to its import policy.

Currencies
----------

Gold coins are **physical items in the player's inventory** (category
``currency``). They are not a separate account balance and are not converted:
only the **number of coins** travels between worlds, one for one. A coin that
crosses a portal is simply an item in the travel ticket, so it is limited by
the inventory capacity of the player, is dropped into the grave on death, and
can be looted like any other item.

Because coins are not converted, a world cannot protect itself through an
exchange rate. Each agreement is the customs policy instead:

* ``import.currency: count`` allows coins to arrive; ``deny`` (default) keeps
  them at the border. The import limits of ``items`` (``daily_limit_per_player``)
  apply to coins as well.
* A per-agreement daily cap on coins entering the world bounds the damage of a
  peer that mints coins without restraint; an operator can lower it or close
  the portal.
* Coins taken out of a world are removed there in the same two-phase handover
  as every other item, so they cannot be spent twice.
* The 100 starting coins are granted only when the player's record is created
  in the home world; arriving as a guest never grants them again.

Coins in the inventory
~~~~~~~~~~~~~~~~~~~~~~

A coin stack holds 10,000 coins. Coins are the only item that may occupy
several slots, so the amount a player can carry is limited only by the free
inventory slots, and the number of coins that may cross a portal is not
limited by the agreement's item limits beyond what the world chooses to set.
Existing balances were moved from the former balance column into the
inventory by migration ``0015_gold_in_inventory.sql``; the API still reports
the exact amount as ``stats.gold`` and in a grave's ``gold`` field.

Portal toll
~~~~~~~~~~~

Using a portal costs **2 coins**. One coin is credited to each of the two
players whose cooperation created the portal (one per end), even when that
player is currently playing in another world. Because a coin is an inventory
item, a credit that cannot be delivered at once waits in the account's inbox
and is added when the player is next available at their home world. The toll
travels with the travel ticket, so no coin is created or lost. (Planned: the
toll is part of the travel handover, not yet implemented.)

Worlds with very different price levels can be abused by carrying coins back
and forth. Operators are expected to set caps accordingly, or to deny coins in
one direction.

Custom content packs
--------------------

* Content-addressed by hash, signed by the world, cached by clients.
* Data only: meshes (glTF), textures, definitions.
* **No executable code** in packs. Custom logic, if ever needed, runs only
  server-side as sandboxed WASM.
