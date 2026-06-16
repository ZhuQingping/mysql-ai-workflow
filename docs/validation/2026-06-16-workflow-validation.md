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

Status: PARTIAL.

The command files were installed and present under `~/.claude/commands`, but
non-interactive Claude CLI validation did not return output for:

- the full four-workflow validation prompt
- a smaller `/workflow-intake` smoke prompt

This is recorded as a tooling/runtime validation gap, not a workflow content
pass. The next validation should run these commands in interactive Claude Code
or with a smaller tool-disabled prompt strategy that is known to return.

## Gaps Found

1. `workflow-review` needs to explicitly distinguish:
   - workflow execution status
   - patch acceptance status
2. Reports should capture verification commands that could not run, diagnostic
   fallback commands, and owner review requirements.
3. The README directory layout still had stale scenario names from an earlier
   version.
4. Claude Code slash commands are installed, but non-interactive command
   execution needs further validation.

## Follow-up Actions

- Update `common/agent-report-template.md` with verification waiver and fallback
  fields.
- Update `adapters/claude-code-command-contract.md` to require interactive
  validation when non-interactive slash-command validation hangs or returns no
  output.
- Fix README stale scenario names.
- Re-run Claude command validation interactively.
