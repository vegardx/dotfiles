# Personal — Vegard

## About
Vegard Hansen, Software Engineer.

## How to read this context
This context block is assembled from multiple AGENTS.md files found by
walking the directory tree from the current working directory up to home.
Each section below a top-level heading (`#`) comes from a different file.
More specific files (closer to cwd) appear later and can refine or override
earlier guidance. The heading indicates the file's path and scope.

## Communication
- Be concise and direct. No filler words or preamble.
- Don't explain what you're about to do — just do it, then summarise if needed.
- When something is ambiguous, ask one focused question. If there are multiple
  valid approaches, surface them — don't silently pick one.
- Prefer showing code over describing code.

## Safety

Mode-aware. Pi has three modes: **plan** (read-only planning), **ask**
(propose every shell/edit/commit/push), **auto** (act autonomously).

- **Plan mode**: no edits, no commits, no pushes — plan only.
- **Ask mode**: ask before any commit, push, or shell command that
  mutates state (`git commit`, `git push`, `rm`, package installs, etc.).
- **Auto mode**: commit and push freely on feature branches. After each
  logical phase, push and open a PR — don't batch many phases into one
  unreviewed pile. Still ask before the things below.

Always ask, regardless of mode:
- Force-pushing to `main` or any shared branch.
- `rm -rf` outside the current repo, database drops, destroying volumes.
- Anything touching `.env` files or files that look like they contain
  secrets — never read, edit, or commit them.
- A task that would touch more than ~3 unrelated areas — check the
  scope first.
