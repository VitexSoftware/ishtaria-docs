0005 – Portal pacts start with a player invitation
==================================================

:Status: Accepted (invitation and pact exchange implemented; building, tickets and travel planned)
:Date: 2026-10-05

Context
-------

A portal needs a way to be started and a way for a player to learn that
another world exists. Operator-only creation hides worlds from players;
central directories contradict :doc:`0001-separate-planets-portals`. Servers
may run in private networks and cannot be assumed to reach each other.

Decision
--------

* A player of world A **invites** a player of world B. The invitation is a
  signed, single-use code shared out of band (chat, e-mail, Matrix). It is
  also how the invited player learns that world A exists.
* The invited player's client hands the code to **its own** server. That
  server verifies it against world A's key, pins the key on first contact and
  sends a signed acceptance to world A. Credentials never leave the home
  world.
* Both worlds keep their own copy of the pact. The operator policy
  (``closed``, ``approve`` – the default – or ``open``) decides whether a pact
  waits for approval. Operators can always refuse or ban a peer.
* The portal is then built jointly: each side builds its own end, and it
  opens only when both ends are complete (planned).
* A finished portal is usable by all players of the world (planned).
* After crossing, the home world records where the player is. On the next
  login the client tries the hosting world directly; if it is unreachable
  from the client, the home world acts as proxy. Where the worlds cannot
  reach each other, signed messages travel store-and-forward through the
  client (planned).

Consequences
------------

* No central registry and no unsolicited connections: contact between worlds
  exists only because two players and two operators agreed.
* Keys are pinned on first contact (trust on first use); a changed key is
  refused. Operators should compare fingerprints out of band.
* Fetching a peer's key is an outbound request caused by a player. It is
  limited to public addresses, without redirects, with small bodies and
  timeouts; private networks require an explicit operator setting.
* The acceptance message needs the invited world to reach the inviting world
  at least once. Fully unreachable pairs would need the planned
  client-relayed delivery.
