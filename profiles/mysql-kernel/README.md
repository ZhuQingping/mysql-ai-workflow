# Profile: MySQL / Database Kernel

Use this profile with the common workflow when working on MySQL, database kernel,
optimizer, executor, storage-engine, MTR, or similar systems code.

This profile adds stricter review and verification requirements. It should not
replace the common workflow documents.

## Documents

- `verification-matrix.md`: MySQL-specific verification guidance.
- `review-gate.md`: MySQL-specific review checks.
- `acceptance-standard.md`: Final MySQL feature acceptance standard covering
  focused tests, release/debug/full MTR, ASAN/UBSAN/LSAN, coverage, and
  feature-specific performance benchmarks.
