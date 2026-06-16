# Verification Matrix

Use the smallest verification set that gives enough confidence for the risk
level. Broaden verification when changes touch shared execution paths,
public APIs, persistent data, concurrency, security, or user-visible behavior.

## Documentation-only

- Markdown renders/readable.
- Links point to existing files where practical.
- No commands required unless the document includes generated content.

## Code changes

- Run the project build command from the repository authority file.
- Run targeted tests first.
- Run broader related tests when risk is medium, high, or critical.
- Check generated outputs or user-visible diagnostics when behavior changes.

## Shared runtime or persistence paths

- Run the project build command.
- Run targeted and related integration tests.
- Run fallback or unsupported-path tests when feature eligibility is involved.
- Compare new behavior with the existing serial or baseline behavior when
  correctness could diverge.
- Review timeout, cancellation, OOM, early-exit, and error propagation paths.
- Review ownership, lifetime, consistency, and concurrency semantics.

## Test suite changes

- Prefer targeted invocation before suite-level invocation.
- Save first failure and relevant log path.

## Performance changes

- Record baseline command, dataset, server options, and warmup policy.
- Compare serial and changed behavior.
- Include variance or repeated runs for claims.
- Check correctness before measuring speed.

## Customer-facing docs

- Verify technical claims against code, tests, or accepted design.
- Avoid promising unsupported behavior.
- Separate confirmed behavior from planned behavior.
