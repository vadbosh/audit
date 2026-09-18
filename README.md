# audit

A skill for auditing code: **correctness on unexpected input, documentation
against the code, cost by measurement, decisions worth questioning**. The object
is something already written and in use — a tool, a script, a configuration
tree, a set of documents. Findings go to one file,
`review-YYYY-MM-DD-<object>.md`, at the project root.

What it is **not**: a vulnerability scan, a style pass, a review of a diff. Four
questions, in this order:

1. **Does it work on what its author did not expect?**
   The author tested the inputs they had in mind, and on those it is fine. The
   audit hands it others: a key written in JSON rather than after an `=`; a
   password with an `@` in the middle; a value split across a line break; a file
   ten times the usual size. Then it looks at the result — is the answer still
   right, or is it wrong with nothing said about it.

2. **Does the documentation match the code?**
   The README promises that the label `Authorization: Bearer` is recognised. The
   code has no such label and never fires on it. That is worse than a README
   saying nothing: somebody read it, believed it, and decided to look no
   further. The audit reads the documentation and checks each promise with a
   command.

3. **What does it cost, and at what size does it stop working?**
   Not "could be faster" — seconds and bytes printed by a command. A real case:
   a redactor spent 5.6 seconds per megabyte, and the system kills the hook that
   calls it after 10 seconds. So everything over two megabytes reached the
   reader unmasked. Cost on its own is a remark; cost past the point where the
   work stops happening is a defect.

4. **Which decisions are worth discussing?**
   These are not defects: the code does exactly what it was meant to — the
   intent is what is arguable. Say the tool lists the commands allowed to read
   secret files, and everything else passes unquestioned. Or the list of labels
   like `password` and `token` is fixed, and a new one is added only after
   something leaked. The author pays for such a choice and knows why it ended up
   that way. So these arrive as proposals with the price named, and the author
   decides.

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

## When you run it

You do, by hand, when you decide to. The skill watches no repository, runs on no
schedule and reminds you of nothing. The occasions it actually gets called for:

- **you are picking up a tool** — somebody else's, or your own from a year ago —
  and do not know what in it to trust;
- **you are about to change a part** nobody has touched in months;
- **something started behaving oddly** and there were no commits;
- **the surroundings moved** — a runtime version, an input format, a
  neighbouring service — and it is unclear what survived;
- **you are handing the tool to others**: publishing it, passing it to a
  colleague, putting it somewhere shared.

What the five have in common: no changes, plenty of questions. A diff reviewer
looks at what a change broke, and here nothing was changed. The code sat still
while library versions, input formats, neighbouring services and host limits
moved around it. The debt is there, the commits are not, and a diff reviewer has
nothing to look at. One way to see it: run today's inputs through the code.

| Situation | Use |
|---|---|
| a pull request, a branch to merge, a diff | whatever reviews diffs in your assistant |
| a tool, a script, a config tree, a document set on disk | the `audit` skill |

**`audit` runs in one session and spawns no subagents.** Diff reviewers usually
split the work across parallel agents; this one does not, because every spawn
loads its context from nothing. If the object is too big for one session, the
skill takes one part of it and says which in its opening line.

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

Beyond the findings the file carries two lists, and without them nobody can
work from it.

**Invariants** — what a fix may not break, quoted from the project's own words:
"the hook fails open", "both ports carry one policy". Without that list, a fix
that closes a hole by refusing to run looks like a success.

**Fix order** — which items touch the same code and are done together, which
goes first, and whose reproductions to re-run afterwards. It also says what
stays broken meanwhile: the worst finding usually has to go last, because
everything else would otherwise be re-applied to rewritten code.

## The file is an audit another session decides from

It is not a memo and not a report to read through. It is the input to the next
step: another LLM, or a fresh session of this one, reads the file and decides
from it what to change — in the code, in the layout, in the configuration. The
pass and the repair are done by different sessions on purpose, and the file
carries everything the decision needs. Hand it to another assistant, or to the
same one in a fresh session:

```
Work through review-2026-09-18-mytool.md. Reproduce each item before fixing it,
in the order the file gives, and run the acceptance commands at the end.
```

Nothing else has to travel with it. Each item carries four things: the command
that reproduces the defect; the fix stated as a change, not an intention; the
files that change together; the test that closes it. The file as a whole carries
the invariants, the order of the items, and the acceptance commands with their
exit codes. A fixer needs none of the reviewing session's context.

That separation is the point, not a limitation. A session that reviewed the code
already believes its own reading of it. A session holding only the file has to
reproduce every claim first — which is what the file asks for in its second
line.

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
- **One object per pass.** Past roughly 600 lines the object is cut into
  segments and one is taken. A segment is a part that can be reviewed on its
  own: its own inputs, its own checks. Most projects already have them marked —
  the main implementation `bin/tool` and its port `bin/tool.ps1`; the library
  `lib/parse.py` and the command that drives it; one subcommand of a CLI with
  its own flags; one subsystem of a configuration tree. The reason is that a
  pass fits in one session, and that session's budget splits between two jobs:
  reading the code, and feeding broken inputs through it. At five hundred lines
  there is enough for both; at fifteen hundred nearly all of it goes on reading,
  and items come out without a reproduction — "this looks risky" instead of the
  command that shows it. The port gets a pass of its own, and that one starts as
  a parity check: the same inputs through both, the differences listed.

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
