0009 – Portals are built alone and linked by a share link
=========================================================

:Status: Accepted and implemented; supersedes :doc:`0005-portal-invitations`
:Date: 2026-10-06

Context
-------

Linking two worlds began with a signed invitation from one player to another and a
pact that both players then built together. The project owner decided on a simpler
model: a portal is built on its own, and only a **finished** portal can be linked.

Decision
--------

* A player builds a portal alone: a construction site where they stand, and the materials
  of ``etc/portal.json`` delivered to it. No invitation, pact or peer is needed.
* A finished portal offers two functions: **copy its share link**, and **paste the share
  link of another world's portal**.
* When a link is pasted, the player's server first checks that the other world is
  reachable, that the link is signed by that world's published key, and that the offered
  portal stands there and is finished. Only then does it ask the other world to link its end
  (a signed request that the other world checks in turn) and activate both ends.
* The operator policy still applies: ``closed`` refuses links, ``approve`` leaves the link
  *pending* until the operator approves it, ``open`` opens it at once.
* A portal has **exactly one counterpart**. A linked portal neither offers a link nor accepts
  one. The owner of either end can **break the link**; both portals are then finished and
  unlinked again and can be linked anew. Closing a portal breaks its link and leaves a ruin.
* A broken link is reported to the other world with a signed message that is repeated until
  delivered. Only the world a portal is linked with can release it.

Consequences
------------

* A share link can be sent through any channel and carries no secret; it only names a
  portal and is signed by its world. Whoever holds it can try to link, but the other
  world's checks and policy decide.
* Invitation codes, pact acceptance and joint building were removed; their message formats
  in ``ishtaria-protocol`` were replaced by ``portal-link``, ``portal-link-request`` and
  ``portal-unlink``.
* Travel through a linked portal (tickets, tolls) is still planned.
