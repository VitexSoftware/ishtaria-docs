0011 – Sharing achievements and memorials on social networks
============================================================

:Status: Proposed (planned in four steps; nothing implemented yet)
:Date: 2026-10-07

Context
-------

Players like to show what they did: a first spell, a harvested pumpkin as big as a house, a
character who lived for a month, a grave that people visit. That is also how a game becomes known.
The project owner wants sharing to be **easy for players and good for the visibility of the game**,
without making the game collect accounts, track visitors or depend on the rules of a platform.

The rules of the project (:doc:`../development/invariants`) set the frame: the server decides what a
character achieved, it stores no language, secrets stay out of logs, content is data, and the
memorial of a dead character is public and immutable by design.

Decision
--------

**1. Achievements are data and are decided by the server.**
``etc/achievements.json`` lists them: an id, a name and description (translatable keys), a badge
image and one **condition from a fixed set** that the server implements (a level reached, a spell
learned, an item crafted or harvested for the first time or N times, days lived, gold in a lifetime,
a portal linked, a creature hunted). The server evaluates them in the transaction of the action that
can earn them and stores ``player_achievements (player_id, achievement_id, earned_at)``. They are
never granted by a client and never removed: when a character dies, the achievements go with the
memorial.

**2. Sharing is an action of the player, never of the game.** The client shows a toast when an
achievement is earned and a **Share** button there, in the achievements window and on a memorial.
The button offers: *copy link*, *post on Mastodon / Bluesky / X / Reddit* (the platform's own "compose"
address opened in the browser with text and link filled in) and *save a picture* (a screenshot of the game
with the emblem). The game posts nothing by itself and **holds no token of any social network**. The
Mastodon instance a player uses is a local client preference, like the language.

**3. A share link is a public page that the server renders.** ``POST /players/me/share`` (an
achievement or the memorial of the character) returns ``<public_url>/share/<token>``. The token is
random, 128 bits, stored hashed, and **revocable** (``DELETE``); the player chooses *link only* or *listed*
(listed pages may be indexed and appear on the web portal). The page is small HTML with no script, no
third-party font or tracker, and with Open Graph and Twitter Card tags (title, description, a **bundled badge
picture** per achievement, the world emblem) so that a post shows a card. It shows only the nickname,
the achievement, the date, the world name and, if the player chose it, the flag. Texts are chosen by the
``Accept-Language`` of the request and are not stored. Everything shown is escaped; there is no
user-written HTML.

**4. The world can tell its own story (optional, operator side).** An operator may configure a
*chronicle*: a Mastodon account whose token is read from the environment (never from the configuration
file or the database) that posts events of the world: a new world, the first link of a portal, the
characters who entered the hall of fame, the death of a long-lived character. Only characters who allowed
a listed page are named.

Steps
-----

#. **Achievements and the Share button** (server data and evaluation; client toast and window; copy link and
   the platform "compose" addresses; share page with cards). The smallest step that makes a post possible.
#. **Memorials and the hall of fame** as share pages, and a **showcase on the web portal**
   (``ishtaria-web``): the listed pages of the worlds that opt in, so that a visitor sees the game in use.
#. **The chronicle bot** for operators, and an RSS/Atom feed of listed events.
#. **Creator tools**: a photo mode of the client (no HUD, free camera), a press kit in the repository
   (logo, screenshots, short text, licences) and a gallery of community datadisks and what players built.

Alternatives considered
-----------------------

* *Posting on behalf of players through OAuth.* Rejected: the server would store tokens of other
  services, depend on their changing interfaces and prices, and be responsible for what is posted.
* *Embedded sharing buttons or SDKs of the platforms.* Rejected: they track visitors.
* *Pictures with the player's name rendered on the server.* Postponed: it needs fonts and a text renderer;
  bundled badges with text in the card tags give most of the effect now.

Consequences
------------

* Public pages are a new attack surface: they are rate limited (:doc:`../operations/hardening`), cached,
  built without scripts, and tested with hostile nicknames. Removing a link removes the page at once.
* Personal data is minimal and under the control of the player: a nickname they chose, no account id, no
  email, no tracking. Revoking the link is the way to be forgotten (the memorial of a dead character remains,
  as already decided in the persistence documents).
* Visibility is measured without watching people: the server counts views of share pages as a total
  in ``/metrics``, and the operator can compare it with the downloads of the packages.
* Sharing costs the project nothing when nobody uses it, and its first step is small enough to be built by a
  contributor with Claude Code from the :doc:`../development/cookbook` (a data file, a migration, an endpoint,
  a client window, tests).
