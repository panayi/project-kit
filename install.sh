#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

chmod +x "${ROOT}/plugin/bin/project-kit"

if ! claude plugin marketplace list 2>/dev/null | grep -qE '❯ project-kit$'; then
  claude plugin marketplace add "${ROOT}"
fi
if ! claude plugin list 2>/dev/null | grep -q 'project-kit@project-kit'; then
  claude plugin install project-kit@project-kit --scope user
fi

mkdir -p "${CLAUDE_DIR}/skills" "${PROJECT_KIT_HOME:-${HOME}/.config/project-kit}/projects"
ln -sfn "${ROOT}/skill/project" "${CLAUDE_DIR}/skills/project"

echo "project-kit installed."
echo "  plugin:  project-kit@project-kit, hooks loaded in place from ${ROOT}/plugin"
echo "  skill:   ${CLAUDE_DIR}/skills/project -> ${ROOT}/skill/project"
echo "  rules:   ${ROOT}/rules/*.md, injected by the SessionStart hook"
echo "  projects: ${PROJECT_KIT_HOME:-${HOME}/.config/project-kit}/projects"
echo "Start a new session (or run /reload-plugins) to pick up changes."
