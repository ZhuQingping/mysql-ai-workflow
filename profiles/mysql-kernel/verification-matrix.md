# MySQL / Database Kernel Verification Matrix

Use this in addition to `common/verification-matrix.md`.

## Build

- Prefer the repository authority file's canonical build command.
- For the current MySQL workspace, the common fast target is:

```bash
cd build-ninja && ninja mysqld -j 16
```

## SQL / Optimizer / Executor

- Run targeted MTR from the build tree.
- Check EXPLAIN or status output when planning or diagnostics change.
- Compare new feature behavior against the serial or baseline path before
  claiming performance gains.
- Run fallback and unsupported-path tests when eligibility rules change.

## Handler / InnoDB / Storage Engine

- Review transaction visibility and read-view behavior.
- Review handler state reuse and record ownership.
- Cover error cleanup, OOM, kill, early exit, and timeout paths.
- Consider repeated MTR, debug builds, sanitizers, or stress loops when the
  change touches concurrency or lifecycle boundaries.

## Performance

- Record dataset, server options, warmup, run count, and baseline.
- Verify correctness before measuring speed.
- Record variance or repeated runs for any performance claim.

