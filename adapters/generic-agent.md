# Adapter: Generic Agent

Any agent can participate if it can read files, write bounded changes, run
commands when authorized, and produce a structured report.

Before accepting a role, the agent must disclose meaningful limitations such as
read-only access, no shell access, no long-running command support, no local
build environment, or no ability to export patches.

## Minimum Protocol

1. Read the repository entrypoint, then the repository authority file.
2. Read this workflow repository's `README.md`.
3. Read the scenario workflow and task document.
4. Respect allowed and forbidden files.
5. Do not commit unless explicitly instructed.
6. Produce a report using `common/agent-report-template.md`.
7. Produce a patch or changed-file list when code was modified.
8. State capability limits that affected the result.

## Handoff Format

Use files and shell-compatible artifacts:

- task document
- patch
- report
- log path
- command transcript
- verification result
