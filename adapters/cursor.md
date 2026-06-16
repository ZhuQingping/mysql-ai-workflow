# Adapter: Cursor

Use Cursor as an implementation, review, or navigation agent while keeping
workflow content in this repository.

## Context Entry

Cursor should read:

- the repository entrypoint
- the repository authority file or Cursor rules file used by the project
- this workflow repository's `README.md`
- the relevant scenario workflow
- the relevant domain profile, if any
- the relevant feature task document

## Recommended Usage

- Use project rules such as `.cursorrules` or Cursor rule files only as adapter
  entrypoints.
- Keep process rules in this workflow repository.
- Use bounded tasks with explicit allowed and forbidden files.
- Use `common/worktree-protocol.md` when parallel edits are expected.
- Record changed files, verification, and residual risks in the agent report.

