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

Moderation
----------

Bans are local. Worlds may share block lists, Fediverse-style. An agreement
may state content rules (PvP, age rating).

Chat
----

Cross-world chat, guilds and groups use **Matrix**; Ishtaria does not
reimplement messaging.
