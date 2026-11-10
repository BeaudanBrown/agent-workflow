# Issue tracker: GitHub

GitHub Issues in [BeaudanBrown/agent-workflow](https://github.com/BeaudanBrown/agent-workflow/issues)
are the only durable task queue. Git history and issue handoffs hold implementation
evidence. The migration specification in `docs/plan.md` records requirements,
not mirrored issue state. [Epic #1](https://github.com/BeaudanBrown/agent-workflow/issues/1)
owns the core migration; [#17](https://github.com/BeaudanBrown/agent-workflow/issues/17)
parks optional work outside its completion graph.

- Use native GitHub sub-issues for epic membership and native dependencies for
  blockers. Body-text lists are navigation, not relationship authority.
- Select an open, unblocked leaf; `ready-for-agent` is a prioritization hint, not
  an execution lock. Assignments also are advisory.
- Apply one lifecycle label at a time: `needs-triage`, `needs-info`,
  `ready-for-agent`, `ready-for-human`, or `wontfix`. Category/phase labels are
  independent of lifecycle state.
- Blocked work is not ready merely because its description is detailed.
- Generated bootstrap issues use a stable hidden marker:
  `agent-workflow-plan:haskell-agent-migration-v1/<issue-key>`.
  Inspect the exact marker before retrying publication; do not duplicate issues
  after uncertain external writes. Preserve later human edits.
- Before closing a leaf, record criteria/evidence, exact verification commands,
  limitations and the next handoff. At epic closure, include a cumulative pinned
  independent Standards/Spec review and explicit adoption decisions.
- Cross-repository work is a handoff here until publishing or changing the other
  repository is separately authorized. Do not mutate upstream or dotfiles just
  because this epic refers to them.

From a checkout of this repository, use the harness's current-repository typed
GitHub tools when available. If a session is attached to another checkout, do
not pass this repository to a tool scoped to that other checkout. For authorized
bootstrap operations without a correctly scoped typed tool, the GitHub CLI must
explicitly target `BeaudanBrown/agent-workflow` and verify the remote first.
