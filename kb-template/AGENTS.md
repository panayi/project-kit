# {{name}}: shared knowledge base (agent instructions)

This is the shared memory for **{{icon}} {{name}}** (epics: {{epics}}). {{kb_origin}}
`CLAUDE.md` is a symlink to this file.

Everything a session needs to continue the work is here. If it isn't written here, assume it
will be lost when the session ends.

## Rituals

**Session start.** project-kit pulls this KB and injects `STATE.md` into every session that
belongs to the project. Then, before working in an area, read its `knowledge/*.md` file. Don't
re-derive what is already written there.

**After any milestone, and before you call a task done:**

1. Update `STATE.md`: PRs, branches, the "Now" paragraph, and the date on the "Last updated" line.
2. Append to `DECISIONS.md` for every decision you or the project owner made.
3. Append traps to `knowledge/gotchas.md`. Correct or add verified facts in `knowledge/*.md`,
   giving the file path and the commit each fact was checked at.
4. Commit:
   `{{finish_command}}`{{push_note}}

**A task isn't done until STATE.md says so and the KB is committed.**

## Files

| File                   | Rule                                                                                    |
| ---------------------- | --------------------------------------------------------------------------------------- |
| `STATE.md`             | Current truth, overwritten. Keep it under ~150 lines; move stale detail to `handoffs/`. |
| `DECISIONS.md`         | Append-only. Correct an entry by adding a new dated one.                                |
| `knowledge/*.md`       | Verified facts and settled designs, with paths and commits. Fix wrong facts in place.   |
| `knowledge/gotchas.md` | Append-only. One trap per entry: symptom → cause → what to do.                          |
| `handoffs/`            | Dated narratives: session summaries, end-of-day notes, STATE archives.                  |

## Rules

- Shared repo docs name roles, not people. Names belong only in this KB and in agent memory.
- Commit prefixes: `state:`, `decision:`, `knowledge:`, `handoff:`. Prefer small commits.
- **No secrets.** No credentials, tokens, cookies, passwords (dev defaults included) or customer
  data. Before copying a log, trace or report here, grep it for password/token/secret/cookie/
  `BEGIN … PRIVATE KEY`.
- Jira holds assignable work items. This KB holds state, knowledge and decisions; link the two
  both ways.
- Facts that matter only to one person's machine go in that person's own agent memory, not here.
