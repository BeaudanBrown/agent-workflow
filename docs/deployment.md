# Deployment and upgrades

## Current outputs

The bootstrap exports, for `x86_64-linux` only:

| Output | Behavior |
| --- | --- |
| `packages.default`, `packages.info`, `apps.default` | Print bootstrap status; do not launch an agent |
| `packages.resources` | Documentation under `share/agent-workflow` |
| `packages.upstream-agent`, `apps.upstream-agent` | Explicit unmodified upstream runtime; no added workflow policy |
| `devShells.default` | Git, GitHub CLI, Python and the Nix formatter |
| `checks.*`, `formatter.*` | Lightweight repository verification |

There is no Home Manager or NixOS module yet. Do not try to import an imagined
`homeManagerModules.default` or `nixosModules.default`. The Stage A launcher and
configuration issue will introduce real, tested interfaces.

## Intended deployment model

The host dotfiles add `github:BeaudanBrown/agent-workflow` as a pinned flake input
and enable the selected user/package integration after explicit approval.
The distribution owns the Haskell Agent input and its tested revision. Its small
packaging environment follows upstream's Nixpkgs input; consumers should not
silently override that dependency or force the runtime onto a different compiler
package set.

Host users, paths, service policy and secrets remain dotfiles-owned. Keep
credentials, auth state, sessions and databases outside source control and Nix
store resources. Decide which settings are declarative and which are user-editable
before managing `~/.haskell-agent/config.json`; the runtime writes settings too.
Never symlink the entire runtime state directory into the immutable store or
rewrite configuration on every launch.

Launch in the project's existing environment. Preserve Bepis worktree registration
and provisioning rather than substituting upstream automatic worktrees. Keep Pi
installed throughout the trial; selecting a new executable does not retire its
predecessor or migrate its managed Matrix sessions.

## Updating upstream

1. Start from a clean branch and record the current pin and baseline evidence.
2. Run `nix flake update haskell-agent`; review all transitive lock changes.
3. Run the canonical gate and, once implemented, the effective capability-contract
   suite. Reinspect changed runtime seams; a successful build is not a permission
   regression test.
4. Run any explicitly approved live smoke/trial checks. Record failures and
   unsupported provider paths instead of silently weakening profiles.
5. Commit and publish a tested distribution revision, then separately update the
   dotfiles input. Do not implicitly activate a host or restart sessions.

Today the gate proves only bootstrap integrity. It is insufficient evidence to
promote a runtime update as compatible with future worker policies.

## Rollback and temporary patches

Keep a known-good distribution pin and the existing Pi workflow available.
Restoring a package version does not undo runtime database or session migrations;
verify state compatibility and backup requirements before a live upgrade.

If missing upstream support requires a patch, record its owner, exact base,
regression tests, upstream proposal and removal condition. An operator must
accept that maintenance burden explicitly. Do not quietly turn this distribution
into a permanently divergent runtime branch.
