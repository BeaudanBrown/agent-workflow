# Working on agent-workflow

Read `README.md`, `CONTEXT.md`, `docs/architecture.md`, and the relevant issue
before making changes. This is a thin workflow distribution, not an agent runtime
fork. The bootstrap is not evidence of functional Haskell Agent/Pi parity.

## Scope and ownership

- Keep host activation and secrets in dotfiles; keep project-specific commands,
  databases, ports and worktree provisioning in the project repository.
- Prefer external CLI/MCP integration over imports of upstream orchestration
  internals. Native permission enforcement needs an explicit upstream contract.
- Do not represent prompts, skill `allowed-tools`, MCP hints, or advertised tool
  lists as enforced restrictions. Test the complete dispatch/capability surface.
- Do not automatically replace a project's worktree policy with `--worktree`.
- Do not silently install, migrate, overwrite, or symlink mutable user config,
  authentication, sessions or databases into the Nix store.
- Preserve source ownership and license notices when extracting shared tools.
- Do not create `.aloop.json` automatically. Automation policy is separately scoped.

## Tasks and reviews

GitHub Issues in `BeaudanBrown/agent-workflow` are authoritative. Use native
sub-issues and blocker relationships; see `docs/agents/issue-tracker.md`.
Inspect existing provenance markers before publishing a generated issue plan.
Labels and assignments are advisory, not execution locks. Never mutate an
unrelated repository implicitly.

Work one open, unblocked leaf at a time. Record acceptance evidence, commands,
limitations and a concise handoff before closing it. At epic completion, obtain
independent Standards and Spec reviews of the same pinned cumulative snapshot.
Findings must state severity and ownership: current issue, dependent issue,
deployment-only, or justified deferral.

## Verification

Canonical bootstrap gate: `nix flake check --no-update-lock-file`.
Fast feedback: `python3 scripts/check-docs.py .`, `nix fmt -- flake.nix`, and `git diff --check`.
See `docs/development.md` for the deliberate limitations of these checks.
Use focused tests before heavy runtime builds; do not claim an unrun live test.
Use project Nix entrypoints or ephemeral Nix tools, not global installations.
Do not start CI on a self-hosted runner without an explicit trust policy.

When Haskell code is introduced, prefer GHCi for iterative loading, strict `Text`
for retained application text, `Control.Exception.Safe`, and scoped structured
concurrency. Performance claims require representative optimized before/after
benchmarks, not interpreted timings.

## Runtime operations

Existing Pi managed-host controls remain owned by pi-harness. Use approval-gated
managed controls for agent-requested lifecycle mutations. Do not bypass missing
controls through shell commands, direct Matrix calls, or ad hoc tmux launches.
Never commit credentials, session transcripts, host state, or private task logs.
