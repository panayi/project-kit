# Orca worktree naming (project-kit)

Orca groups worktrees by repo; a project spans repos. Until Orca ships tags/Group by Tag
(stablyai/orca#22688) or Group by Issue (stablyai/orca#12567), every worktree that belongs to a
project carries the project's icon and epics. project-kit labels worktrees you create from a
project session automatically. To label one by hand, run `/project attach <slug>`.
`project-kit list` shows the projects.

- Display name:
  - branch has a PR: `<icon> <Project> · <repo>#<PR>`, e.g. `🚀 Launch · web#123`
  - otherwise: `<icon> <Project> · <repo> · <purpose>`, e.g. `🚀 Launch · api · auth service`
- `<icon>` is the project's icon, always first. Icons are saturated, solid emoji that read on a
  light grey sidebar (no pale or sparkle-type icons like ✨) and differ from each other in both
  shape and dominant colour.
- `<repo>` is the GitHub repo name, not the folder name.
- The project's coordinator worktree is the one its coordinator session runs in. Prefix it with
  `▶ ` and write the project name in capitals; the purpose can be dropped:
  `▶ 🚀 LAUNCH · web#123`. Exactly one per project; when the coordinator moves, move the prefix
  and the capitals (`/project attach <slug> --coordinator`). Never write "coordinator" in the name.
- The project's epics are attached as full Jira links, so `orca reference find <KEY>` lists the
  worktree.
- Never move an existing worktree to tidy up: Claude sessions and Orca chats are tied to its path.
