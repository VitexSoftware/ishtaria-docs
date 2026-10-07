Local development setup
=======================

This page gets a private world running on your own machine in a few minutes, with a
throw-away database, so that you can try a change without touching any real data.

Prerequisites
-------------

* Debian or Ubuntu on x86-64 (the only supported platform).
* Rust (stable), PostgreSQL with a role that may create databases, Python 3 with ``PyYAML`` and
  ``jsonschema``, and for the client Godot 4.5 (``godot4``) with the matching Linux export
  templates when you build packages.
* The workspace is **several repositories side by side**, not one Cargo workspace:

  .. code-block:: text

     Ishtaria/
       ishtaria-server/   ishtaria-client/   ishtaria-worldgen/
       ishtaria-core/     ishtaria-content/  ishtaria-protocol/   ishtaria-docs/

  Run Git, Cargo and ``make`` inside the repository you are changing.

A private server
----------------

.. code-block:: sh

   createdb ishtaria_dev                    # a database of your own, never the live one
   cd ishtaria-server
   cat > /tmp/dev.toml <<'EOF'
   server_name = "dev.example.org"
   ruleset = "core-rules@1.0"
   listen = "127.0.0.1:7411"
   database_url = "postgresql:///ishtaria_dev?host=/var/run/postgresql"
   EOF
   cargo build --locked
   ./target/debug/ishtaria-server --import ../ishtaria-worldgen/examples/planet-seed42-256.pgm \
       --seed 42 --import-only /tmp/dev.toml    # imports the sample planet, once
   ./target/debug/ishtaria-server /tmp/dev.toml  # serves on 127.0.0.1:7411

Migrations are applied when the server starts. ``curl http://127.0.0.1:7411/health`` answers
``ok``. To start from scratch drop the database and create it again; to get several players
for a test create them with ``POST /players`` (``{"username", "password"}`` returns a token).

Starting the client against it
------------------------------

.. code-block:: sh

   cd ishtaria-client
   godot4 --headless --path . --editor --import   # once, and after adding assets
   make run                                         # then enter 127.0.0.1:7411 as the server

The client keeps the connection settings in ``user://client.cfg`` (never passwords or tokens).

Testing
-------

.. code-block:: sh

   # server, in ishtaria-server
   cargo fmt --check
   cargo clippy --locked --all-targets -- -D warnings
   cargo test --locked                                             # unit tests
   DATABASE_URL='postgresql:///postgres?host=/var/run/postgresql' \
   ISHTARIA_TEST_HEIGHTMAP="$PWD/../ishtaria-worldgen/examples/planet-seed42-256.pgm" \
       cargo test --locked -- --include-ignored                    # with PostgreSQL

   # client, in ishtaria-client: every make test-* target is a headless Godot script
   make test-social test-trading test-placed test-magic

SQLx creates and drops an isolated database for each ignored test, so ``DATABASE_URL`` only needs
a role that may create databases. Never point it at a database you care about. If ``/tmp`` is
small, set ``TMPDIR`` to a directory with room.

Two things that make tests flaky if forgotten:

* every test database has the same world id, so a story cached by an earlier test must be reset
  (``initialize_spawn_world`` does it);
* never compare floating point positions for exact equality.

What headless tests cannot show
-------------------------------

A headless Godot run proves that scripts load, validators accept and refuse the right things and
that panels build. It does **not** prove that something looks right. For anything visible start the
client for real, look at the result (also at 640x480 and in Czech) and say in your report what you
saw and what you could not check.
