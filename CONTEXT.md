# Engineering workflow

The vocabulary for preserving an engineering workflow while changing the agent
runtime that carries it.

## Language

**Workflow distribution**:
The versioned combination of operating guidance, engineering tools, and
compatibility guarantees adopted together by an operator.
_Avoid_: runtime fork, plugin framework

**Harness**:
The agent runtime that carries a conversation and coordinates models and tools.
_Avoid_: workflow distribution

**Worker profile**:
An enforced set of capabilities granted to a delegated worker, independent of
what its task asks it to do.
_Avoid_: role prompt, tool suggestion

**Review snapshot**:
An immutable view of the exact work being assessed by independent reviewers.
_Avoid_: current working tree

**Diagnostic worker**:
A delegated reader of command evidence that explains outcomes without executing
commands or changing the work under diagnosis.
_Avoid_: command runner

**Capability contract**:
The required allowed and forbidden behaviors of a worker profile, including how
those guarantees survive changes in a conversation's lifecycle.
_Avoid_: tool-name list

**Project environment**:
The project-owned workspace identity, execution environment, and resource
provisioning in which engineering work is valid.
_Avoid_: arbitrary checkout

**Migration gate**:
An explicit decision, backed by evidence, to adopt a defined part of the new
workflow while retaining or retiring its predecessor.
_Avoid_: automatic cutover
