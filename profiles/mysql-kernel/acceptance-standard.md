# MySQL Feature Acceptance Standard

Use this standard for MySQL feature handoff, final quality hardening, and
release-readiness review. It supplements `common/verification-matrix.md` and
`profiles/mysql-kernel/verification-matrix.md`.

Project-specific task documents may add stricter gates. They must not weaken
these gates unless the waiver is explicit, evidence-backed, and unrelated to
the product behavior under review.

## Result Vocabulary

- `PASS`: The gate was run on the current feature revision and passed.
- `PASS_WITH_APPROVED_ENV_WAIVER`: The gate passed with a documented,
  environment-only waiver approved by the owner.
- `RUN_WITH_FAILURES`: The gate was run and exposed failures that still need
  triage or fixes.
- `BLOCKED_BY_ENVIRONMENT`: The gate could not run because the host, toolchain,
  data set, or dependency is unavailable.
- `NOT_RUN`: No current-revision evidence exists.

Do not report a feature as accepted while any required gate is `RUN_WITH_FAILURES`
or `NOT_RUN`. `BLOCKED_BY_ENVIRONMENT` requires a replacement host plan or an
explicit owner waiver.

## Required Gates

### 1. Scope and Baseline

- Record the repository path, branch, base revision, feature revision, and dirty
  working-tree state.
- List feature-owned files, tests, generated documents, and intentionally
  excluded scratch or build artifacts.
- Re-run affected gates after any source or test change. Older evidence may be
  kept as history, but it must not be used as current acceptance evidence.

### 2. Focused Feature Correctness

- Run all feature-owned MTR, unit, or integration tests.
- Cover enable/disable behavior, eligibility rules, fallback behavior, error
  paths, unsupported paths, diagnostics, and repeated execution.
- When the feature has an existing baseline path, compare new behavior against
  the baseline path before claiming correctness.
- For optimizer, executor, cache, or storage behavior, include result-set
  equality checks and plan/status evidence where relevant.

### 3. Release Full MTR

- Run full MTR on a release build from the current feature revision.
- Use the repository authority file for canonical build and MTR options.
- Any skip or waiver must identify the exact test, reason, owner approval, and
  why it is unrelated to the feature.

### 4. Debug Full MTR

- Run full MTR on a debug build from the current feature revision.
- Include DBUG, assert, error-injection, or fault-injection tests when the
  feature adds debug hooks or lifecycle-sensitive cleanup paths.
- Treat debug-only assertion failures as product issues until proven otherwise.

### 5. ASAN/UBSAN Full MTR

- Run full MTR with ASAN and UBSAN enabled on the current feature revision.
- Record sanitizer flags, compiler, platform, MTR command, log path, and whether
  leak detection was enabled.
- LSAN must be included on supported hosts. If the local platform cannot run
  LSAN reliably, record the blocker and run it on a supported Linux toolchain
  before final acceptance, unless the owner explicitly waives it.
- Do not claim sanitizer coverage from focused tests when the acceptance gate
  requires full MTR.

### 6. Code Coverage

- Produce coverage from a coverage-enabled build after running the focused
  feature tests and any broader tests needed for the changed execution paths.
- Define the feature-owned source files before reading the coverage result.
- The default feature-owned code coverage bar is greater than or equal to 90%.
- If coverage is below 90%, either add meaningful tests or document an explicit
  owner-approved exclusion for unreachable defensive code.

### 7. Feature Performance

- Use a feature-appropriate benchmark, not a generic benchmark by default.
- Verify correctness before measuring speed.
- Record workload, data scale, server options, warmup, measured runs, variance,
  baseline command, feature command, and resource metrics.
- Report both positive and negative results. Avoid claiming performance value
  outside the measured scenario.

Default benchmark mapping:

| Feature area | Required performance benchmark |
| --- | --- |
| Plan cache | sysbench |
| Parallel query | TPC-H |
| Partial result cache / PTRC | TPC-H |
| Optimizer rule without cache or parallelism | Feature-specific SQL plus targeted microbenchmark when applicable |
| Storage engine or handler path | Feature-specific workload plus transaction and concurrency coverage |

Plan cache sysbench evidence should include the chosen sysbench workload,
prepared-statement mode when relevant, TPS/QPS, latency percentiles, CPU,
memory, and cache hit/miss or prepare/execute status counters when available.

Parallel query TPC-H evidence should include scale factor, selected queries,
degree or parallelism settings, elapsed time, speedup versus serial baseline,
correctness hashes, resource usage, and non-parallel fallback behavior.

PTRC TPC-H evidence should include scale factor, selected cache-eligible
queries, repeated-run policy, PTRC on/off elapsed time, result hashes, cache
hit/miss or diagnostic counters, memory cap behavior, peak RSS, and fallback
behavior for non-eligible queries.

### 8. Reference Parity and Compatibility

- If a reference implementation exists, compare the migrated behavior against
  the reference implementation for feature-owned semantics and known bug fixes.
- When design documents and reference code disagree, record which source of
  truth was chosen and why.
- Cover upgrade, default-off/default-on, configuration, privilege, replication,
  or compatibility behavior when the feature touches those surfaces.

### 9. Documentation and Commit Message

- Update the task progress, design documents, test report, performance report,
  known gaps, and reviewer handoff notes before final submission.
- The final commit message must describe the user-visible value, scope, major
  implementation points, tests run, and residual risks or waived gates.
- Keep claims tied to measured facts. Do not include unrelated fixes in the
  feature commit unless they are explicitly required by the feature.

### 10. Independent Review

- Run an independent review after implementation and after final quality
  evidence is collected.
- The reviewer must inspect code, tests, documentation, performance evidence,
  waiver rationale, and the final acceptance table.
- Final acceptance requires agreement on open risks, not just absence of
  compiler or test failures.

## Acceptance Report Template

```text
Repository:
Branch:
Base revision:
Feature revision:
Working tree:

Feature:
Feature-owned files:
Feature-owned tests:

Gate status:
  Focused feature correctness:
  Release full MTR:
  Debug full MTR:
  ASAN/UBSAN full MTR:
  LSAN:
  Coverage >= 90%:
  Feature performance:
  Reference parity:
  Documentation:
  Independent review:

Waivers:
  - Test or gate:
    Status:
    Reason:
    Evidence:
    Owner approval:

Performance benchmark:
  Benchmark:
  Data scale:
  Baseline command:
  Feature command:
  Warmup:
  Measured runs:
  Correctness check:
  Metrics:
  Result:

Remaining risks:
Final recommendation:
```

