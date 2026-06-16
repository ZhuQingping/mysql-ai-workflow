# Workflow Validation Report - 2026-06-16

## Scope

Validated the installed workflow system against a real temporary bugfix task.
No validation work was performed in the source feature repository.

## Temporary Target

- Validation root: `/tmp/mysql-ai-workflow-validation-20260616112022`
- Target repo: `/tmp/mysql-ai-workflow-validation-20260616112022/sample-repo`
- Repository entrypoint: `AGENTS.md`
- Repository authority file: `PROJECT.md`
- Scenario: `bugfix-issue`
- Failing command: `./test.sh`
- Bug: `add(2, 3)` returned `-1` instead of `5`
- Patch under review:
  `/tmp/mysql-ai-workflow-validation-20260616112022/.ai-artifacts/bugfix-add/fix-add.patch`

## Installed Artifacts Checked

- Codex skills:
  - `workflow-intake`
  - `workflow-dispatch`
  - `workflow-review`
  - `workflow-night-run`
- Claude Code commands:
  - `/workflow-intake`
  - `/workflow-dispatch`
  - `/workflow-review`
  - `/workflow-night-run`

## Codex Validation

Status: PASS for workflow execution.

Codex successfully loaded the installed workflow skills and the workflow repo
documents, then validated all four workflows:

- `workflow-intake`: PASS
- `workflow-dispatch`: PASS
- `workflow-review`: PASS for workflow behavior; patch recommendation was
  `REVISE` until verification output and report artifacts are captured.
- `workflow-night-run`: PASS

Key evidence:

- `AGENTS.md` routed to `PROJECT.md`.
- `PROJECT.md` supplied the authoritative test command: `./test.sh`.
- Scope was correctly bounded to `src/calculator.js` and `test.sh`.
- Patch changed only `src/calculator.js`.
- `git apply --check --whitespace=error` succeeded for the patch.
- Night-run policy correctly forbade edits, commits, pushes, merges, rebases,
  destructive cleanup, and external publishing.

Important validation behavior:

- Codex did not falsely accept the patch as complete when the required
  verification command could not run in its read-only sandbox.
- Codex separated "workflow executed correctly" from "patch accepted".

## Claude Code Validation

Status: PASS after remediation.

The command files were installed under `~/.claude/commands` and validated with
the non-interactive Claude CLI using longer wait windows.

Validated commands:

- plain Claude CLI control prompt: PASS
- `/workflow-intake`: PASS after remediation
- `/workflow-dispatch`: PASS after remediation
- `/workflow-review`: PASS; recommendation was `ACCEPT WITH RISKS`
- `/workflow-night-run`: PASS

Initial Claude Code findings:

- `/workflow-intake` incorrectly reported edit permission as granted even
  though the prompt said `No edits`.
- `/workflow-dispatch` incorrectly generated a code-editing patch task even
  though the prompt said `Validation-only. Do not edit files.`
- `/workflow-review` behaved as expected and did not mutate files.
- `/workflow-night-run` behaved as expected and reported
  `Code-edit permission: DENIED`.

Remediation:

- Added a shared edit-permission gate to `common/precedence.md`.
- Updated intake and agent task templates to state that allowed files are only
  a maximum boundary, not edit authorization.
- Updated adapter contracts, Claude commands, and Codex skills to deny edits by
  default and to treat `no edits`, `validation-only`, `review-only`, and
  `dry run` as explicit denial.
- Reinstalled Claude commands and Codex skills.

Regression result:

- `/workflow-intake` now reports `Code-edit permission: DENIED` for the
  validation-only dry run.
- `/workflow-dispatch` now produces a read-only Review Agent task, sets
  allowed edit files to none, forbids all modifications, and omits patch-writing
  instructions.
- The sample target repository remained clean after validation.

## Gaps Found

1. `workflow-review` needs to explicitly distinguish:
   - workflow execution status
   - patch acceptance status
2. Reports should capture verification commands that could not run, diagnostic
   fallback commands, and owner review requirements.
3. The README directory layout still had stale scenario names from an earlier
   version.
4. Long Claude Code command runs can take over 60 seconds; validation scripts
   should use longer timeouts and record elapsed time.

## Follow-up Actions

- Update `common/agent-report-template.md` with verification waiver and fallback
  fields.
- Update `adapters/claude-code-command-contract.md` to recommend longer
  non-interactive validation timeouts and interactive fallback only after the
  longer timeout fails.
- Fix README stale scenario names.
- Add a small repeatable validation script for Claude Code commands.
