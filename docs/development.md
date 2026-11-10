# Development and verification

## Current gate

```sh
nix develop
nix fmt -- flake.nix
python3 scripts/check-docs.py .
python3 -m unittest discover -s tests
nix flake check --no-update-lock-file
git diff --check
```

Stage new files with Git before flake commands: Git-backed flakes do not include
untracked files. Inspect staged contents before committing; never stage secrets
or private runtime artifacts.

The canonical bootstrap gate is `nix flake check --no-update-lock-file`:

- `docs` checks repository-relative inline Markdown links and tests the checker.
  It does not validate remote URLs, heading anchors or reference-style links.
- `format` checks the flake with the pinned Nix formatter.
- `smoke` runs only the informational default executable.

Flake evaluation also checks output structure. No check builds or launches the
upstream agent, contacts model providers, creates GitHub issues, mutates user
configuration, starts host services or proves worker isolation. Add behavioral
checks with each implementation issue rather than expanding claims about this
gate. `nix run .#upstream-agent` is an explicit, potentially substantial runtime
build, not a lightweight verification command.

## Layout

- `flake.nix` / `flake.lock`: reproducible inputs and initial outputs.
- `scripts/`, `tests/`: lightweight repository checks.
- `docs/`: architecture, migration requirements and deployment guidance.
- `CONTEXT.md`: domain glossary only.
- `AGENTS.md`: contributor/agent constraints.

Create `skills/`, `tools/`, `adapters/haskell-agent/`, and `nix/modules/` when their
first real implementation lands; do not add fake tools or empty module exports.

## Evidence for implementation work

Map each acceptance criterion to an executable test or explicitly recorded live
check. Use fake models and fake external servers for deterministic capability
and error-path tests. Keep subjective review independent from test execution and
pin both review axes to the same commit/snapshot. Preserve full noisy check logs
outside Git and publish only concise, non-sensitive summaries.

No CI workflow or self-hosted runner is configured by this bootstrap. Adding CI
requires a deliberate execution/secret trust model; never assume public fork
pull requests should run on a personal host. No automatic aloop verification
policy is created.

## Initial bootstrap verification

See the bootstrap issue's handoff for the actual commands and results. A
successful skeleton check is not a runtime smoke check or authorization to
proceed to deployment.
