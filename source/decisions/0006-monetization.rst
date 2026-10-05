0006 – Monetization with real money: land leases, imported models, custom avatars
==================================================================================

:Status: Accepted requirements. Implemented: monthly land leases with orders, signed payment
    webhook (manual provider) and exclusive building on leased land. Not implemented:
    imported models, custom avatars, gateway providers other than manual, ruins of lapsed
    leases, protection of property.
:Date: 2026-10-05

Context
-------

Operators of a world need income. The requirements are:

* **Land lease.** The owner (operator) of a world receives regular fees for the
  area of land a player rents. Only the tenant can build on rented land.
  Rent is paid **monthly**. If the tenant stops paying, the exclusive right to
  the parcel ends and the other players may **mine the tenant's structures
  for materials**.
* **Imported models.** For a **one-time fee** a tenant can place **any imported
  model** on rented land.
* **Protection of property.** While a property has a living owner, or stands on
  rented land, no other player can take it.
* **Custom avatar.** A player may use their own avatar if they pay a one-time
  fee when the character is created.

Payments are real money through a **payment gateway** into the account of the
world's operator. Each world is independent (decision 0001): there is no central
payment service and federation is not involved in payments.

Decision
--------

Land
~~~~

* A **parcel** is a rectangle of map **tiles** (one tile is one cell of the
  object grid, about 17 m) on one cube face. Parcels never overlap.
* A **lease** belongs to one player and has ``paid_until``, a monthly price per
  tile set by the operator in minor currency units, and a state: ``active``,
  ``grace`` (unpaid, still exclusive) and ``lapsed``.
* On leased land only the tenant (and whoever the tenant names) may place
  construction sites, items or models. Every placement endpoint (portal sites,
  and later placed items) checks the parcel.
* When a lease lapses after the grace period, the exclusive right ends. The
  structures remain as **ruins** that other players can mine with a pickaxe, the
  same mechanism as for the ruins of closed portals. Nothing is destroyed
  at once and the record of the materials is kept.
* **Property claims.** A structure can only be taken or mined by others when its
  owner is dead (permanent death) **and** it does not stand on leased land, or
  when it is a ruin of a lapsed lease or a closed portal.

Payments
~~~~~~~~

* The server never handles card data. It creates an **order** and sends the
  player to the gateway's hosted checkout; the gateway calls back a **webhook**.
* An order has a kind (``lease_month``, ``model_placement``, ``avatar``), an
  amount in minor units and a currency, and a status (``created``, ``pending``,
  ``paid``, ``failed``, ``refunded``). The webhook is verified (signature),
  idempotent (unique provider reference) and applies the **entitlement in the
  same transaction** as marking the order paid.
* The gateway is behind an interface so that more providers can be added. A
  manual provider (the operator confirms a payment) is used for tests and
  small installations. Credentials are read from the environment or a secret
  file, never from the repository, and are never logged.
* The feature is **off by default** (``[monetization] enabled = false``).

Imported models and avatars
~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Imported models are **data only** (glTF/GLB, no code, no scripts), content
  addressed by hash, limited in file size, triangle count, texture size, bounds
  and number of materials, converted and re-exported by the server, and kept
  invisible to others until they pass the checks. Placement on land is
  server-authoritative like every other placement.
* A custom avatar is a model of the same kind, selected once when the
  character is created and paid for then. It is shown to others in place of the
  standard characters only after the checks and the moderation decision.
* Content moderation (copyright, offensive content) is a duty of the operator;
  the server provides an approval queue and a way to remove a model.

Consequences
------------

* Money buys **space and appearance**, not power: no gameplay advantage beyond
  exclusive use of a parcel. Operators remain responsible for consumer law, VAT,
  refunds and data protection in their country.
* Federation: items and avatars carried through a portal are referenced by
  hash and URL; the receiving world applies its own checks and moderation before
  showing a foreign model. Leases and orders never leave the world.
* Dead owners: property on leased land stays protected until the lease lapses.
  Unleased property of a dead owner can be taken, which makes the permanent
  death rule meaningful for property.
