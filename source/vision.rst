Vision
======

What Ishtaria is
----------------

* **One planet per world, Earth-sized.** About 510 million km² of surface,
  generated procedurally from a seed. Only changes are stored.
* **Comparable physics and ecosystem.** Rigid-body physics near players,
  population dynamics of plants and animals everywhere else.
* **Persistent time.** The world does not pause when a player leaves.
  Crops grow, animals migrate, a sleeping avatar gets hungry.
* **Start from nothing.** No towns, no shops, no money supply. Economy
  emerges from gathering, crafting and trade between players.
* **Decentralised.** Any operator can run a world. Worlds federate through
  bilateral agreements and in-game portals.
* **Open source, Linux first.** Everything is distributed as Debian packages.

What Ishtaria is not
--------------------

* Not a single centrally owned universe.
* Not a blockchain project. Trust between worlds comes from signed
  messages and explicit agreements between operators, not from a ledger
  everybody must share.
* Not a scripted theme park. Content is mostly systemic: rules, recipes,
  species, biomes.

Design principles
-----------------

#. **Simulate where someone looks.** Full fidelity is spent only where it is
   observed; elsewhere the world advances by cheaper aggregate models that
   stay consistent when observed again.
#. **Never trust a peer blindly.** Every federated exchange is signed,
   bounded by the local import policy and reversible on defederation.
#. **Small, shippable steps.** Each roadmap milestone is usable on its own.
#. **Open standards.** glTF/VRM for avatars, H3 for spatial cells,
   CBOR/COSE for signed data, Matrix for chat.

Platforms
---------

Ishtaria targets **Debian and Ubuntu on x86-64**. All components – server,
client, generator, content and this documentation – are shipped as
``.deb`` packages. Windows and macOS builds are not planned.
