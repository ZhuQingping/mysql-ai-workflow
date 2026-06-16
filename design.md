# Personal AI Development Operating System Design

## Goal

Build a durable, agent-neutral workflow system that helps one engineer use AI
agents for software feature development, performance optimization, issue fixing,
testing, documentation, and quality hardening.

The system should work with Codex today and Claude Code later. It should also be
usable by other agents if they can read repository files and produce patches.

## Layering

```text
<repo-entrypoint>
  repository entry point, such as AGENTS.md

<repo-authority-file>
  repository facts, build/test commands, project goals, stable decisions

mysql_ai_workflow/
  agent-neutral workflow rules, templates, scenarios, gates

<feature-task-board>
  feature-specific task board, phase docs, agent reports

profiles/
  domain-specific checks and examples

Tool adapters and skills
  Codex skills, Claude Code commands/subagents/hooks, MCP, shell scripts
```

## Responsibilities

The repository entrypoint should stay small and route agents to the
authoritative project context.

The repository authority file should hold repository-level facts and stable
project constraints. It should not become a detailed process manual.

This workflow repository should define reusable work methods and templates.
These documents are the source content for humans, agents, skills, and future
automation.

Tool-specific skills, commands, hooks, and MCP integrations should read these
workflow documents and enforce them during execution. They should not duplicate
large workflow bodies.

## Agent Roles

- Orchestrator: task decomposition, file boundaries, integration, review,
  verification, and commits.
- Design Agent: reference research, design tradeoffs, interface contracts, risk
  analysis.
- Code Agent: bounded implementation in assigned files.
- Test Agent: build, test, correctness, stability, and benchmark execution.
- Review Agent: code review focused on bugs, lifecycle, concurrency, memory,
  error handling, regressions, and missing tests.
- Docs Agent: customer-facing documentation, release notes, and internal
  handoff material.

Feature-specific workflows may collapse roles for simplicity. For example, the
orchestrator may also perform review or documentation duties when that is safer
than dispatching another agent.

## Night Work Policy

Night work is allowed, but default output is non-final:

- research notes
- candidate designs
- test classifications
- patches for review
- build or test logs
- risk reports
- draft documentation

Night agents must not merge, commit, or broaden scope unless the task document
explicitly grants that authority.

## First-Version Scope

V1 provides reusable workflow documents and templates. It does not
require a low-code platform, external database, or new service.

After V1 is used on real tasks, review the retrospective notes and decide which
repeated actions should become scripts, Codex skills, Claude Code
commands/subagents, hooks, MCP integrations, or low-code dashboards.
