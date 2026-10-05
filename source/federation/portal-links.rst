Portals and share links
=======================

A portal is built alone and linked with a portal of another world by a share link.
Decision: :doc:`../decisions/0009-portal-share-links`. Message formats are defined in
``ishtaria-protocol``: ``server-info``, ``portal-link``, ``portal-link-request`` and
``portal-unlink``.

Building a portal
-----------------

1. ``POST /portals/build`` (``{"portal_name": "brana-sever"}``) places the construction site
   where the player stands, on dry land and at least 20 m from other portals; the name must
   be free in the world. A player may have five open portals. Rented land needs the lease
   (see :doc:`../decisions/0006-monetization`).
2. ``POST /portals/mine/{id}/contribute`` (``{"item_id": …, "quantity": "…"}``) delivers
   materials from the inventory to the site, within 6 m. The requirements are in
   ``etc/portal.json``: by default 10 stone blocks, 20 planks of any wood and 2 quartz
   crystals. A delivery never exceeds what is still needed.
3. When everything is delivered the portal is **built** (state ``built``): finished and not
   yet linked.

``GET /portals/mine`` lists the player's portals, ``GET /portals/mine/{id}`` shows the
progress, ``GET /world/portals?x&y&z`` lists the portals near a point for rendering.
States: ``building``, ``built``, ``pending`` (linked, waiting for the operator), ``open``
and ``closed``.

Linking
-------

A finished portal offers two things:

* ``GET /portals/mine/{id}/link`` returns the **share link**
  ``ishtaria-portal:v1.<payload>.<signature>``, signed with the world's key.
* ``POST /portals/mine/{id}/connect`` (``{"link": …}``) takes the link of a portal of
  another world. The server then:

  1. verifies the signature against the key the other world publishes at
     ``/.well-known/ishtaria/server.json`` (pinned on first use);
  2. asks ``GET /federation/portals/{id}`` of the other world whether it is reachable and the
     portal stands there and is ``built``;
  3. sends a signed ``portal-link-request`` to ``POST /federation/portals/link``; the other
     world checks the signature, fetches the same information about the requesting portal,
     applies its own operator policy and links its end;
  4. links its own end and, when its policy is ``open`` and the other end opened, opens it.

A portal has exactly one counterpart: a linked portal gives no link and accepts none.

Breaking the link
-----------------

``DELETE /portals/mine/{id}/link`` (the owner, from either end) breaks the link: the portal is
``built`` again and may be linked anew. The other world is told with a signed
``portal-unlink`` message (``POST /federation/portals/unlink``); one that cannot be delivered
is repeated every 30 seconds. ``DELETE /portals/mine/{id}`` closes a portal (a ruin stays,
with the record of the delivered materials) and breaks its link as well.

Operator configuration
----------------------

.. code-block:: toml

   public_url = "https://ishtaria.example.org:7400"
   [federation]
   policy = "approve"          # closed | approve | open
   allow_private_peers = false # true only for development networks

Without ``public_url`` a world gives no share links. A world generates its Ed25519 signing key
on first start and stores it in the database (``federation_settings``). A link that waits for the
operator (``pending``) is shown in ``ishtaria-admin`` (F4, *Linked worlds*): **Open** approves it,
**Close** breaks it and the other world is told. A peer can be banned with SQL:

.. code-block:: sql

   UPDATE federation_peers SET state = 'banned' WHERE host = 'bad.example.org';

Limits and safety
-----------------

* Links are limited to 2 KiB, server-to-server messages to 4 KiB.
* Signatures are domain separated; a signature for a link is not valid as a request.
* Outbound requests to peers use public addresses only (checked on the address actually
  connected), do not follow redirects and time out after five seconds.
* A world name must be the host of the URL its key is fetched from (checked unless
  ``allow_private_peers`` is set), so a server cannot claim to be another world. A
  first-contact key is pinned only after a message signed with it has verified; a peer whose
  key changed after pinning is refused.

In the client
-------------

The ``P`` key opens the portal panel: it builds a portal where the player stands, delivers
materials (the button offers what the player holds, never more than still needed) and, for a
finished portal, offers **Copy share link** and a field to paste another portal's link with a
**Connect** button. A linked portal shows its counterpart and a **Break the link** button.
Portals are drawn in the world with the gate model of the Kenney Survival Kit: plain metal
while under construction or unlinked, glowing when open, dark when closed.

Not yet implemented
-------------------

Mining the ruins of a closed
portal, the portal toll, travel tickets, direct or proxied play in the hosting world, and
client-relayed contact between worlds that cannot reach each other.
