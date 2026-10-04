Client
======

The client (``ishtaria-client``, MIT) is a Godot 4 project exported for
Linux x86-64 and packaged as a ``.deb``.

Large coordinates
-----------------

At planetary distances single-precision floats jitter by metres. The client
uses a **double-precision** Godot build and a **floating origin**: the scene
origin moves with the player.

Terrain
-------

* Cube-sphere with a quadtree per face for level of detail.
* Base terrain is generated locally from the world seed by the same
  algorithm as ``ishtaria-worldgen`` (via GDExtension), so it never
  travels over the network.
* Server sends only deltas for visible cells.
* Local modifications (digging, building) use a voxel/SDF layer on top.

Avatar
------

Avatars are VRM 1.0 files. Base meshes and morph targets can be derived
from MakeHuman/MPFB2 assets (CC0). Custom avatars are content-addressed by
their SHA-256 so federated worlds can cache them.

Prediction
----------

Movement and crafting rules come from ``ishtaria-core`` compiled into the
client, so local prediction matches the server.
