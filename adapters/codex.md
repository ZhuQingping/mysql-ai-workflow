# Adapter: Codex

Use Codex as an orchestrator or implementation agent while keeping workflow
content in `Docs/ai_workflows/`.

## Context Entry

Codex should read:

- the repository entrypoint, commonly `AGENTS.md`
- the repository authority file named by that entrypoint
- this workflow repository's `README.md`
- the relevant scenario workflow
- the relevant domain profile, if any
- the relevant feature task document

## Recommended Usage

- Use Codex for repository exploration, design drafting, patch integration,
  review, and local build/test verification.
- Use worktrees for independent delegated tasks.
- Keep final commits under orchestrator control.
- Follow `common/worktree-protocol.md` for delegated code-editing tasks.

## Codex-Specific Assets

Current-state behavior can be document-driven: the prompt should name the
scenario workflow, allowed files, forbidden files, verification command, and
report template.

Future Codex skills should reference workflow docs instead of duplicating them.
A scenario skill should define:

- trigger conditions
- documents it must read
- checks it enforces before edits
- stop conditions
- output format
- verification requirements
- failure behavior when required context is missing

Skills should enforce routing, required reads, stop conditions, and
verification. They should not duplicate scenario bodies or become
domain-specific truth.

## Skill Contract

When Codex skills are created, they should follow
`adapters/codex-skill-contract.md`.
