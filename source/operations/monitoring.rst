Monitoring
==========

Logs
----

The server writes to standard error, which the systemd journal collects with the time:

.. code-block:: sh

   journalctl -u ishtaria-server -f

By default (``access_log = "errors"``) a line is written for every answer with status 400 or more and
for every request slower than 500 ms; ``"all"`` writes every request and ``"off"`` none. A line looks
like this and never contains a query string, a token or a password:

.. code-block:: text

   access ip=203.0.113.5 method=POST path=/players/me/cast status=429 ms=1
   access ip=203.0.113.5 method=POST path=/players status=429 limited=true

Metrics
-------

``GET /metrics`` gives counters and gauges in the Prometheus text format. From the server machine:

.. code-block:: sh

   curl -s http://127.0.0.1:7400/metrics

With a ``metrics_token`` a remote scraper may read it (``Authorization: Bearer ...``). A Prometheus job:

.. code-block:: yaml

   scrape_configs:
     - job_name: ishtaria
       metrics_path: /metrics
       authorization: { type: Bearer, credentials: long-random }
       static_configs: [{ targets: ["world.example.org:443"] }]
       scheme: https

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Metric
     - Meaning
   * - ``ishtaria_http_requests_total{class}``
     - answers by status class (2xx, 3xx, 4xx, 5xx)
   * - ``ishtaria_http_requests_by_group_total{group}``
     - requests by area: players, world, chat, shops, trades, placed, story, ...
   * - ``ishtaria_http_rate_limited_total``
     - requests refused by a limit
   * - ``ishtaria_http_timeouts_total``
     - requests that ran into the 30 s limit
   * - ``ishtaria_http_request_duration_ms_sum`` / ``_count``
     - total time and count (their ratio is the mean)
   * - ``ishtaria_players_online`` / ``ishtaria_players_alive``
     - living characters active in the last 30 s / all living characters
   * - ``ishtaria_db_pool_connections{state}``
     - open and idle connections of the database pool (at most 10)
   * - ``ishtaria_uptime_seconds``, ``ishtaria_build_info{version}``
     - process age and version

Things worth an alert: ``5xx`` growing, a pool that stays at 10 open and 0 idle, ``rate_limited`` jumping
(an attack, or a limit that is too small for a school), ``timeouts`` above zero, and no data at all.
``GET /health`` is a cheap liveness check (it asks the database).

Capacity: what one machine did
------------------------------

``tools/loadtest.py`` of ``ishtaria-server`` simulates players who register and then walk, look
around, poll events, chat and ask for their profile. A measurement of 2026-10-07 with a *release* build of
version 0.2.1, PostgreSQL on the same machine and the load generator on the same machine too (a desktop
with a consumer GPU; so the real server would have the CPU for itself):

.. list-table::
   :header-rows: 1

   * - 100 simulated players, 30 s, one request every 100 ms each
     - result
   * - throughput
     - about 940 requests per second, no ``5xx``, no timeouts
   * - walking (``move``), 15 700 requests
     - mean 4.5 ms, p95 10 ms, p99 17 ms
   * - looking around (``nearby``), events, profile
     - p95 between 2 and 9 ms
   * - registration of 100 players at once
     - mean 0.7 s, p95 1.3 s (passwords are hashed two at a time, on purpose)
   * - process
     - about 200 MB of memory

These numbers say that a small world has plenty of headroom; they do **not** say how a world with thousands of
players behaves, how the network of real players looks, or how the server performs with a slow
database. A real client sends about ten requests per second while walking and fewer when standing. Measure
your own setup before an event: raise the limits for the test, run the tool from another machine, and watch
``/metrics`` while it runs. Debug builds are several times slower, notably in password hashing.
