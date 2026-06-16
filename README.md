# AI Workflows

This repository defines an agent-neutral workflow system for daily software
development. It is intentionally not tied to Codex, Claude Code, Cursor, or any
single automation platform or project.

Each project should define its own repository entrypoint and authority file.
This repository provides the reusable workflow layer: it describes how different
classes of work should move from intake to delivery.

## 中文说明

这个仓库是一个通用的 AI 研发工作流仓库，用来沉淀日常软件开发中
AI Agent 的协作方式。它不绑定 Codex、Claude Code、Cursor 或某一个
具体项目。

推荐使用方式是：

- 业务代码仓只保存本仓库事实，例如项目背景、构建方式、测试命令、
  当前特性目标。
- `mysql_ai_workflow` 保存通用方法，例如任务准入、任务拆分、Agent
  派发、代码检视、夜间任务、自测试、文档交付等。
- 在任何目标代码仓工作时，先让 AI 读取本仓库的 workflow，再读取目标
  代码仓自己的 `AGENTS.md`、`CLAUDE.md` 或其他权威上下文文件。
- 默认不允许 AI 修改代码。只有当前人工指令明确授权编辑时，AI 才能在
  指定文件范围内修改。

## Design Principles

- Keep workflow assets agent-neutral. Tool-specific behavior belongs in
  `adapters/`.
- Use file-based handoff between agents: task documents, patches, reports,
  logs, and verification results.
- Keep implementation work bounded by explicit allowed and forbidden files.
- Let the orchestrator own cross-layer decisions, integration, review, and
  commits.
- Treat night work as draft-producing by default. Night agents may produce
  reports, patches, classifications, and test results, but should not merge
  changes without explicit approval.
- Prefer small, reviewable tasks over broad autonomous edits.

Adapters must follow `adapters/contracts.md`. Tool-specific files can add
mechanics, but cannot weaken common workflow rules.

中文原则：

- workflow 必须保持工具无关，Codex、Claude Code、Cursor 的差异放在
  `adapters/` 中。
- Agent 之间通过文件交接，例如任务说明、patch、报告、日志、验证结果。
- 代码修改必须受 `allowed files` 和 `forbidden files` 约束。
- Orchestrator 负责人机协同、跨模块判断、集成、检视和提交。
- 夜间任务默认只产出草稿、报告、patch、分类和测试结果，不自动合入。
- 优先拆成小任务，避免大范围自动修改。

## Directory Layout

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

## How To Choose A Workflow

- New feature: use `scenarios/feature-development.md`.
- Performance work: use `scenarios/performance-optimization.md`.
- Customer issue or bugfix: use `scenarios/bugfix-issue.md`.
- Test suite migration: use `scenarios/test-suite-migration.md`.
- External-facing docs or release notes: use `scenarios/external-docs.md`.
- Risk closure, stability, or regression hardening: use
  `scenarios/quality-hardening.md`.

For feature-specific work, also read that feature's task board and phase
documents. Feature-specific documents may add stricter rules, but should not
replace the common workflow layer.

For domain-specific work, also read the matching profile under `profiles/`.

中文选择规则：

- 新需求/新特性开发：使用 `scenarios/feature-development.md`。
- 性能优化：使用 `scenarios/performance-optimization.md`。
- 问题单、缺陷修复、线上问题：使用 `scenarios/bugfix-issue.md`。
- 测试迁移：使用 `scenarios/test-suite-migration.md`。
- 客户文档、发布说明、外部说明：使用 `scenarios/external-docs.md`。
- 质量加固、稳定性、回归补强：使用 `scenarios/quality-hardening.md`。

如果是某个具体特性的开发，还要读取该特性自己的任务板、阶段文档和设计
文档。如果是特定领域，例如数据库内核，还要读取 `profiles/` 下对应领域
的 profile。

## Typical Usage Patterns

Use this repository as the reusable workflow layer. Work starts in the target
code repository, while this repository supplies the task classification,
handoff templates, review gates, and tool adapters.

Every task should start with intake:

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

中文通用入口：

在任意目标代码仓中启动 Codex 或 Claude Code 后，先使用如下提示词：

```text
使用通用 workflow 仓库：
<path-to>/mysql_ai_workflow

先执行 workflow-intake。当前阶段不允许编辑文件。

目标代码仓：
当前目录

任务：
<描述问题单、新需求、自测试、性能优化、测试迁移、文档或质量加固任务>

请返回：
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

### Issue Fix

Use for customer issues, internal bug reports, failing tests, wrong results,
crashes, regressions, or production incidents.

Workflow:

```text
workflow-intake
-> reproduce and collect evidence
-> workflow-dispatch Code Agent
-> workflow-review
-> human integration or commit
```

Example prompt:

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

中文用法：

适用于客户问题、内部问题单、失败测试、错误结果、crash、回归问题或线上
事故。

流程：

```text
workflow-intake
-> 复现问题并收集证据
-> workflow-dispatch 派发 Code Agent
-> workflow-review 检视 patch
-> 人工集成或提交
```

示例提示词：

```text
使用 workflow-intake 和 workflow-dispatch。

