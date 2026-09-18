---
name: audit
description: Review a tool, script, config set or document set that already exists on disk, and write the findings to review-YYYY-MM-DD-<object>.md. Handles "сделай ревью", "пройдись по коду", "cold review", "проверь этот инструмент целиком", "audit this", and additions to a review that exists — "допиши в ревью", "добавь пункт", "add this finding to the review". Each finding carries the command that reproduces it. One session, no agent fan-out. Not for a pull request or a diff — those have reviewers of their own, built on the diff.
version: "1.0.22"
---

# audit

A pass over something that is already written, by a session that did not write
it. Produces one file: `review-YYYY-MM-DD-<object>.md` at the project root. It does not
fix anything — reviewing and repairing are different jobs: a pass that stops to
fix its first finding stops looking for the rest, and never reaches a third one.

**Announce:** "Using audit on \<object\> — findings go to
review-\<date\>-\<object\>.md." Name the file in full: it is the one line that
lets the person stop a pass aimed at the wrong thing before it costs anything.

## When this, and when a diff reviewer

| Situation | Use |
|---|---|
| a pull request, a branch to merge, a diff | whatever reviews diffs here — those tools take the changed lines as their input |
| a tool, a script, a config tree, a document set sitting on disk | this |

A diff reviewer reads what changed against what it replaced, which is a
different question from whether the thing works. It also has no input at all
when nothing has changed — the ordinary case for a tool somebody wrote once and
has been using since.

**Cost of this skill: one session, no subagents.** Reviewers of the other kind
usually split the work across parallel agents; this one does not, because every
spawn loads its context from nothing. If a pass seems to need a fan-out, the
object is too big — review one part of it and say which part.

## Choosing the object, in one exchange or none

**If the person named a path, a file or a subject, that is the object.** They
have already chosen; offering alternatives asks them to choose again and reads
as reluctance to start.

**If they named a directory with several things in it, pick one and say which.**
Name it, say in one clause what makes it the candidate — the thing this session
was about, the thing that changed most recently, the thing nothing has ever
looked at — and start unless they say otherwise. Being wrong costs one sentence
from them; a menu costs them the work of ranking options they cannot rank.

**Never offer a catalogue.** A list of four entries with sizes and "never
audited" beside them is not a question anybody can answer: file size and audit
history do not tell a person what they would learn. If a choice genuinely has to
be made, offer at most two, each described by *what the pass would look for*, and
say which one you would take.

One object per pass. Two objects in one file is two passes stapled together,
and the second one is always the thinner.

**Past roughly 600 lines of code, cut the object into segments, take one, and
say which.** A segment is a part that can be reviewed on its own — its own
inputs, its own checks. Most projects already have them marked: the main
implementation and its port in another language; the library and the command
that drives it; one subcommand of a CLI; one subsystem of a tree.

The reason is the budget. A pass fits in one session, and that session splits
between two jobs: reading the code, and feeding broken inputs through it. At
five hundred lines there is room for both. At fifteen hundred nearly all of it
goes on reading, and the items come out without reproductions — "this looks
risky" instead of the command that shows it, which is the one thing this pass
exists to produce. Take the primary segment first.
A port then gets its own pass, and that pass starts as a parity check — the same
inputs through both, the differences listed — which is cheaper and sharper than
auditing it from nothing.

**A review of this object already in the project makes this a re-audit, and it
starts there.** Look for one before anything else — same directory, any date.
Then the first section of the new file is that file's items, each marked
`closed` (with the command that shows it), `open`, or `regressed`, and only
after that comes new ground. Starting cold instead re-derives what somebody
already paid for, silently drops whatever the old pass cleared in "what is NOT
a defect", and leaves the person comparing two files by hand to learn whether
the work landed.

**Adding a known finding to an existing review is not a pass.** When the person
arrives with something already reproduced — found while reading the file, found
by the fixer, found in the conversation — write it into the file and stop. A
whole pass to add two items costs what a whole pass costs and re-derives
everything that was already paid for. The same goes for a correction: re-classing
an item, moving one from `D` to `A`, adding a line to what is NOT a defect.

An item lives in four places, and an addition that touches only the first is an
item the fixer never reaches:

