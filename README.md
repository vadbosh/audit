# audit

A skill for auditing code: **correctness on unexpected input, documentation
against the code, cost by measurement, decisions worth questioning**. The object
is something already written and in use — a tool, a script, a configuration
tree, a set of documents. Findings go to one file,
`review-YYYY-MM-DD-<object>.md`, at the project root.

What it is **not**: a vulnerability scan, a style pass, a review of a diff. Four
questions, in this order:

1. **Does it do what it promises?** Fed the inputs its author did not have in
   mind — another syntax, a value crossing a line break, a limit reached — does
   it still answer correctly, or does it answer wrongly and say nothing?
2. **Does its documentation describe the code that is there?** A README
   promising a behaviour the code lost two releases ago is worse than no README:
   it is what somebody checks before deciding not to look further.
3. **What does it cost, measured?** Not "could be faster" — a number a command
   printed, and the size at which that number starts to hurt.
4. **Which of its decisions are worth questioning?** Named as proposals for the
   author, never as tasks.

Every finding carries the command that reproduces it, run on the broken input.
A finding without one is a guess, and guesses are cheap to write and expensive
to read.

The skill fixes nothing. Reviewing and repairing are different jobs: a pass that
stops to fix its first finding stops looking for the rest, and never reaches a
third one.

```
you:    /audit bin/mytool
skill:  Using audit on bin/mytool — findings go to review-2026-09-18-mytool.md
        … baseline, probes, reproductions …
        A: 7, B: 3, C: 4, D: 4 open questions. Nothing was fixed.
```

## When `audit`, and when a diff reviewer

| Situation | Use |
|---|---|
| a pull request, a branch to merge, a diff | whatever reviews diffs in your assistant — those tools take the changed lines as their input |
| a tool, a script, a config tree, a document set on disk | the `audit` skill |

A diff reviewer compares what a change became against what it replaced, which
is a different question from whether the thing works at all. It also has no
input when nothing has changed — the ordinary state of a tool somebody wrote
once and has used ever since.

**`audit` runs in one session and spawns no subagents.** Diff reviewers usually
split the work across parallel agents; this one does not, because every spawn
loads its context from nothing. If the object is big enough that a pass would
need parallel agents, the skill reviews one part of it and says which part in
its opening line.

## What a pass produces

One Markdown file, in sections named after consequences rather than topics:

| Section | The question |
|---|---|
| **A. Defects** | what does the wrong thing — each with the command that reproduces it, a class (silent wrong result / visible failure / damage), the blast radius of the fix, and which test closes it |
| **B. Documentation** | where the text and the code disagree |
| **C. Efficiency** | what costs too much — only with a number a command printed |
| **D. Judgement** | what is right and must stay, what is arguable; proposals, not tasks |
| **What is NOT a defect** | examined and found correct, so the next reader does not spend the time again |
| **Done when** | acceptance commands, each with the exit status it should have |

Plus the two things that make it executable rather than informative: the
**invariants** a fix may not break, quoted from what the project says about
itself, and a **fix order** saying which items share a code path and what stays
open while the rest land.

## The rules it holds itself to

- **Reproduce before claiming.** No command, no finding.
- **Run it on the broken input.** A check never executed against the failure it
  describes has not been checked.
- **A quote from documentation is a hypothesis.** Where a finding's severity
  rests on how a host or runtime behaves, that behaviour is shown on this
  machine or the item says it is unverified.
- **Read verdicts from the exit status.** A session runs inside hooks and
  wrappers that rewrite output; when the object is the same kind of thing, the
  screen proves nothing.
- **Sandbox from `mktemp -d`, delete nothing.** Every iteration is clean because
  it is new, so no probe script ever needs an `rm`.
- **Stay inside the project.** Another project on this machine is not evidence
  about this one.
- **One object per pass**, and past roughly 600 lines of code, split it along a
  seam that already exists — implementation and port, library and driver.

## Install

```bash
git clone <this repository> audit && cd audit
./install.sh                 # every assistant found: Claude Code, Opencode, Codex
./install.sh --dry-run       # print what would happen, change nothing
./install.sh --skills-dir D  # install into D instead of auto-detecting
```

Windows: `.\install.ps1`, same flags.

The skill is three Markdown files. There is no binary, nothing goes on `PATH`,
and nothing outside `$HOME` is touched. Re-running replaces only what changed; a
file it overwrites is backed up only when that exact content is not already in
this repository — a hand edit is the one thing git cannot give back.

Uninstall: delete `<skills-dir>/audit`.

## Layout

```
skills/audit/SKILL.md              the pass itself — what to do, in what order
skills/audit/references/
    template.md                    the skeleton of the review file, slot by slot
    domains.md                     shapes that keep being missed, per domain
install.sh / install.ps1           copy into each assistant's skills directory
release.sh                         version ↔ changelog ↔ tag ↔ HEAD ↔ copies
CHANGELOG.md                       what changed in each version
```

The two reference pages load **on demand** — `template.md` when the file is
being written, `domains.md` only when the object is one of the kinds it covers.
An ordinary pass pays for neither.

## Releasing

```bash
./release.sh check     # version ↔ changelog ↔ tag ↔ HEAD ↔ installed copies
./release.sh tag       # create the tag, carrying the changelog section
```

`check` compares every installed copy against the source **file by file**, asking
the source what it ships rather than trusting a list written by hand.

## Russian

[README.RU.md](README.RU.md).
