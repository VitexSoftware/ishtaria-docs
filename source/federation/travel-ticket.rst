Travel ticket and handover
==========================

A travel ticket carries a player through a portal. It is CBOR data in a
COSE_Sign1 envelope (RFC 9052), signed by the issuing world. The normative
CDDL is ``schemas/travel-ticket.cddl`` in ``ishtaria-protocol``.

Properties: valid for at most **300 seconds**, **single use** (nonce),
lists the avatar by content hash and every carried item with provenance.

Contents
--------

.. code-block:: json

   {
     "v": 1,
     "id": "0192f3a1-…",
     "player": "@vitex:svet-a.example.org",
     "from": "svet-a.example.org",
     "to": "svet-b.example.org",
     "portal": "brana-sever",
     "issued": 1791135540,
     "expires": 1791135840,
     "avatar": { "vrm": "sha256:9f2c…", "url": "https://svet-a…/assets/9f2c…" },
     "skills": { "woodcutting": 34, "smithing": 12 },
     "items": [
       { "id": "svet-a.example.org/0192…", "kind": "core:iron_axe",
         "category": "tool", "durability": 0.82,
         "provenance": ["<signature>"] }
     ],
     "nonce": "…"
   }

Two-phase handover
------------------

.. graphviz::

   digraph handover {
     rankdir=LR; node [shape=box, style=rounded, fontname="sans-serif"];
     a1 [label="A: lock avatar\n+ items (in transit)"];
     a2 [label="A: issue\nsigned ticket"];
     c  [label="Client:\nreconnect to B"];
     b1 [label="B: verify,\napply import policy"];
     b2 [label="B: spawn at portal,\nconfirm to A"];
     a3 [label="A: release lock"];
     to [label="Timeout:\nA cancels lock,\nplayer stays home", style="rounded,dashed"];
     a1 -> a2 -> c -> b1 -> b2 -> a3;
     a2 -> to [style=dashed];
   }

This prevents both duplication and loss of items when either world fails
mid-way.

Guests and offline players
--------------------------

* The **home server** keeps the master record with state
  *travelling in B*.
* The **host** keeps the guest state: position, current inventory, health.
  Time runs for guests as for locals.
* Returning reverses the flow; the home server merges the result under its
  own import rules.
* **Shipwreck:** if B disappears, defederates or stays unreachable beyond
  ``grace_period``, the home server recovers the player with what they
  carried out, possibly with a penalty. A server outage becomes an in-game
  event instead of a lost character.
