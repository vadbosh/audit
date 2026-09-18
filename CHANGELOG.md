# Changelog

Versions are the `version:` field in `skills/audit/SKILL.md`, and each is tagged
at the commit that introduced it. Breaking means the skill now refuses something
it used to do.

Releasing, in one commit: bump `version:`, add the section here, commit, then
`./release.sh tag` and `git push --tags origin`. The tag carries this file's
section for that version, so `git tag -n99 v1.0.0` answers "what changed"
without leaving git.

A tag is not edited afterwards: `git tag -f` recreates it, and for one already
pushed that means a force-push while anyone who fetched keeps the old. Anything
needing correction later belongs here, where it can be.

## 1.0.23

- Заголовок раздела о поводах для прогона назван предметом: «Когда это
  запускают» → «Когда запускают audit», «When you run it» → «When you run
  audit». Заголовок читают из оглавления, где предыдущей строки нет, и «это»
  оттуда не значит ничего. Нашла проверка «Заголовок называет предмет» из
  скила `ru-tech-docs`. Якорей на прежний текст не было.

## 1.0.22

- "сколько ест времени и памяти" — a tool consumes, it does not eat. Same word
  replaced on the English side.

## 1.0.21

- **One table cell was carrying a five-part structure.** "what is broken: the
  command that shows it; how bad — wrong in silence, broken loudly, damage done;
  what changes together; what closes it" is a list wearing a cell as a disguise.
  The cell now says what section A is — what is broken, and how to see it — and
  the five parts are a list under the table, with the reason the silent case is
  the worst: nobody noticed, so nobody will go and check.

## 1.0.20

- **The table of sections read like a specification.** "what does the wrong
  thing — each with the command that reproduces it, a class (silent wrong
  result / visible failure / damage), the blast radius of the fix" put three
  pieces of jargon in one cell, one of them untranslated in the Russian version.
  Every row is now a phrase somebody would say out loud: what is broken and how
  bad, the README promising one thing while the code does another, how much time
  and memory it eats, what to leave alone.

## 1.0.19

- **The fourth question grew into a paragraph of examples with nothing behind
  them.** "A fixed list of labels" — labels of what, in whose tool. Cut to one
  case a reader can picture: five named commands may read a secret file, and
  `sort .env` is not among them, so it reads it freely. Not a defect, a choice
  with a price; the audit names the price, the author decides.

## 1.0.18

- **The four questions were labels, not explanations.** They named what a pass
  asks and left the reader to imagine it. Each one now carries the case behind
  it: a key written in JSON instead of after an `=`; a README promising the
  label `Authorization: Bearer` the code never had; a redactor at 5.6 s per
  megabyte behind a hook killed at 10 s; a tool whose allowlist lets everything
  unnamed through. Question 4 in the English version had also missed the
  previous release — the replacement silently did not apply, and the two
  versions ran a release apart.

## 1.0.17

- **The fourth question was a label with nothing behind it.** "Which decisions
  are worth questioning — named as proposals, never as tasks" says what the
  section is called and not what goes in it. Now it says these are not defects
  at all: the code does what it was meant to and the intent is what is
  arguable, with three shapes that recur — an allowlist where everything
  unnamed passes, a fixed list of labels that grows only after an incident,
  failing open until it is the hole — and why the author decides: they pay the
  price and know why it ended up that way.

## 1.0.16

- **"A work order handed to whoever fixes" understated what the file is for.**
  It is the input to a decision, taken by another LLM or a fresh session: what
  to change in the code, in the layout, in the configuration. Both READMEs say
  that first now, before the sentence to paste.

## 1.0.15

- **"The size at which that number starts to hurt" — hurt whom.** The cost
  question now asks where the cost stops being a cost: seconds and bytes from a
  command, plus the threshold past which the thing simply does not happen. With
  the case that produced the rule: a redactor at 5.6 s per megabyte behind a
  hook the host kills at 10 s, so every output over two megabytes reached the
  reader unmasked.

## 1.0.14

