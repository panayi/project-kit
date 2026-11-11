---
name: project
description: Manage multi-repo projects with project-kit. Use for `/project new` (create a project and its knowledge base), `/project attach <slug>` (label an Orca worktree), `/project epic` (add or remove a project's Jira epics), `/project list`, `/project remove`, or when the user asks to create a project, label a worktree, change a project's epics, or list projects.
---

# /project

Every operation is a `project-kit` command; it is on PATH in every session. Projects live in
`~/.config/project-kit/projects/<slug>.json` (or `$PROJECT_KIT_HOME/projects`). The commands
write those files; never edit the project-kit repo to manage projects.

## `/project list`

Run `project-kit list` and show the output.

## `/project new`

Ask the user, in one message, for:

1. **Name**.
2. **Icon**: one saturated, solid emoji that reads on a light grey sidebar and differs in both
   shape and dominant colour from every icon in `project-kit list`. Propose one.
3. **Jira epics**: zero or more full links, `https://<site>/browse/<KEY>`.
4. **Knowledge base**: an orphan branch of a repo they choose, a local-only folder, or none.

Then run one of:

```
project-kit new --name "<Name>" --icon <emoji> --epic https://<site>/browse/<KEY> \
  --kb-branch <owner>/<repo> --branch kb-<slug> --kb-path <path>
project-kit new --name "<Name>" --icon <emoji> --epic https://<site>/browse/<KEY> --kb-local <path>
project-kit new --name "<Name>" --icon <emoji> --no-kb
```

A branch KB pushes a new orphan branch to the remote. Say so and get an explicit yes first.
Report the project file and the KB path. Then offer `/project attach <slug>` for the current
worktree.

## `/project epic`

```
project-kit epic add <slug> https://<site>/browse/<KEY> [...]
project-kit epic remove <slug> <KEY> [...]
```

Worktrees already labelled for the project keep working through its icon. To attach the new
epic to a worktree, run `/project attach <slug>` there.

## `/project attach <slug>`

Labels the Orca worktree per the Orca worktree naming rule and attaches the project's epics.

1. Run `project-kit attach <slug> --dry-run`. Add `--worktree <path>` for another worktree,
   `--purpose "..."` when no single PR is linked, `--pr N` to choose a PR, and `--coordinator`
   for the project's one coordinator worktree.
2. Show the user the printed commands and get a yes.
3. Run it again without `--dry-run`.

## `/project remove <slug>`

Run `project-kit remove <slug>`. It deletes the project file and leaves the KB on disk.
