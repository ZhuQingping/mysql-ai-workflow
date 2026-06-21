---
name: mysql-acceptance-gate
description: Use when planning, auditing, or reporting MySQL feature acceptance testing, including full MTR gates, sanitizer gates, coverage, and feature-specific performance benchmarks such as sysbench for plan cache and TPC-H for parallel query or PTRC.
---

# MySQL Acceptance Gate

Use this skill when a MySQL or database-kernel feature needs a final acceptance
plan, current test status, or quality-hardening checklist.

## Required Reads

Read from the workflow repository, defaulting to
`/Users/zhuqingping/Work/Database/MySQL/mysql_ai_workflow` unless the user names
another path:

- `common/verification-matrix.md`
- `profiles/mysql-kernel/verification-matrix.md`
- `profiles/mysql-kernel/acceptance-standard.md`

Read the target repository authority file before judging commands or evidence:

- `AGENTS.md`, `CLAUDE.md`, or the repository-specific authority file named by
  the user

## Process

1. Identify the feature type and map its performance gate:
   - plan cache: sysbench
   - parallel query: TPC-H
   - PTRC or partial result cache: TPC-H
   - other MySQL kernel feature: feature-specific benchmark justified in the
     report
2. Record current repository state: branch, base revision, feature revision,
   dirty tree, feature-owned files, and feature-owned tests.
3. Build an acceptance table using the required gate vocabulary from
   `profiles/mysql-kernel/acceptance-standard.md`.
4. Mark a gate `PASS` only when evidence was produced on the current feature
   revision.
5. Separate product failures from environment-only waivers. Do not waive a
   failing product behavior as an environment issue.
6. Produce the next test plan for every gate that is `NOT_RUN`,
   `RUN_WITH_FAILURES`, or `BLOCKED_BY_ENVIRONMENT`.
7. Before final acceptance, request or perform an independent review of code,
   tests, documents, performance evidence, and waivers.

## Output

Return:

- feature type and performance benchmark
- current acceptance status table
- evidence already available
- missing or stale gates
- required next tests
- waiver list
- risk areas
- final recommendation: `ACCEPT`, `ACCEPT WITH RISKS`, or `CONTINUE TESTING`