- **"When `audit`, and when a diff reviewer" answered the wrong question.** It
  compared two kinds of tool while the reader wanted to know when they would
  reach for this one, and who reaches — nothing here watches a repository or
  runs on a schedule. The section is "When you run it" now, and names the five
  occasions: picking up a tool you do not know what to trust in, changing a part
  untouched for months, odd behaviour with no commits behind it, surroundings
  that moved, handing the tool to somebody else. The comparison with diff
  reviewers follows as the reason those occasions have no diff to show.

## 1.0.13

- **Shorter sentences, same facts.** The Russian version had one of 47 words and
  one of 34; both were lists joined by semicolons where a colon and four items
  say it faster. Measured after: longest sentence 31 words, average 17. The
  English side got the same treatment where it had grown past 40.

## 1.0.12

- **Why a diff reviewer has nothing to show, said plainly.** The old wording —
  "a script written six months ago gives a diff reviewer nothing to look at, and
  usually has plenty to find" — stated the outcome without the cause. The cause
  is that code stands still while its surroundings move: dependency versions,
  the shape of its input, the services next to it, the limits of its host. The
  debt accumulates with no commits carrying it, which is exactly why the only
  way to see it is to run today's inputs through the code.

## 1.0.11

- **"The budget for care is spent on breadth" explained nothing**, and the
  "three times as long" beside it was never measured. Both are replaced by the
  mechanism: a pass fits in one session, and that session splits between reading
  the code and feeding broken inputs through it. At five hundred lines there is
  room for both; at fifteen hundred nearly all of it goes on reading, and items
  arrive without reproductions — which is the one thing the pass exists to
  produce. Said the same way in the skill and both READMEs.

## 1.0.10

- **"Split along a seam" named a metaphor, not a part.** The rule for a large
  object now says it is cut into segments and one is taken, and says what a
  segment is: a part that can be reviewed on its own, with its own inputs and
  its own checks. Four examples of where projects already have them — an
  implementation and its port, a library and the command that drives it, one
  subcommand of a CLI, one subsystem of a configuration tree.

## 1.0.9

- **Three passages restated an idea instead of carrying it.** "A diff reviewer
  compares what a change became against what it replaced" — true and useless
  without the consequence; "the two things that make it executable rather than
  informative" — a claim about the file rather than what is in it; "split it
  along a seam that already exists" — a seam in what. All three now carry the
  example: a script untouched for six months gives a diff reviewer nothing to
  look at; the invariants are quoted lines like "the hook fails open"; the seam
  is `bin/tool` apart from `bin/tool.ps1`.

## 1.0.8

- **Nothing said what to do with the file.** Both READMEs described what a pass
  produces and stopped there, leaving the obvious next step — hand it to another
  assistant, or to this one in a fresh session, and have it work through the
  items — as something the reader had to think of. Said now, with the sentence
  to paste, and with why the split is the point: a session that reviewed the
  code already believes its own reading of it, while a session holding only the
  file has to reproduce each claim before acting on it.

## 1.0.7

- **The Russian opening was a translation, not a sentence.** "то, что уже
  написано и лежит на диске" is how the English reads, and nobody says it in
  Russian. Both versions now open by naming the thing — a skill for auditing
  code — and the four areas it covers, before the object it takes and the file
  it writes.

## 1.0.6

- **Both READMEs said what the skill reviews and never what it asks.** "A skill
  for reviewing something already written" leaves the reader to guess whether
  this is a security review, a style pass or a diff reviewer — and the guess
  costs a run to correct. The opening now states the four questions in order:
  does it do what it promises on inputs nobody had in mind, does the
  documentation describe the code that is there, what does it cost by
  measurement, which decisions are worth questioning. The repository
  description says the same in one sentence.

## 1.0.5

- **The review file came out named `review-2026-09-18-up.sh.md`.** Run against
  `up.sh` in Opencode and in Codex, both named the file that way from the same
  rule: it said the slug comes from "the file", and a filename carries its
  extension. The slug now drops the path and the extension, with three examples
  in the skill and two in the template.

