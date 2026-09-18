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
