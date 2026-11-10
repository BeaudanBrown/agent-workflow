# Architecture and ownership

## Decision and current implementation

[ADR 0001](adr/0001-separate-workflow-distribution.md) records the choice of a
separate workflow distribution instead of a long-lived Haskell Agent branch.

Implemented at bootstrap: a pinned upstream flake, a harmless information
command, documentation resources, a small development environment, and local
checks. Everything below that describes workers or deployed integrations is a
**target design**, not a present security guarantee.

## Dependency direction

A host's dotfiles select a tested revision of this distribution. This distribution
selects an upstream Haskell Agent revision. Project repositories retain their
own tools and environment contracts. There is no reverse runtime dependency on
this repository, no copied agent source tree, and no dependency on all of
pi-harness just to reuse one tool.

| Owner | Responsibility |
| --- | --- |
| agent-workflow | Shared skills, workflow tools, configuration integration, capability-contract tests and upgrade evidence |
| Haskell Agent | Providers, conversation lifecycle, tool dispatch, child lifecycle, generic capability enforcement |
| Dotfiles | Host/user enablement, credentials, service policy and host-specific paths |
| Project repository | Verification, worktrees, ports, databases, architecture scanners and observability semantics |
| pi-harness | Existing Pi operation and capabilities not yet migrated |

## Integration seams

1. **External commands / MCP first.** Package reusable tool logic once and expose
   it through narrow adapters. Reuse TypeScript where sensible; a migration does
   not justify rewriting every tool in Haskell.
2. **Skills as resources.** Use harness-neutral guidance where possible. Preserve
   the customized implementation and Standards/Spec review workflow, not merely
   upstream skill names. Resolve discovery roots and metadata validation against
   the pinned runtime.
3. **Native profiles only with enforcement.** Profile definitions belong here;
   the generic integration with child creation, dispatch and lifecycle belongs
   upstream. A focused upstream contribution branch is reasonable. A permanent
   personal runtime fork is not the default architecture.
4. **Compiled adapter only by explicit decision.** Upstream's packaged Haskell
   libraries and embedding hooks are possible seams, not a stable SDK promise.
   If external integration is insufficient, document the maintenance cost and
   use one matching upstream Haskell package set rather than mixing package
   databases or copying orchestration code.

## Capability and isolation requirements

The eventual contract must constrain the effective capability set at execution,
not just the schema shown to a model. Cover local tools, direct dispatch, MCP
brokers and their targets, provider-hosted tools, host extensions, collaboration,
resume, follow-ups, model/dialect changes, nested delegation and `--yolo`.

- Reviewer: read the pinned review snapshot; no command execution, writes,
  tracker mutations, push/fetch, or nested delegation.
- Diagnostic worker: read bounded command evidence and permitted source; no
  command execution or mutation. Diagnosis cannot change an authoritative exit
  status.
- Implementation worker: explicit coding capabilities and selected integrations;
  do not inherit unrestricted coordinator authority accidentally.
- Coordinator: typed workflow operations, not unrestricted engineering tools.

These are desired profiles, **not implemented configuration**. MCP's read-only
hints and skill metadata are not permissions. Tool allowlisting also is not OS
isolation: trusted native handlers can perform arbitrary IO. Stronger filesystem,
process and network containment requires its own scoped design and tests.

## Persistent state

GitHub issues, native relationships, handoff comments and Git history are the
work record. Do not introduce a competing task database. Runtime sessions,
credentials and databases remain mutable outside Nix resources. Artifact storage
must have bounded retention and distinguish public handoff evidence from private
logs or source material.

## Evidence and limitations

The initial investigation inspected Haskell Agent revision
[`907e57d96cd0b327d4aeb0811de0a2f8252df95c`](https://github.com/digitallyinduced/haskell-agent/tree/907e57d96cd0b327d4aeb0811de0a2f8252df95c).
The lock file records the actually selected runtime revision; re-inspect these
seams when upgrading. Relevant source evidence at the investigated revision:

- [`flake.nix`](https://github.com/digitallyinduced/haskell-agent/blob/907e57d96cd0b327d4aeb0811de0a2f8252df95c/flake.nix): executable and Haskell package-set exports.
- [`Agent.Runtime.Host`](https://github.com/digitallyinduced/haskell-agent/blob/907e57d96cd0b327d4aeb0811de0a2f8252df95c/packages/agent-runtime/src/Agent/Runtime/Host.hs): composition hooks and separate runtime capabilities.
- [`Agent.Tools.Types`](https://github.com/digitallyinduced/haskell-agent/blob/907e57d96cd0b327d4aeb0811de0a2f8252df95c/packages/agent-core/src/Agent/Tools/Types.hs): application tools and registry construction.
- [`Agent.CLI.Subagents.Runtime`](https://github.com/digitallyinduced/haskell-agent/blob/907e57d96cd0b327d4aeb0811de0a2f8252df95c/packages/agent-cli/src/Agent/CLI/Subagents/Runtime.hs): child composition paths.
- [`Agent.GrokBuild.Dialect.Task`](https://github.com/digitallyinduced/haskell-agent/blob/907e57d96cd0b327d4aeb0811de0a2f8252df95c/packages/agent-grok-build-dialect/src/Agent/GrokBuild/Dialect/Task.hs): existing dialect-specific filters, not a general capability sandbox.
- [`docs/mcp.md`](https://github.com/digitallyinduced/haskell-agent/blob/907e57d96cd0b327d4aeb0811de0a2f8252df95c/docs/mcp.md): external tool integration.

No general provider-independent configurable child-profile contract or documented
stable third-party SDK commitment was established by the investigation. Native
`/review`, output artifacts, and language-server support are not equivalent by
name alone to Pi's independent reviewers, diagnostic runner, or LSP surface.
This assessment used source inspection, not live compatibility tests.