1. **the item itself**, in the shape the neighbours use — class, where,
   mechanism, reproduction with its real output, fix, touches, test
2. **the fix order** — where it goes, what it shares a code path with, whose
   reproduction has to be re-run after it
3. **the acceptance list** — one row, the assertion that proves it closed
4. **what is NOT a defect** — when the probe that produced the finding also
   cleared something, that clearing is worth as much as the finding

**Never renumber.** Append `A9`, `A10`; the existing numbers are referenced in
the fix order, in the acceptance table, in commit messages and in whatever the
person has already written down. Renumbering to keep severity order breaks all
of it silently — severity lives in the class line and in the fix order, which
is what anybody working from the file actually reads.

## The rule the whole thing rests on

**Reproduce before you claim.** A finding without a command that shows it is a
guess, and guesses do not survive: they are cheap to write and expensive to
read, because somebody then goes and checks them.

Two consequences, both non-negotiable:

- **Run the command on the broken input**, not on the happy path. A check never
  executed against the failure it describes has not been checked.
- **A claim about somebody else's system is not a reproduction.** Where the
  severity of a finding rests on how a host, a runtime or a library behaves —
  what happens on a timeout, what a limit does, which order things run in —
  documentation is a hypothesis. Show it on this machine, or mark the item
  unverified and name the one command that would settle it. Findings resting on
  a quote get acted on at full weight and are wrong at full weight too.
- **The output you read has been through this machine's own filters.** A
  session runs inside hooks, wrappers and pagers that rewrite what a command
  printed before anybody sees it. When the object is the same kind of thing as
  one of those — a redactor, a formatter, a linter, a masker — its output and
  the filter's are indistinguishable in the text, and a reproduction can look
  like it passed while the program under test did nothing at all. Measured: a
  check of "does the new rule mask this password" printed a masked value that
  the session's own hook had produced, and an hour went into a conclusion that
  was exactly inverted. **Take the verdict from the exit status, a file written
  by the command, or a byte count — never from the text on the screen**, and say
  in the item which of those you used.
- **Report what NOT to worry about.** A section listing what was examined and
  found correct is worth as much as the defect list: without it the next reader
  re-examines the same five things.

## Before looking at a single line

The review is worthless if it re-reports what the project already states as
deliberate. In order:

```bash
date -Is                      # the date goes in the filename; never take it from the chat
git -C <dir> log -1 --oneline # the commit the line numbers refer to
<tool> --version              # what actually runs here
```

Then read what the project says about itself: the instruction file at its root
under whatever name this assistant reads — `AGENTS.md`, `CLAUDE.md`, or the
equivalent — the `README`, and its work notes if it keeps any. A notes
directory is read with whatever wrote it (`kb brief` for a `kb/`), or just
read as files.
A rule the author wrote down on purpose is not a finding. Contradicting one is.

Run the project's own checks once, before touching anything, and put the result
in the file as the baseline: a pass that starts from a broken tree reports the
breakage as its own discovery.

## Stay inside the project

Everything the pass reads is the object, its project, or a throwaway copy of
them. Another project on this machine is not evidence about this one: its code
was written by other people under other constraints, its documentation
describes itself, and a finding sourced from it cannot be reproduced by the
person who reads the review.

Three ways the boundary gets crossed without meaning to, all of them worth
refusing:

- **Looking for an example of the output elsewhere.** The example is
  `references/template.md`. A review file that happens to exist in another
  project is that project's work order, not a form to copy.
- **A machine-wide command.** Anything that enumerates what exists on this
  machine — a registry, a global list, a search from `/` or `$HOME` — answers a
  question nobody asked. Ask the project: its own notes, its own tests, its own
  history.
- **Following a path out of the project.** A configuration file the object
  writes to, a hook it installs into, a directory it manages: read it when the
  finding is about that path, say that it was read, and change nothing there.

The reproductions are the exception, and only towards `/tmp`: a throwaway copy
is how the live data stays untouched.

## Sandbox, always

Anything that touches machine state — a registry, `$HOME`, a config file, a
cache, a live directory — gets a throwaway copy and its own environment:

```bash
REV=$(mktemp -d)                       # a new one per run, never a fixed path
mkdir -p "$REV/home"
HOME="$REV/home" TOOL_REGISTRY="$REV/reg" <tool> <command>
```

**A fresh directory per run, from `mktemp -d`, and nothing is ever deleted.**
The shape that arrives by habit is a fixed path wiped at the top of a probe
script — `rm -rf /tmp/rev/home` — and it is wrong twice. A destructive command
inside a heredoc is invisible to whatever normally asks the person before one
runs, so the safeguard is bypassed by the act of writing a script. And a fixed
path makes two passes, or a pass and the person's own shell, collide silently.
`mktemp -d` removes the need for the `rm` entirely: every iteration is clean
because it is new. Leave the directories behind — `/tmp` is where that belongs,
and the person can clear them when they like.

Say in the file that reproductions were run this way, so the reader can repeat
them without fear. Never reproduce against the data the person actually uses:
for an object that writes into a real configuration, the reproduction runs with
`HOME` pointed at the copy, and a `.bak.*` appearing in the real home directory
is the proof that it did not.

## A thing that decides is tested on the inputs it was not written for

Whatever the object classifies, filters, matches or transforms, its author tested
it on the shape they had in mind, and that shape works. The findings are in the
shapes the same data also takes: the same value in another syntax, spanning more
than one line, carrying a character the pattern did not expect, appearing twice
where the code counts once.

Two questions for any such object, and they are not symmetric:

- **What does it let through?** — usually the severe half: nothing looks wrong
  and the result is trusted.
- **What does it damage?** — the half that gets the tool switched off, which
  ends whatever protection it gave. A classifier that mangles what it should
  ignore is a `damage` finding, not a nitpick.

  **Take that input from the machine, never from your own head.** Invented
  "ordinary text" comes out as prose, and prose contains none of the shapes that
  collide with patterns. Real input does: `ls -la`, `git log --oneline`,
  `kubectl get pods`, the project's own README and source files, a build log —
  kebab-case names, UUIDs, hashes, paths, base64, version strings. Pipe a few
  hundred lines of it through and `diff` against the input. Measured: a pattern
  that ate every `task-…`, `disk-…` and `ask-…` name of twenty characters or
  more survived a pass whose "ordinary text" was generated prose, because
  generated prose has no such names in it.

Get those shapes from the object's own domain — the format it parses, the
specification it implements, the fixtures its tests already carry — and not
from memory. Domains where the same shapes keep recurring have a page:
`references/domains.md`, loaded only when the object is one of them.

## What a pass costs, and where it goes

Two things dominate the wall clock, and neither is reading the code.

**Probe in one batch, expand only the hits.** A hypothesis is one line of input;
twenty hypotheses are one script, not twenty tool calls. Write the candidate
shapes into a file, loop over them, print `input → output → exit` as a table,
read it once. Then the findings get their own careful reproduction — the ones
that survived. A round trip costs seconds and the model's whole context; a loop
costs milliseconds.

```bash
while IFS= read -r c; do
  printf '%-40s → %s (exit %s)\n' "$c" "$(run "$c" 2>&1 | head -1)" "$?"
done < cases.txt
```

The same applies to measurements: one script that prints the whole size ladder
beats five timed runs, and to the project's own checks — run them together.

**The file is long because it is thorough, not because it is wordy.** Per item:
the mechanism in three lines or fewer, the reproduction in full, the fix in one
sentence, and nothing else. No restating of what the reproduction already shows,
no paragraph about why the area matters. Twelve tight items read faster than
eight discursive ones and take less time to produce.

Two more levers, when a pass is running long: say so and narrow the object
rather than thinning every item, and remember that a re-audit over an existing
review starts from its list instead of re-deriving it.

## Anchors rot, names do not

Line numbers are stale within a week. Give them, and give the way to find the
place again:

```
**Where:** `git_state`, lines 862–889 — the numbers will rot, the name will not:
`rg -n "^def " <file>`
```

## The file

**The skeleton is `references/template.md`** — slot by slot, load it when you
start writing and not before. This page says what a pass is; that page says
what the file looks like.