Workflow 仓库：
<path-to>/mysql_ai_workflow

目标代码仓：
当前目录

场景：
bugfix-issue

问题：
<失败命令、错误信息、客户现象或错误结果>

当前阶段：
只做 intake，不允许编辑。

intake 通过后，再创建一个有边界的 Code Agent 任务，必须包含：
- 明确允许编辑的文件
- 明确禁止编辑的文件
- 验证命令
- patch 输出路径
- 不允许 commit
```

### New Feature Development

Use for new behavior, new syntax, new APIs, optimizer or execution changes,
storage behavior, compatibility work, or larger multi-phase implementation.

Workflow:

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

Example prompt:

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

中文用法：

适用于新行为、新语法、新 API、优化器/执行器改动、存储行为、兼容性工作
或多阶段大需求。

流程：

```text
workflow-intake
-> 设计任务
-> 设计检视
-> 拆成有边界的实现任务
-> 串行或并行 workflow-dispatch
-> 每个 patch 做 workflow-review
-> 集成验证
-> 文档和复盘
```

示例提示词：

```text
使用 workflow-intake 处理一个新需求。

Workflow 仓库：
<path-to>/mysql_ai_workflow

目标代码仓：
当前目录

需求：
<描述需求和期望行为>

当前阶段：
只做设计，不允许代码编辑。

请输出：
- scenario: feature-development
- 设计问题
- 影响模块
- 必要测试
- 风险点
- 建议任务拆分
- 是否适合并行 Agent
```

### Self-Test And Verification

Use for self-testing before handoff, regression validation, reproducing a
failure, checking a patch, or building confidence before review.

Workflow:

```text
workflow-intake
-> identify authoritative test commands
-> run scoped verification
-> workflow-review if a patch or report exists
-> record gaps and owner decisions
```

Example prompt:

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

中文用法：

适用于交付前自测试、回归验证、复现失败、检查 patch，或在检视前建立证据。

流程：

```text
workflow-intake
-> 识别权威测试命令
-> 运行有边界的验证
-> 如果已有 patch 或报告，则执行 workflow-review
-> 记录验证缺口和 owner 决策
```

示例提示词：

```text
使用 workflow-intake 做自测试。

Workflow 仓库：
<path-to>/mysql_ai_workflow

目标代码仓：
当前目录

任务：
检视前验证当前工作区。

不允许代码编辑。

请：
- 读取代码仓权威上下文文件
- 识别必须运行的验证命令
- 只运行约定范围内的测试
- 报告通过/失败输出
- 列出验证缺口
- 不允许 commit
```

### Performance Optimization

Use for latency, throughput, CPU, memory, lock contention, plan quality, IO, or
benchmark regressions.

Workflow:

```text
workflow-intake
-> baseline benchmark
-> hypothesis and profiling tasks
-> bounded optimization patch
-> before/after benchmark comparison
-> workflow-review
```

Example prompt:

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

中文用法：

适用于延迟、吞吐、CPU、内存、锁竞争、执行计划质量、IO 或 benchmark 回归
问题。

流程：

```text
workflow-intake
-> baseline benchmark
-> 假设分析和 profiling 任务
-> 有边界的优化 patch
-> 优化前后 benchmark 对比
-> workflow-review
```

示例提示词：

```text
使用 workflow-intake 处理性能优化。

Workflow 仓库：
<path-to>/mysql_ai_workflow

目标代码仓：
当前目录

问题：
<benchmark、query、workload、flamegraph 或回归证据>

当前阶段：
只做分析，不允许编辑。

请输出 baseline 命令、可疑组件、profiling 计划、风险点，以及最小安全
下一步任务。
```

### Test Migration

Use for moving tests between frameworks, stabilizing flaky tests, splitting
large test suites, or adding coverage for migrated behavior.

Workflow:

```text
workflow-intake
-> test-suite-migration plan
-> migrate a bounded batch
-> run old and new verification where practical
-> workflow-review
```

Example prompt:

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

中文用法：

适用于测试框架迁移、flaky test 稳定性治理、拆分大型测试套件，或为迁移后
行为补充覆盖。

流程：

```text
workflow-intake
-> test-suite-migration 计划
-> 迁移一个有边界的批次
-> 在可行时同时运行新旧验证
-> workflow-review
```

示例提示词：

```text
使用 workflow-intake 处理测试迁移。

Workflow 仓库：
<path-to>/mysql_ai_workflow

目标代码仓：
当前目录

任务：
将 <test group> 从 <old framework> 迁移到 <new framework>。

