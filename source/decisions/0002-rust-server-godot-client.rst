0002 – Rust server and core, Godot client
=========================================

:Status: Accepted
:Date: 2026-10-04

Context
-------

The server must simulate many entities safely and fast. Client prediction
must agree with server rules.

Decision
--------

Server and shared core in **Rust**; the core is linked into the
**Godot 4** client through GDExtension (``godot-rust``).

Consequences
------------

* One implementation of rules, no divergence between client and server.
* Contributors need Rust for core work; client UI work stays in GDScript.
* Bevy was considered for the client; rejected for now because it lacks an
  editor and its API still changes often.