**`review-YYYY-MM-DD-<object>.md`, always, at the project root.** The object
slug comes from what was audited — the file, the directory, the subsystem —
**without its path and without its extension**: `bin/secrets-redact.ps1` gives
`secrets-redact-ps1`, `lib/patch_config.py` gives `patch_config`, `docs/`
gives `docs`. Two assistants asked to name the file both produced
`review-2026-09-18-up.sh.md` from `up.sh`, because the rule said "the file"
and a filename carries its extension. The
date alone was the name once and it was wrong twice over: one pass per object is
the rule, so a directory collects several reviews, and a reader looking for the
one about a particular thing should not have to open files to find it. Say the
full name in the opening line, before the work starts.

A file with that exact name already there means this object was reviewed today.
Say so and ask: replace it, or sit beside it as `-2`. That is the person's call.
**Never overwrite a review** — it is somebody's work order and may be half
executed.

**Language: English when the project has any English documentation**, and the
project's own language only when it has no English at all. The file is read
beside the documentation, so matching it matters — but a project that documents
itself in two languages has already answered this, and English carries the same
content in roughly two thirds of the tokens, which is two thirds of the time
spent writing it. Reproductions, commands and error strings are verbatim in
either case.

Sections in this order:

1. **Header** — the object, the date, the commit, the sizes, and the baseline:
   the output of the project's own checks before anything was touched.
2. **How to work through this file** — the order of the sections, the demand to
   reproduce before fixing, what must not be touched.
3. **A. Defects**, most important first. Each one: `Where` / `Reproduction`
   (commands and their real output) / `Fix` (what exactly, never "improve") /
   `Test` (which case, in which group).
4. **B. Documentation disagrees with the code** — kept apart from defects: it is
   repaired by editing text rather than code, often by a different person.
5. **C. Efficiency** — only with measurements. A number produced by a command,
   and the condition under which it starts to hurt. No number, no item.
6. **D. Judgement on the design** — what is right and must stay, what is
   arguable. Changed only after the person agrees: proposals here, not tasks.
7. **What is NOT a defect** — examined and found correct, so the next reader does
   not spend the time again.
8. **Done when** — acceptance criteria: which commands, with which output.

**The sections do not change with the object.** They are named after
consequences, and every object has the same four: it does the wrong thing, it
describes itself wrongly, it costs too much, it was built on a choice worth
questioning. What changes is what fills them, and how a claim is proved:

| Object | Baseline is | A reproduction looks like |
|---|---|---|
| a CLI or a script | its own test suite, a lint | input in, output and exit status out |
| a library | the suite, a type check | the smallest calling program that shows it |
| a configuration tree | what applies it — a dry run, a plan | the applied state next to the intended one |
| a document set | the checks the project defines for it | the command whose real output contradicts the text |

**A section with nothing in it says so in one line and stops** — "no
documentation exists for this object, so nothing could disagree with it".
Padding an empty section is how a review starts inventing: the shape asks for
items, and items get produced. The one section that is never empty is what is
NOT a defect, because something was always examined and cleared.

Severity by consequence, not by taste: wrong answer beats crash beats mess.
A crash with a clear message outranks a silent wrong result only when nobody
acts on the result — say which it is.

## Slow enough is a defect, not a cost

The section a finding belongs to is decided by its consequence, never by how it
was found. A number produced while measuring speed belongs in **A** whenever
being slow makes the thing stop doing its job: a timeout that kills a filter, a
size cap that truncates, a queue that drops, a retry budget that runs out.
The shape is the same wherever it appears: a formatter that gives up on a long
file and leaves it unformatted, an importer that stops at a row limit and
reports success, a cache warmer that never reaches the last key. Measured case:
a filter wired as a hook with `"timeout": 10` took 5.6 s per megabyte, so every
input past roughly two megabytes went through untouched — and the large inputs
are the ones that most needed it.

Two things follow whenever a limit and a cost meet:

- **Say which way it fails.** Killed at the limit, does the thing it guards get
  blocked, or does it pass through unguarded? A guard that fails open is a
  security defect with a stopwatch attached; a guard that fails closed is an
  outage. They are not the same finding and the fix differs.
- **Prove it by the miss, not by the clock.** The reproduction is a pair: the
  smallest input that crosses the limit and shows the thing not happening, and
  one just under it where it does. Seconds on their own show a cost; the pair
  shows a defect.

