# Staged Haskell Agent migration

## Purpose and authority

Preserve the strongest parts of the existing engineering workflow while adopting
Haskell Agent. Workflow quality and enforceable restrictions matter more than
matching command names.

The bootstrap repository and GitHub plan are authorized. This specification is a
plan, not blanket permission to implement every stage, deploy hosts, spend model
credits, publish upstream changes, or retire Pi. GitHub Issues hold execution
state; this document holds design requirements. Dependency-linked leaf issues
will carry concrete acceptance criteria and evidence.

## Non-negotiable constraints

- A separate distribution consumes pinned upstream; no permanent runtime fork
  by default. Dotfiles deploy a tested distribution rather than independently
  swapping its runtime revision.
- Keep GitHub and Git authoritative. No migration of task authority into the
  harness's memory database.
- Keep project environment and worktree provisioning project-owned. In Bepis,
  preserve `bin/in-env`, registered epic worktrees, ports and databases. Existing
  epic checkouts use `.bepis-epic-worktree.json` and
  `bash ./bin/in-env epic-worktree orient`.
- `bash ./bin/in-env verify-full` remains Bepis's canonical verification command;
  `verify-fast` supplies additional feedback, not a replacement gate.
- Do not substitute Haskell Agent's `--worktree` for Bepis provisioning. Launch
  from the intended existing checkout with the correct environment.
- Preserve the customized implementation and two-axis review skills and their
  evidence/handoff rules; do not replace them with similarly named defaults.
- Restricted roles must be enforced. Prompts, displayed schemas, skill metadata,
  MCP hints, and approval settings are not independent security enforcement.
- Keep Pi operational until the corresponding replacement passes its gate.

## Bootstrap (present scope)

Create the public repository, a locked skeleton flake, accurate documentation,
repository guidance and a native GitHub issue graph. The default command is
informational. Do not invent working modules, policy flags or profile support.
Local checks cover packaging/documentation only, not runtime parity.

## Stage A — usable everyday coding trial

### Packaged launcher and configuration ownership

Build a distinctly named opt-in launcher around the pinned upstream executable.
Preserve cwd, arguments, exit/signal behavior and the project execution
environment. Do not force `--yolo`, automatic worktrees, credentials or a global
configuration reset. Determine which configuration is declarative and which is
interactive/mutable before writing Home Manager integration. No wrapper should
rewrite the user's config on every invocation.

Expose only implemented outputs. Document setup, licensing/provenance, rollback
limitations and the selected supported platform. Keep dotfiles integration a
separate explicit handoff. Existing Pi operation must remain unaffected.

### Portable skills and project tools

Port shared/customized skills with validated discovery and metadata. Project
commands remain in their project, and shared workflow logic gets one owner.
Extract or reuse CLI/MCP tools without bringing in all of pi-harness. In
particular preserve typed, repository-scoped GitHub operations, native issue
relationships, idempotency, approval semantics, bounded outputs, and safe
artifact/path handling.

Architecture/observability scanners and Playwright project configuration remain
project-owned. Generic adapters may invoke them through the project environment.
OAuth-dependent web search is an explicit compatibility question, not an assumed
provider-independent feature.

### Trial gate

Exercise an ordinary coding task in the correct Bepis environment, including
skills, tool availability and canonical verification. Record which providers
and interfaces were exercised and the remaining gaps. A temporary deployment
requires separate operator consent. The outcome may be "use for everyday coding,
retain Pi for reviews, diagnostics and orchestration"; Stage A does not imply
restricted-worker parity.

## Stage B — restricted delegation and workflow parity

### Upstream capability contract

Specify a minimal provider-independent profile contract, the trust model and
complete lifecycle matrix. Discuss upstream acceptance before relying on native
integration. Contract tests use a deterministic fake model to attempt both
permitted and forbidden actions; absence of a tool in a model schema is not
sufficient proof of denial.

Cover final tool assembly and dispatch; MCP brokers and target allowlists;
provider-hosted/native tools; host extensions; nested delegation; resume,
follow-ups, model/dialect changes, cancellation and `--yolo`. Fail closed for an
unknown profile or an unavailable enforcement mechanism. Separate tool policy
from filesystem/process/network isolation claims.

If upstream declines, stop at an operator decision: maintain a bounded patch,
maintain a separate worker runtime, or retain Pi. Do not disguise a patch as a
stable extension. Work in this repository can prepare an upstream handoff, but
must not silently publish or change another repository.

### Independent reviews

Provide fresh independent Standards and Spec workers reviewing the same pinned
committed diff or captured uncommitted snapshot. Preserve scope, binary and
untracked-file treatment, provenance, restricted tool access, bounded resources,
separate reports, explicit failure and findings with severity/ownership. The
parent aggregates reports but cannot treat a missing axis as a successful review.
A prompt submitted to the main conversation is not equivalent.

### Command evidence and diagnostic workers

Preserve durable complete command logs, bounded excerpts, command deadlines,
exit/signal status, cancellation, a separately configured diagnostic model, and a
fallback when diagnosis is unavailable. The diagnostic worker reads evidence; it
does not execute the command or change the exit result. Artifact permissions and
retention must avoid exposing private logs through public GitHub comments.

### Semantic tooling

Check language-server support across the selected provider/dialect paths, not
only Grok. Document and resolve the required diagnostics, hover, definitions,
references, symbols, rename previews, completions and code-action coverage.
Keep project-local toolchain precedence and capability-aware fallbacks. A
navigation-only interface is not full semantic-tooling parity.

## Upgrade and adoption gate

Build a deterministic compatibility suite that verifies the actual shipped
launcher and effective worker policies, including allowed operations and denial
paths. Pin runtime revisions and record before/after capability results; successful
compilation alone does not prove permissions survived an upgrade.

After affected checks pass, run the explicitly approved live trial and a
cumulative independent Standards/Spec review against a pinned commit. Record
remaining deployment-only work, justified deferrals and operator acceptance.
Retire each Pi capability only after its own replacement is accepted. Rollback
of a package is not proof that migrated mutable state can be rolled back safely.

## Deferred workstreams (not epic completion requirements)

- **GitHub-native aloop:** separate bounded-supervisor migration preserving
  verification receipts, deadlines, recovery, handoffs and commit-specific
  approval. Do not regenerate `.aloop.json` or substitute an unbounded agent loop.
- **Managed Matrix sessions:** a separate integration retaining host authority,
  approval, tmux/session identity, lifecycle/recovery and transport contracts.
  Using existing managed Pi to work on this repository is not a migration of
  those mechanisms.
- **Pi history import, AgentGraph and Pi-R:** optional workstreams requiring
  explicit use cases and approval, not dependencies of everyday coding adoption.

## Reference implementations

The investigation inspected existing behavior rather than copying names:

- `pi-harness/config/agent/extensions/review-agents/`: restricted reviewers and
  pinned snapshot capture.
- `pi-harness/config/agent/extensions/worker-runner/`: command evidence and
  diagnostic delegation.
- `pi-harness/config/agent/extensions/github-issues/`: typed tracker operations.
- `pi-harness/config/mattpocock-skills/implement/SKILL.md` and
  `code-review/SKILL.md`: customized implementation/review workflow.
- `pi-harness/docs/github-aloop.md`: optional orchestration contract.
- Project-owned `AGENTS.md`, `bin/in-env`, `.pi/architecture.json`, observability
  and Playwright configuration: environment and tool behavior to preserve.

These are investigation references, not runtime dependencies. Reinspect the
selected source revision and licensing before extracting any implementation.
See [architecture evidence](architecture.md) for pinned upstream source links.
