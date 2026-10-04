0003 – Debian packages, Linux only
==================================

:Status: Accepted
:Date: 2026-10-04

Context
-------

The project is maintained by a small team with an existing Debian build
and APT distribution pipeline.

Decision
--------

All components are distributed as ``.deb`` packages for Debian and Ubuntu
on x86-64. Windows and macOS builds are not planned.

Consequences
------------

* One build and distribution path, reusing the VitexSoftware Jenkins +
  Aptly pipeline.
* Server operators get standard ``apt``/``systemd`` administration.
* The potential player base is limited to Linux desktop users. Godot can
  export to other platforms, so this decision can be revisited without
  changing the architecture.
