# Scenario: Test Suite Migration

Use this for test suite migration, suite classification, test stabilization,
skip manifest work, and generated regression coverage.

## Flow

1. Identify the source suite or test.
2. Classify the test: supported now, unsupported by current scope, flaky,
   requires adaptation, or obsolete.
3. Port only the supported or explicitly approved subset.
4. Keep expected output deterministic.
5. Run the targeted test command defined by the repository authority file.
6. Record skipped tests with reasons.
7. Update the relevant suite manifest or task board.

## Required Fields

- source test path
- target test path
- scope decision
- adaptation notes
- command run
- result
- skip reason, if skipped

## Agent Split

Test Agents can classify and migrate independent tests in parallel. The
orchestrator owns final suite composition and skip policy.