`C` keeps what stays a cost — latency, repeated work, a read done four times.

## The file is a work order, so it owes the fixer four things

A pass that finds real defects can still produce a file nobody can execute. The
difference is not the findings, it is what surrounds them.

**A severity word on every `A` item, not just an order.** Items get handled one
at a time, days apart, by someone who reads that item and not the list, and the
ranking you encoded in the order is invisible from inside item five. Say the
class in the item's own line: *silent wrong result* (nothing looks wrong and the
answer is false — the worst, because nobody goes looking), *visible failure*
(it stops and says so), *damage* (it destroys or corrupts something that was
fine). The class, not an adjective.

**A fix order, when the items interact.** Findings that touch the same function,
the same pattern or the same parser are not independent: fixing one moves the
code the next one's reproduction was written against, and a reproduction that no
longer reproduces reads as "already fixed". Group them, name the order, and say
which reproductions have to be re-run after each step. When two items are
genuinely independent, saying so is also worth a line.

**A fix order is also a schedule of exposure.** Ordering by what the code needs
is only half of it: while the early items land, the late ones stay broken, and
the worst finding is routinely the one that has to go last because everything
else would be re-ported into it. Say that out loud — what remains open, and for
how long in items. Then either give an interim measure that costs an hour and
closes most of the hole, or state that none exists and the risk is accepted
until the item lands. An order with no exposure line reads as "worst first",
which is exactly what it is not.

**A rewrite needs the old incidents pinned before it starts.** When a fix
replaces a mechanism rather than adjusting it, whatever that mechanism was
built to survive has to exist as a test case *before* the first line changes —
the incidents live in commit messages, in design notes, in a comment nobody
will read while rewriting. Name them in the item, with where they are recorded.
A rewrite that passes the suite and re-opens a closed incident is the most
expensive outcome a review can cause.

**The blast radius of each fix.** Name every file that has to change together —
a port in another language, a copy of the same table, a schema, a fixture — and
name what enforces the agreement between them, if anything does. "Change it in
both" is a sentence the fixer forgets; "the test diffs these two lists
character for character" is one they cannot.

**The invariants, taken from the project's own words.** Before the findings,
list what a fix may not break: the contracts the project documents on purpose —
what happens on failure, what may not be a dependency, what has to keep working
on the older runtime. Without that list a fix that closes a miss by refusing to
run is an improvement by the review's own criteria and a disaster by the
project's.

## Acceptance commands are run, not read

The "Done when" block is pasted into a terminal by somebody who will believe
what it prints. So every command in it carries the exit status it should have,
not only the text — a tool with grep-like exit codes returns non-zero on the
very cases that prove it working, and pasted into a `&&` chain that reads as
failure. Where a check has a number, give the number the project's own runner
prints, including the count that must go up when the new tests land.

**A fix you tried in the sandbox reports the project's own suite, before and
after.** A patch that works on the reproduction and breaks four cases is a
finding about the patch, and it belongs in the item.

## One binary, two roles, two meanings for the same exit code

A program used both from a terminal and from a hook, a wrapper or a pipeline
carries two contracts at once, and they disagree about the same number: `1` is
grep's "nothing matched" in one and "it failed" in the other. Neither reading is
wrong, and a caller with `set -e` cannot tell them apart.

When the object has two roles, check that its exit codes are documented **per
role**, and say so when they are not. This is a `B` item when the behaviour is
defensible and only undocumented, an `A` item when something already acts on
the wrong reading.

## What never goes in

- **Style without a consequence.** Naming, line length, comment density: leave
  them unless the project states a rule and the code breaks it.
- **"Could be faster" with no number.** Either measure it or drop it.
- **A rewrite of prose a human wrote.** Comments, docs and notes belong to their
  author; report a contradiction with the code, not a better wording.
- **A finding you did not reproduce.** Move it to the "what is NOT a defect"
  section with what you actually observed, or leave it out.
- **Fixes.** This pass writes one file and changes nothing else.

## End with

One line per section — `A: 7, B: 2, C: 6, D: 4 open questions` — the path of the
file, and the sentence saying the fixes belong to a separate run against it.
Then stop.
