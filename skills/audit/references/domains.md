# Domains where the same shapes keep being missed

Load a section only when the object is that kind of thing. These are not
checklists to tick: each entry is a shape that was a real miss somewhere, kept
because the same shape reappears in unrelated implementations.

**Adding a section, or a line to one, needs the same evidence the rest of this
skill demands: the shape missed in two different projects.** One incident is a
finding in that project's review, not a rule here. A page that grows by anecdote
becomes a catalogue of whatever was audited last, and then it is read by
everyone and true for nobody.

---

## Objects that handle credentials

*maskers, redactors, scanners, deny-gates, anything that stores or forwards a
secret*

**Never put a real value in the review.** It is read in a terminal, kept in a
transcript and swept into digests, so a credential quoted in a reproduction is
leaked by the document meant to protect it. Give the name, the line and the
*shape* — "an `AKIA` prefix and sixteen placeholder characters". Build the
inputs from placeholders.

Shapes that get missed:

- a value with **no recognisable prefix** — the pattern list covers the
  providers with a distinctive prefix, and covers nothing else
- a value **split across a line break**, in wrapped output
- a **multi-line block** — a PEM key, a certificate. The header matches, the
  body is a separate record, and a program with no state between lines masks
  only the header. The result *looks* redacted, which is the worst shape a miss
  takes: the one line that would make a reader stop is the one line removed
- the label in **another syntax**: `"name": "value"` in JSON, `name: value` in
  YAML, an HTTP header, credentials inside a URL. A separator written for `k=v`
  does not match the quoted form, and the quoted form is what tools print
- a value containing **punctuation** — `@ ! # $ %` — where the character class
  that finds the value stops at the first character outside it
- **several values on one line**: whatever counts them must count values, not
  matching lines
- **the value glued to its flag, or after a colon.** A label rule is written as
  "label, separator, value", and the separator is assumed. Four client idioms
  in daily use have none: `mysql -p<password>`, `redis-cli -a <password>`,
  `smbclient -U user%password`, `curl -u user:password`. Measured: ten idioms
  probed, three missed. The fix has a trap of its own — `-p`, `-a` and `-u`
  mean other things to other programs, so a rule for them is gated on the
  command that owns the idiom, or it starts masking `ls -p` and `sort -u`
- the same input through **every port and mode** the object has, since a second
  implementation drifts in silence unless something compares the two

The other direction, once: a page of ordinary output with no secrets in it —
identifiers, paths, resource names, hashes — must come back unchanged.

**And the session auditing this may be wearing the same thing.** A masker
installed as a hook rewrites the output of every command the pass runs,
including the commands testing the masker. `<REDACTED:…>` on the screen then
proves nothing: it may be the object working, or the session's own copy working
on top of it. Read the verdict from the exit status, from a file the command
wrote, or from a byte count — and put in the item which one, so the next reader
does not re-run it and believe the screen.

## Objects that wire themselves into somebody else's configuration

*installers, patchers, hook registrars, anything with an uninstall*

- **run it twice, then three times** — the second run must change nothing, and
  the third must not grow a list it appended to
- **run it over a hand-edited file**: the thing it wrote, edited by a human,
  then the tool run again
- **uninstall after install** leaves the file as it was, byte for byte, and
  leaves nothing behind it did not create
- **a partially applied state** — interrupted between two writes — is what the
  next run actually meets. Kill it mid-write and run it again: does the second
  run finish the job, and what does the first leave behind
- **look at what else appeared, not only at the target file.** Temp files,
  backups, lock files, a directory created on the way — `ls -la` the whole
  directory before and after, and compare the **modes**, not just the names. A
  target written correctly at 600 beside a leftover copy of itself at 644 is the
  same content with none of the protection, and nothing in the target file shows
  it
- **two runs at the same time.** A fixed temp name, a lock that is not taken, a
  read-modify-write with no exclusion: the loser's edit disappears, and the
  traceback says only that a file was not found
- every target it claims to support, since the file format usually differs per
  target and only one of them is exercised in development

## Objects with a limit

*timeouts, size caps, row limits, retry budgets, rate limits*

- the behaviour **at** the limit and just past it, not only well inside
- **which way it fails** when the limit is hit: the thing it guards passing
  through unchecked, or the work stopping. Say which, with the reproduction
- whether anything **reports** the limit being hit, or it is silent
- the limit's interaction with the caller's own limit — a hook killed by its
  host never gets to say anything at all
