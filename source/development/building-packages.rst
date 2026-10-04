Building packages
=================

Every repository contains a ``debian/`` directory (native format, debhelper
13) and builds with the standard tools:

.. code-block:: sh

   sudo apt build-dep .
   dpkg-buildpackage -us -uc -b

Notes per repository
--------------------

Rust (server, worldgen)
   ``debian/rules`` calls ``cargo build --release``. Crates are fetched
   from crates.io during the build, which fits the VitexSoftware build
   pipeline but not the official Debian archive.

Client
   Needs a Godot 4.5 binary and Linux export templates. Run
   ``tools/fetch-godot.sh`` first or set ``GODOT=/path/to/godot``.

Documentation
   ``sphinx-build -W`` – warnings fail the build.

CI
--

Each repository has a GitHub Actions workflow that runs tests and builds the
``.deb`` as an artifact. Publishing to ``repo.vitexsoftware.com`` is done by
the existing Jenkins + Aptly pipeline.
