# The shape of the file

Load this when writing `review-YYYY-MM-DD-<object>.md`. It is a skeleton, not an
example to copy words from: every line below is a slot, and a slot filled with
something vague is worse than a slot left out.

Headings in the language the review is written in — English unless the project
has no English documentation at all. The English below is the description of the
slot, not the text to write.

---

```markdown
# Review of <object> — a task for whoever fixes it

<!-- filename: review-YYYY-MM-DD-<object>.md — always with the object slug,
     one review per object, several of them per directory -->

Date: <YYYY-MM-DD, from `date -Is`>. Object: <files, sizes, what they are>.
Line numbers are as of commit <sha>. They will rot; anchor by name:
`rg -n "^def " <file>`.

Baseline, run before anything was touched:
<the project's own checks and their real output — tests, a lint, a release check>

## How to work through this file

1. Read <the project's own rules: CLAUDE.md / AGENTS.md / its notes> first.
2. Every item below has a reproduction. Reproduce on the broken input BEFORE
   fixing, then write the test, then fix.
3. Order: A by importance, then B, then C. D only after the person agrees.
4. After each item: <the project's test command> → OK.
5. <anything that must not be touched — generated blocks, vendored files>

**Invariants — a fix may not break these**, taken from what the project says
about itself, not from taste:

- <contract, and where the project states it>

**Fix order**, because these items touch the same code:

1. <item> — <why first: cheapest, or the one the others are written against>
2. <item, item> — together; after them re-run the reproductions of <item>
   
<items that are independent of everything else, said so explicitly>

Reproductions were run in a throwaway directory with <the environment that
isolates machine state>. Do the same.

---

## A. Defects (each reproduced)

### A1. <what is wrong, in one line, as a consequence>

**Class:** <silent wrong result | visible failure | damage> —
<one clause saying who or what acts on it>

**Where:** `<function or symbol>`, lines <N–M>.
<why it happens — the mechanism, not a guess>

**Reproduction:**

    <commands>
    # <the real output, pasted>

**Fix:** <what exactly changes>. <what must keep working>.

**Touches:** <every file that changes together — ports, copies, fixtures>;
<what enforces their agreement, or "nothing does">.

**Test:** <which case, in which group>.

### A2. …

---

## B. Documentation disagrees with the code

### B1. <which file, which claim>

<the text as it stands, then what the program actually does — run it and paste>

**Fix:** <which files, in pairs if the docs are bilingual>.

---

## C. Efficiency

Measurements on <this object, this size>: <numbers from a command>.

### C1. <what costs what>

<the mechanism, the number, and the size at which it starts to hurt>

**Fix:** <the change>. <what to watch out for>.

---

## D. Judgement on the design (change only after the person agrees)

What is right and must stay:

- **<decision>** — <why it holds, with the incident or measurement behind it>

What is arguable:

- **<decision>** — <the cost, the condition under which it breaks, and a
  recommendation that says "not now" when that is the answer>

---

## What is NOT a defect (checked, so nobody spends the time again)

- <thing that looks wrong and is not, with the reason>

## Done when

Commands to paste, each with the status it should exit with:

    <test command>            # <count that must go up>, exit 0
    <integrity or lint check> # exit 0
    <a one-line check per A item, with its expected output AND exit status —
     say so where a non-zero status is the correct answer>

- every A item has a test that failed before the fix and passes after
- <B criterion — the real output pasted into the docs, not retyped>
- <which of the project's own notes must be updated if the structure changed>
```
