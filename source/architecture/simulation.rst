Simulation and persistent time
==============================

A full-fidelity simulation of an Earth-sized planet is impossible. Ishtaria
spends detail only where it is observed.

Levels of detail
----------------

.. list-table::
   :header-rows: 1

   * - Level
     - Where
     - What is simulated
   * - L0 – active
     - around players
     - individual animals and plants, rigid-body physics, 20–60 Hz
   * - L1 – near
     - surroundings
     - individual entities, simplified behaviour, no physics
   * - L2 – aggregate
     - everywhere else
     - per-cell populations (predator–prey, vegetation growth), weather,
       seasons; steps of minutes to hours

Catch-up
--------

When a player enters an L2 cell, the server **materialises** concrete
individuals from the aggregate state and a deterministic seed. To an
observer the result is indistinguishable from continuous simulation, at a
fraction of the cost.

Offline players
---------------

Time runs while players are away.

* The avatar stays in the world, asleep, and keeps its needs (hunger,
  warmth).
* Shelters protect sleeping avatars; designing them well is essential,
  otherwise logging out becomes punishing.
* Property – fields, animals, workshops – continues at L2 fidelity.

.. todo:: Decide penalties and protections for avatars sleeping outdoors.
