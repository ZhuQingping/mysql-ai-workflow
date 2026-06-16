# AI Workflows

语言：[English](README.md) | 简体中文

本仓库定义了一套面向日常软件开发的、Agent 中立的工作流系统。它不绑定
Codex、Claude Code、Cursor，也不绑定任何单一自动化平台或具体项目。

每个项目都应该定义自己的代码仓入口文件和权威上下文文件。本仓库提供可复用
的工作流层：它描述不同类型的工作如何从任务准入推进到最终交付。

英文 README 是主要维护源。翻译版本应保持相同的工作流语义、命令名称、文件
路径和安全规则。

## 设计原则

- workflow 资产保持 Agent 中立。工具相关行为放在 `adapters/` 中。
- Agent 之间通过文件交接：任务文档、patch、报告、日志和验证结果。
- 实现工作必须受明确的 allowed files 和 forbidden files 约束。
- Orchestrator 负责跨层决策、集成、检视和提交。
- 夜间任务默认只产出草稿。夜间 Agent 可以产出报告、patch、分类和测试结果，
  但没有明确批准时不应合入变更。
- 优先拆成小的、可检视的任务，避免宽泛的自动修改。

Adapter 必须遵循 `adapters/contracts.md`。工具专用文件可以增加执行机制，
但不能弱化通用工作流规则。

## 目录结构

```text
mysql_ai_workflow/
  README.md
  design.md

  common/
    precedence.md
    worktree-protocol.md
    task-intake-template.md
    design-template.md
    agent-task-template.md
    agent-report-template.md
    review-gate.md
    verification-matrix.md
    night-agent-runbook.md
    retrospective-template.md

  scenarios/
    feature-development.md
    performance-optimization.md
    bugfix-issue.md
    external-docs.md
    quality-hardening.md
    test-suite-migration.md

  adapters/
    contracts.md
    codex.md
    codex-skill-contract.md
    claude-code.md
    claude-code-command-contract.md
    cursor.md
    generic-agent.md

  profiles/
    mysql-kernel/
      README.md
      verification-matrix.md
      review-gate.md

  codex-skills/
    workflow-intake/
    workflow-dispatch/
    workflow-review/
    workflow-night-run/

  claude-commands/
    workflow-intake.md
    workflow-dispatch.md
    workflow-review.md
    workflow-night-run.md

  scripts/
    install_codex_skills.sh
    install_claude_commands.sh
```

## 如何选择工作流

- 新特性：使用 `scenarios/feature-development.md`。
- 性能工作：使用 `scenarios/performance-optimization.md`。
- 客户问题或 bugfix：使用 `scenarios/bugfix-issue.md`。
- 测试套件迁移：使用 `scenarios/test-suite-migration.md`。
- 外部文档或发布说明：使用 `scenarios/external-docs.md`。
- 风险闭环、稳定性或回归加固：使用 `scenarios/quality-hardening.md`。

对于特性相关工作，还要读取该特性的任务板和阶段文档。特性文档可以增加更
严格的规则，但不应替代通用工作流层。

对于领域相关工作，还要读取 `profiles/` 下匹配的 profile。

## 典型使用模式

将本仓库作为可复用的工作流层。实际工作从目标代码仓开始，本仓库提供任务
分类、交接模板、检视门禁和工具 adapter。

每个任务都应该从 intake 开始：

```text
Use the workflow repository:
<path-to>/mysql_ai_workflow

Run workflow-intake first. Do not edit files yet.

Target repository:
<current project path>

Task:
<describe the issue, feature, test work, documentation work, or quality work>

Return:
- scenario
- required reads
- scope
- allowed files
- forbidden files
- verification command
- code-edit permission
- night-run permission
- next workflow step
```

### 问题单修复

适用于客户问题、内部 bug 报告、失败测试、错误结果、crash、回归或生产
事故。

工作流：

```text
workflow-intake
-> reproduce and collect evidence
-> workflow-dispatch Code Agent
-> workflow-review
-> human integration or commit
```

示例提示词：

```text
Use workflow-intake and workflow-dispatch.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Scenario:
bugfix-issue

Problem:
<failing command, error message, customer symptom, or wrong result>

Current phase:
intake only. No edits.

After intake is accepted, create a bounded Code Agent task with:
- explicit allowed files
- explicit forbidden files
- verification command
- patch output path
- no commit
```

### 新特性开发

适用于新行为、新语法、新 API、优化器或执行器改动、存储行为、兼容性工作，
或更大的多阶段实现。

工作流：

```text
workflow-intake
-> design task
-> design review
-> split into bounded implementation tasks
-> parallel or serial workflow-dispatch
-> workflow-review for each patch
-> integration verification
-> docs and retrospective
```

示例提示词：

