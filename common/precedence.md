# Workflow Precedence

Use this order when two instructions conflict:

1. Human instruction in the current conversation.
2. Repository authority file, as routed by the repository entrypoint.
3. Feature-specific task boards, phase documents, and accepted design docs.
4. Domain profiles that add stricter checks for the current task.
5. Common workflow rules and scenario workflows.
6. Tool adapters under `adapters/`.
7. Agent-local memory, generated prompts, scratch notes, and draft reports.

Feature-specific documents and domain profiles may narrow scope, add tests, or
impose stricter ownership rules. Narrower or stricter safety rules win over
broader defaults.

Adapters describe how a tool executes the workflow. They are not the workflow
source of truth.
