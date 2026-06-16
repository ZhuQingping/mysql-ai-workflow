# Scenario: Bugfix / Issue

Use this for customer issues, internal defects, crashes, wrong results, failed
tests, resource leaks, and regressions.

## Flow

1. Intake the issue, observed behavior, expected behavior, environment, and
   reproduction steps.
2. Reproduce or explain why reproduction is not currently possible.
3. Gather evidence: logs, stack traces, failing inputs, test output, or code
   path.
4. Identify the root cause before proposing the fix.
5. Implement the smallest safe fix.
6. Add or update a regression test where practical.
7. Run targeted verification.
8. Prepare customer-facing explanation if needed.

## Rules

- Do not patch by guessing from symptoms alone.
- Keep unrelated cleanup out of the fix.
- Preserve diagnostics where the original failure path exposed useful errors.
- If reproduction is impossible, document the evidence gap and confidence level.

## Deliverables

- Root cause summary.
- Minimal patch.
- Regression test or explicit test gap.
- Verification output.
- Risk and backport notes if applicable.
