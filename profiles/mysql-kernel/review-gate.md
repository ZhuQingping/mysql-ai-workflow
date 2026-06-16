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

