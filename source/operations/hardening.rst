Hardening a public world
========================

A world that anybody can reach needs more than the defaults of a development machine. Work through
this list before you announce your server.

Network and TLS
---------------

* Put the server behind a reverse proxy that terminates **TLS** (nginx, Caddy). Never offer accounts over plain
  HTTP to the internet: passwords and session tokens would travel in the clear. The client refuses to
  send remote credentials over HTTP.
* Bind the server to loopback (``listen = "127.0.0.1:7400"``) and let only the proxy reach it. Open only
  443 (and 80 for the certificate) in the firewall; PostgreSQL stays on its local socket.
* Set ``trust_proxy = true`` **only** in this setup, so that limits and logs see the real client.

A minimal nginx site (the package ``ishtaria-web`` ships a fuller example for the portal):

.. code-block:: nginx

   server {
       listen 443 ssl http2;
       server_name world.example.org;
       # ssl_certificate ... ssl_certificate_key ...  (for example from certbot)
       client_max_body_size 64k;                       # the server refuses more anyway
       location / {
           proxy_pass http://127.0.0.1:7400;
           proxy_set_header Host $host;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_read_timeout 35s;                      # the server times requests out at 30 s
       }
   }

Accounts and limits
-------------------

* Keep the default ``auth_per_minute`` (10 per address). Registration and login share it, which
  slows guessing and the making of accounts alike.
* Passwords are stored as Argon2id hashes and session tokens only as hashes; tokens expire and can be
  revoked (log out). Nothing in the logs contains a password, a token or a query string.
* Consider also rate limiting in the proxy (``limit_req``) and a ban tool such as ``fail2ban`` on the
  access log lines with ``status=429``.
* Bans of abusive players and scheduled shutdowns are done with ``ishtaria-admin``.

The system service
------------------

The package runs the server as a systemd unit under its own user. Keep it that way: no root, the
configuration file readable only by that user, and ``DATABASE_URL`` (if you use it) in the environment of the
unit, not in a world-readable file. Federation signing keys live in the database; back it up
(:doc:`backup`) and treat the backup as a secret.

Checklist
---------

.. list-table::
   :header-rows: 1
   :widths: 5 95

   * - ☐
     - TLS in front, server bound to loopback, firewall closed except 80/443
   * - ☐
     - ``trust_proxy`` set exactly when a proxy of yours is in front
   * - ☐
     - ``[limits]`` reviewed for the number of players per address you expect
   * - ☐
     - ``/metrics`` readable by your monitoring only (:doc:`monitoring`)
   * - ☐
     - backups run and a restore was tried on another machine (:doc:`backup`)
   * - ☐
     - the operator policy of federation is ``approve`` or ``closed`` unless you know why not
   * - ☐
     - packages are updated (``apt upgrade``); read the changelog before a server upgrade
