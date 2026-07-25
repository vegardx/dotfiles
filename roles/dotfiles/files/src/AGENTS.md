# ~/src — all source code

Applies to every repo regardless of host or org.

## Git workflow
- Work in feature branches, never directly on the default branch.
- Keep commits small and focused — one logical change per commit.
- Keep PRs focused on a single concern. Split unrelated changes.
- Rebase or merge the default branch into a feature branch to resolve
  conflicts; don't force-push shared branches.
- Prefer rebase over merge or squash when closing PRs.
- Discover the default branch with `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.
- Check branch protection rules with `gh api repos/{owner}/{repo}/rules/branches/{branch}`.
  Never push directly to protected branches — always open a PR.

## Commit conventions
- Conventional commits: `type(scope): subject` — subject ≤ 72 chars.
- Valid types: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `style`,
  `perf`, `ci`, `build`.
- Body only when the change needs explanation — not a description of what the
  diff already shows.

## Engineering discipline
- Do the proper fix, not the lazy or shortcut fix. If the correct approach is
  known, take it; don't knowingly ship temporary/simple workarounds.
- Preserve existing intended behaviour when replacing code unless changing it is
  explicit. Account for the functionality the old code handled before removing
  or rewriting it; don't preserve bugs or accidental behaviour unless required.
- Keep changes as small as possible while still solving the problem properly.
  Don't broaden the design just because you're already touching nearby code.
- Don't change ownership boundaries, public contracts, permissions, or
  operational behaviour casually. Call out the impact and ask when unsure.
- After changing code, run the smallest relevant validation that proves the
  change works. If validation cannot be run, say why.

## TypeScript
- Strict mode always on.
- No `any` unless there is a concrete reason; prefer `unknown` for loose inputs.
- Tabs, double quotes, 80-col line length (Biome defaults).
- No comments that restate what the code does — comment *why*, not *what*.

## Go
- Follow standard Go project layout.
- `golangci-lint` for linting.
- Table-driven tests.
- No comments that restate what the code does — comment *why*, not *what*.

## Python
- Type hints on all function signatures.
- `ruff` for linting and formatting.
- `pytest` for tests.
- No `# type: ignore` without a comment explaining why.
- No comments that restate what the code does — comment *why*, not *what*.

## Testing
- Source code in `src/`, tests in `tests/`.
- Test behaviour, not implementation — don't assert on internal state that
  could change without breaking the contract.
- A task isn't done until the relevant tests pass and the linter is clean.
- Don't delete or skip tests to make the suite green.

## Documentation
- Keep README.md short and concise, avoid fluff and filler words.
- For more structured documentation use `docs/`.
- Use mermaid when creating visualizations like flow diagrams and similar.
