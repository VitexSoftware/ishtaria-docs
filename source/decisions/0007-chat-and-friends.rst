0007 – Text chat and friends
============================

:Status: Accepted requirements, design proposed (nothing implemented)
:Date: 2026-10-05

Context
-------

Players need to talk to each other. The federation documentation said that
cross-world chat uses Matrix and that Ishtaria does not implement messaging. The
project owner decided otherwise: players send each other **text messages in the
game**, and the **history of chats is kept only in the client**, because keeping
it on servers would raise storage needs without limit over time. Each player has
a **list of friends**; a friend is shown with their **name** and the **world on
which they currently are**. This is one more way to discover new worlds.

This replaces the Matrix statement for player-to-player messages. Matrix remains a
possible choice for guilds and groups, but is not required.

Decision
--------

* **No chat history on servers.** A server relays a message to the recipient and
  forgets it. The client stores the conversation locally (its own file, per
  player) and may delete it at any time.
* **Delivery.** Online recipients receive the message at once (long polling or an
  event stream on the connection they already have). A recipient who is offline
  gets the message from a small **mailbox with a short lifetime** (for example
  seven days and at most 100 messages per recipient). A delivered or expired
  message is deleted. The mailbox is delivery state, not history.
* **Limits.** Messages are plain text of at most 500 characters; senders are
  rate limited; players can block other players; messages from non-friends go to
  a request list rather than straight to the conversation.
* **Friends.** A friendship is mutual: one player sends a request, the other
  accepts. A friend entry shows the friend's name and the **world they are
  currently in** (the world name, and its public address when the friend's
  world publishes one). A player can hide their location from friends ("appear
  offline").
* **Across worlds.** Friends can live in different worlds. Their worlds exchange
  signed messages with the peer keys of :doc:`0005-portal-invitations`
  (presence queries and message relay), so no central service exists. A friend
  who is travelling shows the world they are in, as recorded by the home world.
* **Discovery.** The world shown next to a friend can be added by the client to
  the server history (``source: friend``). It is only a suggestion: trust
  comes from pacts and pinned keys, as for obituaries.

Consequences
------------

* The cost of chat on a server is bounded: a relay and a small mailbox.
* A server can read the messages it relays (they are not end-to-end encrypted);
  this must be stated in the privacy information. End-to-end encryption between
  clients is possible later.
* Losing the client file loses the history; there is no recovery from the server.
* Presence reveals where a player is; the friend list and the "appear offline"
  option are therefore consent based.
