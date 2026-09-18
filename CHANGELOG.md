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
