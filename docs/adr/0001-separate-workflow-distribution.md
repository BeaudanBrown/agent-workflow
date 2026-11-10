# Keep the workflow distribution separate from the agent runtime

To preserve the existing engineering workflow while adopting Haskell Agent,
maintain `agent-workflow` as its own Git repository and Nix flake, consumed by
host dotfiles and consuming a pinned upstream runtime. Prefer skills and
external CLI/MCP tools over importing orchestration internals or maintaining a
long-lived customized runtime branch: this keeps upgrade coupling explicit and
workflow ownership independent of the harness.

Generic enforced child capabilities should be developed as focused upstream
contributions; profile meanings and workflow behavior stay here. If upstream
support is unavailable, retain Pi for those capabilities unless an operator
explicitly accepts a bounded patch or separately maintained worker runtime.
A separate repository reduces coupling but does not turn an internal adapter
into a stable SDK or make patches maintenance-free.
