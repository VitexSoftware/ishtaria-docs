Federation model
================

Ishtaria worlds are run independently. Two worlds can be linked when their
operators agree.

Separate planets, linked by portals
-----------------------------------

Each world has its **own planet**. Worlds are connected by **portals**:
crossing one is a discrete event, not a seamless border. This avoids the
hardest problems of shared territory – real-time synchronisation across
servers, deciding authority over objects on a border, and behaviour when one
side goes down. See :doc:`../decisions/0001-separate-planets-portals`.

Portals as gameplay
-------------------

* An agreement between operators **permits** a portal.
* Players must **build** it: materials, energy, technology.
* Each end is placed by its own world's operator.
* State: ``building`` → ``open`` → ``congested`` / ``closed``; parameters
  are capacity per hour, cargo limit and optional opening windows.

Trust
-----

A world can never assume that a peer runs unmodified software. Therefore:

* every message between worlds is signed with the server's Ed25519 key;
* everything a peer sends passes the local **import policy**;
* every item carries **provenance** – the world that minted it vouches
  for it;
* every agreement defines what happens on **termination**.

Identity
--------

Players are ``@localpart:home.server`` (as in Matrix). The home server keeps
the master record. Each world runs its own identity provider (e.g. Keycloak
over OIDC); there is no central account system.

Discovery
---------

A world publishes its signing key and endpoints at
``https://<server>/.well-known/ishtaria/server.json``. Keys are additionally
verified out of band by operators when they sign an agreement.

Players learn that other worlds exist in three ways, none of them a central
registry:

* from the **player who invites them** to build a portal
  (:doc:`portal-pacts`);
* from a **portal** their world has opened;
* from an **obituary**: when a guest dies in a world that is not their home,
  the obituary names the home world (see :doc:`travel-ticket`). The client
  can add it to the player's server history. This is only a suggestion; a
  world becomes trusted through a pact and a pinned key, never through an
  obituary.

Moderation
----------

Bans are local. Worlds may share block lists, Fediverse-style. An agreement
may state content rules (PvP, age rating).

Chat
----

Players send each other text messages in the game, also across worlds, through
signed messages between their worlds. A server relays a message and does not
keep it: the history of a chat is stored only in the client
(:doc:`../decisions/0007-chat-and-friends`). Guilds and groups may use
**Matrix**.