当前阶段：
只做规划，不允许编辑。

请返回迁移范围、文件清单、等价性检查、禁止修改区域和验证命令。
```

### Documentation

Use for customer-facing docs, release notes, design notes, runbooks, upgrade
notes, or internal engineering handoff.

Workflow:

```text
workflow-intake
-> external-docs or feature-development docs task
-> Docs Agent draft
-> workflow-review
-> human publish approval
```

Example prompt:

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

中文用法：

适用于客户文档、发布说明、设计说明、运行手册、升级说明或内部工程交接。

流程：

```text
workflow-intake
-> external-docs 或 feature-development docs task
-> Docs Agent 起草
-> workflow-review
-> 人工确认后发布
```

示例提示词：

```text
使用 workflow-intake 处理外部文档。

Workflow 仓库：
<path-to>/mysql_ai_workflow

目标代码仓：
当前目录

任务：
为 <feature or fix> 起草客户可见文档。

不允许外部发布。

请返回需要读取的事实来源、目标读者、必要示例、禁止声明、reviewer 和发布
门禁。
```

### Quality Hardening

Use for risk closure, boundary tests, regression hardening, static analysis,
fuzzing, cleanup after a feature, or release-readiness work.

Workflow:

```text
workflow-intake
-> quality-hardening plan
-> dispatch focused agents for risk areas
-> workflow-review
-> verification matrix update
```

Example prompt:

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

中文用法：

适用于风险闭环、边界测试、回归加固、静态分析、fuzzing、特性收尾清理或
发布前质量准备。

流程：

```text
workflow-intake
-> quality-hardening 计划
-> 针对风险区域派发聚焦 Agent
-> workflow-review
-> 更新验证矩阵
```

示例提示词：

```text
使用 workflow-intake 处理质量加固。

Workflow 仓库：
<path-to>/mysql_ai_workflow

目标代码仓：
当前目录

任务：
交付前加固 <component or feature>。

当前阶段：
只做分析和测试规划，不允许编辑。

请返回风险列表、缺失测试、验证矩阵、候选有边界任务和停止条件。
```

## Examples

- `examples/task-prompts/bugfix-issue.md`
- `examples/reports/agent-report.md`

## Installation

### Local Machine

Install Codex skills:

```bash
./scripts/install_codex_skills.sh
```

Install Claude Code slash commands:

```bash
./scripts/install_claude_commands.sh
```

中文说明：

在本机安装后：

- Codex 可以通过已安装的 skills 使用 `workflow-intake`、
  `workflow-dispatch`、`workflow-review`、`workflow-night-run`。
- Claude Code 可以通过 slash commands 使用 `/workflow-intake`、
  `/workflow-dispatch`、`/workflow-review`、`/workflow-night-run`。
- 目标代码仓不需要复制整套 workflow，只需要在提示词或入口文件中指向
  本仓库路径。

### Another Machine

Clone or copy this repository to the new machine, then run the install scripts
from the repository root:

```bash
git clone <repo-url> mysql_ai_workflow
cd mysql_ai_workflow
./scripts/install_codex_skills.sh
./scripts/install_claude_commands.sh
```

If the repository is copied without Git, the same install scripts still work as
long as the directory layout is preserved.

After installation:

- Codex skills are installed under `~/.codex/skills/`.
- Claude Code slash commands are installed under `~/.claude/commands/`.
- Target code repositories do not need to vendor this workflow repository.

For each target repository, add only a small agent entrypoint such as
`AGENTS.md` or `CLAUDE.md` that points to the project authority file and this
workflow repository:

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

On machines where the workflow repository path differs, either:

- mention the absolute path in each prompt, or
- update the target repository entrypoint to point to the local path, or
- keep a stable symlink such as `~/Workflows/mysql_ai_workflow`.

中文说明：

在其他机器上使用时，推荐把这个仓库作为独立仓库 clone 或复制过去，然后在
新机器执行安装脚本：

```bash
git clone <repo-url> mysql_ai_workflow
cd mysql_ai_workflow
./scripts/install_codex_skills.sh
./scripts/install_claude_commands.sh
```

如果没有 Git，也可以直接复制整个目录，只要目录结构不变即可。

安装完成后：

- Codex skills 位于 `~/.codex/skills/`。
- Claude Code commands 位于 `~/.claude/commands/`。
- 每个目标代码仓只需要一个轻量入口文件，例如 `AGENTS.md` 或
  `CLAUDE.md`。
- 入口文件负责说明本仓库的权威上下文文件，以及
  `mysql_ai_workflow` 在当前机器上的路径。

如果不同机器上的路径不一致，可以选择：

- 每次提示词中写明绝对路径；
- 修改目标仓的 `AGENTS.md` 或 `CLAUDE.md` 指向当前机器路径；
- 使用稳定软链接，例如 `~/Workflows/mysql_ai_workflow`。