```text
Use workflow-intake for a new feature.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Feature:
<describe the requirement and expected behavior>

Current phase:
design only. No code edits.

Output:
- scenario: feature-development
- design questions
- affected modules
- required tests
- risk areas
- proposed task split
- whether parallel agents are safe
```

### 自测试和验证

适用于交付前自测试、回归验证、复现失败、检查 patch，或在检视前建立信心。

工作流：

```text
workflow-intake
-> identify authoritative test commands
-> run scoped verification
-> workflow-review if a patch or report exists
-> record gaps and owner decisions
```

示例提示词：

```text
Use workflow-intake for self-test.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Validate the current working tree before review.

No code edits.

Please:
- read the repository authority file
- identify required verification commands
- run only the agreed scoped tests
- report pass/fail output
- list verification gaps
- do not commit
```

### 性能优化

适用于延迟、吞吐、CPU、内存、锁竞争、计划质量、IO 或 benchmark 回归。

工作流：

```text
workflow-intake
-> baseline benchmark
-> hypothesis and profiling tasks
-> bounded optimization patch
-> before/after benchmark comparison
-> workflow-review
```

示例提示词：

```text
Use workflow-intake for performance-optimization.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Problem:
<benchmark, query, workload, flamegraph, or regression evidence>

Current phase:
analysis only. No edits.

Output baseline commands, suspected components, profiling plan, risk areas,
and the smallest safe next task.
```

### 测试迁移

适用于在测试框架之间迁移测试、稳定 flaky test、拆分大型测试套件，或为迁移
后的行为增加覆盖。

工作流：

```text
workflow-intake
-> test-suite-migration plan
-> migrate a bounded batch
-> run old and new verification where practical
-> workflow-review
```

示例提示词：

```text
Use workflow-intake for test-suite-migration.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Migrate <test group> from <old framework> to <new framework>.

Current phase:
planning only. No edits.

Return migration scope, files, equivalence checks, forbidden areas, and
verification commands.
```

### 文档

适用于客户可见文档、发布说明、设计说明、runbook、升级说明或内部工程交接。

工作流：

```text
workflow-intake
-> external-docs or feature-development docs task
-> Docs Agent draft
-> workflow-review
-> human publish approval
```

示例提示词：

```text
Use workflow-intake for external-docs.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Draft customer-facing documentation for <feature or fix>.

No external publishing.

Return source facts to read, audience, required examples, forbidden claims,
reviewers, and publish gate.
```

### 质量加固

适用于风险闭环、边界测试、回归加固、静态分析、fuzzing、特性后的清理，或
发布就绪工作。

工作流：

```text
workflow-intake
-> quality-hardening plan
-> dispatch focused agents for risk areas
-> workflow-review
-> verification matrix update
```

示例提示词：

```text
Use workflow-intake for quality-hardening.

Workflow repository:
<path-to>/mysql_ai_workflow

Target repository:
current directory

Task:
Harden <component or feature> before handoff.

Current phase:
analysis and test planning only. No edits.

Return risk list, missing tests, verification matrix, candidate bounded tasks,
and stop conditions.
```

## 示例

- `examples/task-prompts/bugfix-issue.md`
- `examples/reports/agent-report.md`

## 安装

### 本机

安装 Codex skills：

```bash
./scripts/install_codex_skills.sh
```

安装 Claude Code slash commands：

```bash
./scripts/install_claude_commands.sh
```

### 其他机器

将本仓库 clone 或复制到新机器，然后在仓库根目录运行安装脚本：

```bash
git clone <repo-url> mysql_ai_workflow
cd mysql_ai_workflow
./scripts/install_codex_skills.sh
./scripts/install_claude_commands.sh
```

如果不是通过 Git 获取，而是直接复制目录，只要目录结构保持不变，安装脚本
同样可用。

安装后：

- Codex skills 安装到 `~/.codex/skills/`。
- Claude Code slash commands 安装到 `~/.claude/commands/`。
- 目标代码仓不需要 vendor 这个 workflow 仓库。

对于每个目标代码仓，只需要增加一个很薄的 Agent 入口文件，例如
`AGENTS.md` 或 `CLAUDE.md`，指向项目权威文件和本 workflow 仓库：

```md
# AI Agent Entry

Repository authority file: CLAUDE.md

Reusable workflow repository:
<path-to>/mysql_ai_workflow

All AI tasks must start with workflow-intake and must report:
- scenario
- scope
- allowed files
- forbidden files
- verification command
- code-edit permission
- commit policy

Code edits are denied unless the current human instruction explicitly grants
permission.
```

如果不同机器上的 workflow 仓库路径不同，可以选择：

- 每次在提示词里写明绝对路径；或
- 更新目标代码仓入口文件，让它指向本机路径；或
- 保持一个稳定软链接，例如 `~/Workflows/mysql_ai_workflow`。
