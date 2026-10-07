Project rules that never change
================================

These rules hold in every repository and for every change, whoever writes it: a person,
Claude Code or another assistant. A change that breaks one of them is rejected, however
well it works. If you believe a rule is wrong, open a decision record
(:doc:`../decisions/index`) instead of working around it.

Authority and trust
-------------------

* **The server decides.** Clients send intentions (``move``, ``cast``, ``buy``), never results.
  A client may not set gold, items, damage, positions, cooldowns or permissions, and the server
  must not accept a value from the client that it can compute itself.
* **Every answer of a server is untrusted input for the client.** The Godot client validates the
  shape, type and range of every reply (``valid_*`` functions) and skips what does not fit; it
  never shows server text as a message but maps refusals to fixed, translated message keys.
* **Every request is validated by the server.** Bound sizes and counts, parse numbers strictly,
  use parameterised SQL, and return a controlled error that never contains SQL, paths or
  secrets.
* **Related writes happen in one transaction** with the character's row locked
  (``survival::lock_alive``). Economy changes are atomic under concurrent requests: check
  ownership, non-negative balances and overflow, and make a repeated request harmless.

Persistence
-----------

* **Migrations are append-only.** Add a new numbered file in ``ishtaria-server/migrations``;
  never edit one that has been released. Test that the server starts on an existing database.
* **Terrain is generated; only changes are stored** (harvested trees, placed things, graves).
  Never replace the generated planet with a stored dump.
* **A world's identity and ruleset are persisted contracts.** Do not silently replace
  an imported world.
* **Never run destructive commands against a live database.** Tests use isolated databases
  that SQLx creates.

Game rules owned by the project
-------------------------------

* A new character gets **100 gold coins exactly once**, when the player record is created. Login,
  reconnect, restart and profile refresh never grant it again. Gold is an inventory item.
* **Death is permanent.** A dead character is never restored; a new one has a new identity.
  Graves and obituaries are immutable.
* **Money buys space and appearance, not power.** Nothing that real money pays for may change
  combat, magic, gathering or crafting results.
* **Language is a client preference.** The server may receive the language of a request (a
  ``lang`` parameter) to choose a spoken line, but never stores it in a player, account or
  database. A flag next to a name is a picture, not a language.
* **Chat is relayed and forgotten.** Servers keep no message history beyond a short mailbox.
* **Content is data.** Items, recipes, spells, shops and datadisks carry no scripts and no
  executable code. A new *kind* of effect is code and needs review; a new instance is data.
* **Federation is bilateral and signed.** Treat tickets, agreements and peers as security
  boundaries and validate signature, expiry, audience and replay.

Security and secrets
--------------------

* Passwords use Argon2id; session tokens are random, expiring, revocable and stored hashed.
* Never log passwords, tokens or connection secrets. Never commit them, put them in examples,
  screenshots or ``user://client.cfg``.
* CORS is not authentication. Account endpoints need TLS and deployment-level rate limiting
  before they are exposed publicly.

Assets and licences
-------------------

* Use the approved asset sources of the client README (Kenney, Quaternius) first. A model or a
  picture that is generated for the project (Blender, InvokeAI) is allowed, and its origin and
  licence are recorded in the client README.
* Keep original licence notices under ``assets/``, update the README credits and the Debian
  copyright file for every new bundled file. Download from the original source and bundle only
  what is used.
* Licences: server AGPL-3.0-only; core, client, worldgen and protocol MIT; content and
  documentation CC BY-SA 4.0 (:doc:`../decisions/0004-licensing`).
* Supported platform: Debian and Ubuntu on x86-64, packaged as ``.deb``.

Honest reporting
----------------

* Say what is implemented and tested, what is planned, and what is blocked. A headless run is
  not visual verification; a proposal is not a feature.
* Do not weaken a failing check to make it pass. Fix the cause or report it.
* Do not invent a player, a balance or terrain to hide a missing backend.
