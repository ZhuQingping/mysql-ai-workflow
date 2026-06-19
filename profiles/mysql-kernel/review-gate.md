# MySQL / Database Kernel Review Gate

Use this in addition to `common/review-gate.md`.

Blocking checks for MySQL kernel patches:

- The patch follows nearby MySQL style.
- MTR is run from the build tree unless the task explains why not.
- EXPLAIN/status result changes are intentional and reviewed.
- Transaction visibility, read-view semantics, and handler state are reviewed
  for storage-engine or handler changes.
- Kill, OOM, timeout, and error-propagation paths are reviewed for executor,
  worker, or iterator lifecycle changes.
- Performance claims include a serial or baseline comparison.

## Resource Limits And Shared Infrastructure

Use these checks for patches that change connection limits, memory pools,
lock-free containers, global caches, counters, sizing constants, or other
process-wide resource ceilings.

Blocking checks:

- Public admission limits are separated from lower-level internal resource
  pools, and the report explains which limit actually fails first.
- Allocation trigger, owner, lifetime, and release path are identified for the
  resource being expanded or capped.
- Non-obvious consumers are reviewed, including internal threads, startup and
  initialization paths, authentication, default database selection, and
  monitoring or agent connections when relevant.
- Shared infrastructure changes list other direct users of the changed helper,
  container, allocator, or synchronization primitive, and record why the impact
  is acceptable.
- Capacity claims distinguish removing a specific hard ceiling from proving the
  full operational capacity of the server or deployment.

## Customer-Facing MySQL Explanations

Use these checks when a kernel issue needs an external explanation, support
response, release note, or customer-readable design summary.

- Expand MySQL or kernel abbreviations on first use.
- Translate internal mechanisms into user-facing language without changing the
  technical meaning.
- Separate confirmed source or test behavior from workload-level inference.
- State limitations explicitly when the fix addresses only one layer of a
  larger capacity, performance, or availability problem.
