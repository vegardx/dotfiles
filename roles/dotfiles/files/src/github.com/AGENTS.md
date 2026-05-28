# ~/src/github.com — public open source

Applies to all repos hosted on github.com.

## Public repo hygiene
- Never commit secrets, tokens, or credentials.
- Don't reference internal tooling, internal URLs, or company-specific context
  in code, comments, or commit messages.

## Defaults
- MIT licence unless there is a specific reason to choose otherwise.
- GitHub Actions for CI.
- Dependabot for dependency updates (npm, pip, github-actions as applicable).

## No unsolicited AI artifacts
- Do not open issues, create PRs, or post comments without explicit approval.
- Do not generate boilerplate PRs/issues "for later" — only when asked.
- This can be overridden by more specific AGENTS.md files closer to the repo.
