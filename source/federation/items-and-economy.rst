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

Every world has its own currency. Cross-world trade goes through escrow or
an exchange office with a rate (market or fixed) and daily caps. All
movements are double-entry ledger transactions.

Custom content packs
--------------------

* Content-addressed by hash, signed by the world, cached by clients.
* Data only: meshes (glTF), textures, definitions.
* **No executable code** in packs. Custom logic, if ever needed, runs only
  server-side as sandboxed WASM.
