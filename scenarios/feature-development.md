# Scenario: Feature Development

Use this for new features, major feature phases, and cross-layer extensions.

## Flow

1. Intake: fill `common/task-intake-template.md`.
2. Context: read the repository entrypoint, repository authority file, related
   feature task board, and accepted design documents.
3. Design: write or update a design using `common/design-template.md`.
4. Decompose: split work into phases with explicit allowed and forbidden files.
5. Dispatch: assign Design, Code, Test, and Review roles as needed.
6. Implement: keep cross-layer implementation serial unless file ownership is
   clearly independent.
7. Verify: apply `common/verification-matrix.md`.
8. Review: apply `common/review-gate.md`.
9. Accept: record the result in the feature task board.
10. Retrospect: update workflows or skills when repeated friction appears.

## Parallelism Guidance

Parallelize research, test classification, documentation, and isolated module
work. Keep cross-layer runtime, persistence, concurrency, and ownership changes
serial unless the orchestrator explicitly approves parallel work.

## Deliverables

- Design or phase document.
- Patch or patch set.
- Agent reports.
- Build/test evidence.
- Review conclusion.
- Updated task board.
