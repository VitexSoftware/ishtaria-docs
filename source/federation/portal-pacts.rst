Portal invitations and pacts
============================

A portal between two worlds begins with a **pact** between two players.
Decision: :doc:`../decisions/0005-portal-invitations`. Message formats are
defined in ``ishtaria-protocol``: ``server-info``, ``portal-invitation`` and
``portal-pact-accept``.

Flow
----

1. The inviter asks their server for an invitation
   (``POST /portals/invitations`` with ``{"portal_name": "brana-sever"}``).
   The server returns a code ``ishtaria-invite:v1.<payload>.<signature>``.
   It is valid for 7 days and usable once. A player may hold three open
   invitations; the portal name is reserved while the invitation is open.
   ``DELETE /portals/invitations/{id}`` revokes it.
2. The invited player enters the code in the client, which sends it to its
   own server (``POST /portals/pacts`` with ``{"code": …, "portal_name": …}``;
   ``portal_name`` names the invited world's end).
3. The invited world fetches ``/.well-known/ishtaria/server.json`` of the
   inviting world, pins its key on first use, verifies the signature and sends
   a signed acceptance to ``POST /federation/pacts``.
4. The inviting world checks signature, expiry, revocation and quotas, marks
   the invitation as used and records its own copy of the pact. Repeating the
   same acceptance is idempotent.
5. Both worlds list the pact (``GET /portals/pacts``). Its state is
   ``accepted`` when the operator policy is ``open`` and ``proposed``
   otherwise.

Operator configuration
----------------------

.. code-block:: toml

   public_url = "https://ishtaria.example.org:7400"
   [federation]
   policy = "approve"          # closed | approve | open
   allow_private_peers = false # true only for development networks

Without ``public_url`` a world does not federate. A world generates its
Ed25519 signing key on first start and stores it in the database
(``federation_settings``); protect and back up the database accordingly.
Until the administration tool supports it, approve or refuse a pact with SQL:

.. code-block:: sql

   UPDATE portal_pacts SET state = 'accepted', updated_at = now() WHERE id = '…';
   UPDATE federation_peers SET state = 'banned' WHERE host = 'bad.example.org';

Limits and safety
-----------------

* A player may hold five active pacts.
* Codes are limited to 2 KiB, acceptance messages to 4 KiB.
* Signatures are domain separated; a signature for an invitation is not valid
  as an acceptance.
* Outbound requests to peers use public addresses only (checked on the
  address actually connected), do not follow redirects and time out after
  five seconds.
* A world name must be the host of the URL its key is fetched from (checked
  unless ``allow_private_peers`` is set), so a server cannot claim to be another
  world. A first-contact key is pinned only after a message signed with it has
  verified.
* A peer whose key changed after pinning is refused.

Building the portal
-------------------

Once the operator has accepted a pact (``accepted``), each player builds their
**own end** in their own world:

1. ``POST /portals/pacts/{id}/site`` places the construction site where the
   player stands, on dry land and at least 20 m from other portals. The pact
   becomes ``building`` and a ``portals`` row (``building``) is created.
2. ``POST /portals/pacts/{id}/contribute`` (``{"item_id": …, "quantity": "…"}``)
   delivers materials from the inventory to the site, within 6 m. The
   requirements are in ``etc/portal.json``: by default 10 stone blocks, 20
   planks of any wood and 2 quartz crystals. A delivery never exceeds what is
   still needed.
3. When all requirements of an end are delivered, that end is **built** and the
   other world is told with a signed ``portal-pact-status`` message
   (``POST /federation/pacts/status``). A message that cannot be delivered
   is repeated every 30 seconds until the peer receives it; repeating it changes
   nothing.
4. When both ends are built, the pact and both portals become ``open``.

``GET /portals/pacts/{id}`` shows the progress, ``GET /world/portals?x&y&z`` lists
the portals near a point for rendering.

In the client
-------------

The ``P`` key opens the portal panel: it creates an invitation (the code can be
copied and sent to another player), accepts an invitation with the name of the
player's own end, lists the pacts with their state, places the construction site
where the player stands, delivers materials (the button offers what the player
holds, never more than still needed) and cancels a pact. Portals are drawn in
the world with the gate model of the Kenney Survival Kit: plain metal while
under construction, glowing when open, dark when closed.

Rented land
-----------

A portal site cannot be placed on land that another player rents (see
:doc:`../decisions/0006-monetization`); an unpaid lease keeps its exclusive
right through the grace period and then lapses.

Cancelling a pact
-----------------

``DELETE /portals/pacts/{id}`` (by either player) closes the pact and tells the
other world. The portals at both worlds become ``closed`` ruins; the record of
the delivered materials is kept (``portal_contributions``) for mining the ruins.

When a pact is cancelled (by either player, by an operator, or because the
agreement ends), the portals at both worlds become **inactive** and stay in
the world as ruins. The materials invested in them can be **mined out with a
pickaxe** like other resources, so the effort of the builders is not lost and
a ruin is not a permanent obstacle. The share of the materials returned and
who may mine a ruin are set by the world's rules (planned).

Not yet implemented
-------------------

Operator
approval in ``ishtaria-admin``, mining the ruins of a closed portal, the portal toll (2 coins), travel tickets, direct or proxied play in the
hosting world, and client-relayed delivery between worlds that cannot reach
each other.