- Verified while finding it: the two reference pages load on demand in Opencode
  and Codex exactly as in Claude Code — `references/template.md` and
  `references/domains.md` were read at the moment the pass reached writing, in
  both.

## 1.0.4

- **The pass read one assistant's instruction file first.** `CLAUDE.md` was
  named ahead of `AGENTS.md`, and the project's notes were described as
  something `kb brief` prints — a tool that may not be installed. Both are now
  stated by role: the root instruction file under whatever name this assistant
  reads, and a notes directory read with whatever wrote it, or simply as files.
  Nothing else in what ships assumed an assistant: no agent tool, no model
  names, no `gh`. The commands the pass runs are `mktemp -d`, `git`, `ls`,
  `diff`.

## 1.0.3

- **The skill defined itself by a plugin that exists in one assistant.** It
  ships into Claude Code, Opencode and Codex, and told all three to reach for
  `code-review` instead when the input is a diff — a Claude Code marketplace
  package, absent from the other two and not portable to them: the marketplaces
  are separate install systems, the agent-per-model pinning it is built on does
  not survive the port, and its input comes from `gh pr diff`.

  The distinction that matters was never the product, it is the input. A diff
  reviewer compares what a change became against what it replaced; this pass
  asks whether the thing works, and needs nothing to have changed. Said that
  way in the skill and both READMEs, with no product named anywhere in what
  ships.

## 1.0.2

- **The comparison section named no one.** "Pull-request reviewers spawn several
  agents" — which reviewers, spawning how many? And the table answered "use:
  this", where "this" is the thing the reader is deciding about. Both versions
  now name the `code-review` plugin and its actual shape — three Haiku agents,
  five Sonnet reviewers, one more per finding — and say that `audit` runs in one
  session, splitting an object too big for that and saying which part it took.

## 1.0.1

- **"stops looking at item three" named nothing.** The line explaining why the
  pass does not fix came from an image in somebody's head: the third item of
  what? Said plainly — a pass that stops to fix its first finding stops looking
  for the rest, and never reaches a third one. Corrected in the skill, both
  READMEs and the changelog section that carried it.

## 1.0.0

First release as a repository of its own. The skill was written over one day
inside another project's config canon; every rule in it came from a pass that
went wrong in a way worth writing down, not from an idea about reviewing.

- **One session, no agent fan-out.** The alternative — the `code-review` plugin
  shape of three Haiku agents, five Sonnet reviewers and one more per finding —
  earns its cost on a pull request with owners and history. It has no input at
  all when there is no pull request, which is the ordinary case for a personal
  tool, and every spawn loads its context from nothing.

- **Reproduce before claiming, and run the command on the broken input.** A
  finding without a command that shows it is a guess, and a check never executed
  against the failure it describes has not been checked.

- **A claim about somebody else's system is not a reproduction**, and **the
  screen has been through this machine's own filters** — when the object is the
  same kind of thing as a hook the session runs under, its output and the hook's
  are indistinguishable in the text. Verdicts come from the exit status, a file
  the command wrote, or a byte count.

- **The pass fixes nothing.** Reviewing and repairing are different jobs: a pass
  that stops to fix its first finding stops looking for the rest, and never
  reaches a third one.

- **Findings are classed by consequence** — silent wrong result, visible
  failure, damage — and **slow enough is a defect**: when a limit turns
  slowness into the thing not happening at all, the item is a defect with a
  reproduction, not a line about cost.

- **The file is a work order**: a fix order that says what stays open meanwhile,
  the blast radius of each fix, the invariants quoted from the project's own
  words, and acceptance commands carrying the exit status they should have.

- **Sandbox from `mktemp -d`, nothing deleted**, so no probe script ever needs
  an `rm` — a destructive command inside a heredoc is invisible to whatever
  would otherwise ask the person first.

- `references/template.md` carries the skeleton of the review file and
  `references/domains.md` the shapes that keep being missed per domain; both
  load on demand, so an ordinary pass never pays for them.
