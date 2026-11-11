# project-kit

A Claude Code plugin for projects that span several repos. Each project has a name, an Orca
icon, Jira epics and an optional knowledge base (KB). Any Claude Code session in a worktree that
belongs to a project starts with the project's context and an up-to-date KB, with no instructions
from you.

This repo holds only the tool. Your projects live in your own config folder, so you never edit
this repo to use it.

## Install

Requires Claude Code, git, Python 3.10+ and [Orca](https://github.com/stablyai/orca).

```
git clone https://github.com/panayi/project-kit.git ~/dev/project-kit
~/dev/project-kit/install.sh
```

Then start a new Claude Code session. `install.sh`:

1. Adds the repo as a local plugin marketplace and installs `project-kit@project-kit` at user
   scope. The plugin loads in place from `plugin/`, nothing is copied.
2. Links the `/project` skill into `~/.claude/skills/project`.
3. Creates `~/.config/project-kit/projects/`.

Running it again is safe. Check the install with `claude plugin list`, which should show
`project-kit@project-kit` as enabled.

**Update:** `git -C ~/dev/project-kit pull`, then start a new session or run `/reload-plugins`.

**Uninstall:** `claude plugin uninstall project-kit@project-kit`,
`claude plugin marketplace remove project-kit` and `rm ~/.claude/skills/project`. Your projects
stay in `~/.config/project-kit`.

## For agents

- **Using it:** the `/project` skill covers every operation: `new`, `attach`, `epic`, `list` and
  `remove`. Load it rather than editing project files or this repo. `project-kit` is on PATH in
  every session.
- **Installing it:** a person runs `install.sh`, because it changes Claude Code's own plugin and
  skill configuration. If `project-kit` is not on PATH, tell the user to run the two install
  commands above and start a new session. Don't edit `~/.claude/settings.json` to install it.
- **Checking it:** `project-kit detect` prints the project the current folder belongs to, and
  `claude plugin list` shows whether the plugin is enabled.

## Where things live

| Path                                   | What                                                   |
| -------------------------------------- | ------------------------------------------------------ |
| `~/.config/project-kit/projects/*.json` | Your projects. Set `PROJECT_KIT_HOME` to move them.    |
| `plugin/bin/project-kit`               | The CLI, on PATH in every session.                     |
| `plugin/hooks/hooks.json`              | The SessionStart, Stop and worktree-labelling hooks.   |
| `skill/project/`                       | The `/project` skill.                                  |
| `rules/`                               | The Orca naming rule, injected into every session.     |
| `kb-template/`                         | What a new KB starts from.                             |

A project file:

```json
{
  "name": "Launch",
  "icon": "🚀",
  "epics": ["https://example.atlassian.net/browse/ABC-123"],
  "kb": { "kind": "branch", "repo": "acme/web", "branch": "kb-launch", "path": "~/dev/kb-launch" }
}
```

`kb` can also be `{ "kind": "local", "path": "..." }` or `null`.

## Use

```
/project new                         create a project and its KB
/project attach <slug>               label the current Orca worktree
/project epic add <slug> <link>      add an epic; `epic remove <slug> <KEY>` removes one
/project list
/project remove <slug>
```

## What happens in a session

On startup, resume and compaction the SessionStart hook:

1. Injects the Orca naming rule.
2. Finds the project: Jira epics attached to the Orca worktree, then the project icon in the
   worktree's name, then the working directory being inside a KB.
3. For a branch KB, clones it if missing, else runs `git pull --rebase`. Failures are reported in
   the context and never block the session.
4. Injects the project name, epics, KB path, STATE.md (the first 6,000 characters if it is longer
   than 8,000), and the instruction to follow the KB's AGENTS.md and push before calling a task done.
   A one-line notice shows the project under the banner.

When an agent in a project session creates a worktree, with `git worktree add` or
`orca worktree create`, the new worktree gets the project's epics and a name in the naming
format, unless its name already starts with a project icon.

When the agent stops with uncommitted or unpushed KB changes, the Stop hook asks it once to
commit and push. It never commits or pushes itself.

Check which project a folder belongs to:

```
project-kit detect [path]
```
