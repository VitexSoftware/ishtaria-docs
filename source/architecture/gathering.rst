Gathering and crafting
======================

Trees and rocks of the generated world can be harvested. The outcome is decided
by the server: it regenerates the object a player names, checks reach, stamina
and a short cooldown between swings, and applies the result in one transaction.

Tools
-----

Axe, pickaxe and sword are inventory items (stack of five per slot). Every new
character starts with all three; characters created earlier received them with
migration ``0016_gathering.sql``. Only the tool **in hand** works: the inventory offers *Equip* for tools and weapons
(``POST /players/me/equip``; new characters hold the axe). The axe fells trees, the
pickaxe mines stone and also fells trees, but needs **twice as many swings**; the
axe does not work on stone, a sword in hand works on nothing. A swing is worth work
points (axe on a tree two, pickaxe one), so swings with different tools add up. The
equipment is cleared at death. The
sword is for defence once combat exists.

Resources
---------

``etc/resources.json`` maps object models to resources:

* **Trees** by species: pine, palm, oak and birch trees give pine, palm, oak and
  birch **logs**. Each felling may also drop food of that species (pine nuts,
  coconuts, acorns, pears or apples).
* **Rocks** give stone. Larger rocks give more and have a better chance of a
  rare mineral: iron ore, copper ore or quartz crystal.
* A harvested object is stored as a change of the generated world
  (``world_object_state``). A felled tree leaves a **stump** that can be walked
  over; a mined rock disappears. Both grow back after a configured time.
* Several hits are needed per object. Hits are forgotten after ten minutes.

Logs and wood
-------------

A log fills **ten inventory slots**. It must be chopped with an axe
(``chop_*_log``, 1 log into 20 pieces of wood); wood stacks to 100 per slot.
Planks are made from wood, stone blocks from stone (``GET /recipes``,
``POST /players/me/craft``).

API
---

``POST /players/me/harvest`` with ``{"object_id": …}`` returns the state of the
object (``hit`` or ``depleted``), the items gained and the updated player.
A full inventory refuses the final hit and leaves the object standing.

Client
------

The ``E`` key harvests the nearest tree or rock within reach (a prompt names the
action); the inventory panel (``I``) lists the recipes and crafts them. Item
icons are rendered from the Kenney Survival Kit models by
``tools/bake-item-icons.gd``; items without a model (coins, sword) show text only.

RPG items
---------

The 55 models of the Quaternius *Ultimate RPG Items Bundle* (CC0) are items of
the catalog (migration ``0017_item_catalog.sql``): weapons, armour, shields,
potions, keys, books, valuables and remains. They have names, categories and
icons; they have **no statistics yet** and no way to be obtained until combat,
smithing and loot exist. Items with a ``multi_slot`` stack (weapons, armour)
fill one slot each.

Animals and fish
----------------

Animals and fish are a separate layer of the generated world (``etc/world_fauna.json``)
with their own grid and identifiers, so adding them did not move any tree or rock.
Land animals (12 species of the Quaternius Animated Animal Pack) stand in the
grassland, forest, mountain and snow biomes that suit them. Fish (35 species of the
Animated Fish Bundle) swim below the surface of oceans, lakes and rivers where the
water is at least three metres deep; freshwater fish stay in lakes and rivers.
They are scenery for now: they do not collide, move on the server or react, and
cannot be harvested. The client plays their idle or swimming animation, each at its
own moment, and lets fish circle around their place.

A whole animal can be carried as an item (migration ``0018_animal_items.sql``). It
fills as many inventory slots as its size suggests: a fox four, a wolf eight, a
horse twenty, a bull twenty-five; a fish one to eight. There is no hunting or
fishing yet, so the items cannot be obtained.

Planned
-------

Survival Kit items (logs, stumps, tools, campfire, bed, anvil and others) can be
carried and **placed in the world** for later use; a closed portal can be mined
for its materials with a pickaxe. Neither is implemented yet.
