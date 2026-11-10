# agent-workflow

A separately versioned engineering workflow distribution for
[Haskell Agent](https://github.com/digitallyinduced/haskell-agent), intended to
be consumed by a Nix dotfiles flake. Preserve the useful guarantees of the
existing Pi workflow without maintaining a personalized agent-runtime fork.

**Status: bootstrap only.** The flake pins upstream and provides documentation,
a safe information command, a development shell, and lightweight checks. It does
not yet install skills, add tools, enforce restricted workers, integrate with Home
Manager, or replace Pi. The explicit `upstream-agent` output is the unmodified
upstream runtime, not the planned workflow distribution.

## Start here

```sh
nix run .                         # Prints bootstrap status; starts no agent
nix develop                       # Small packaging/documentation environment
nix fmt -- flake.nix
nix flake check --no-update-lock-file
```

The initial packaging target is **x86_64-linux**. Other upstream platforms are
not yet supported or tested by this distribution. The checks do not build or run
Haskell Agent, contact an LLM, authenticate to a provider, or mutate a host.

For an explicitly requested raw-runtime experiment:

```sh
nix run .#upstream-agent -- --help
```

This may download or build a substantial upstream runtime. It has ordinary
upstream capabilities and configuration behavior: **no additional permission
restrictions are supplied here**. No runtime smoke test is claimed by bootstrap
checks. Review upstream cache trust separately; this flake does not automatically
add a binary cache or trusted key.

## Ownership

```text
nix-dotfiles (host/user deployment)
  -> agent-workflow (tested distribution, tools, skills and compatibility checks)
       -> haskell-agent (pinned upstream runtime)

project repositories -> their own commands, environments and worktree policy
pi-harness           -> existing Pi deployment during the staged migration
```

This is the intended dependency direction, not a claim that deployment modules
already exist. MCP and external commands are the initial integration seam.
Native capability enforcement belongs upstream; exposed Haskell modules are not
a promise of a stable third-party SDK.

## Documentation

- [Architecture and ownership](docs/architecture.md)
- [Migration specification](docs/plan.md)
- [Development and verification](docs/development.md)
- [Deployment and upgrades](docs/deployment.md)
- [Terminology](CONTEXT.md)
- [Decision: separate workflow distribution](docs/adr/0001-separate-workflow-distribution.md)
- [GitHub issue conventions](docs/agents/issue-tracker.md)

[GitHub Issues](https://github.com/BeaudanBrown/agent-workflow/issues) and Git are
the durable work record. Documentation describes the design, not a second task
queue. Creating this repository and its plan does not authorize host deployment,
retiring Pi, paid model runs, or publishing changes to upstream repositories.

No project license has been selected yet. Public visibility alone is not a
license grant; preserve licensing and provenance when extracting third-party
skills or tools.
