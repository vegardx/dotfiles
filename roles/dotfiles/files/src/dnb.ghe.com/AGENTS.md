# ~/src/dnb.ghe.com — DNB work

DNB GitHub Enterprise Cloud with Data Residency. Do not reference or
cross-link personal github.com repos from work code, CI, or documentation.

## Dependabot
Every repo needs `.github/dependabot.yml`. Always include `github-actions`
plus whichever package ecosystems the repo uses.

## Security
- Never commit AWS credentials, tokens, or internal certificates.
- Work repos are internal — still treat secrets as if they could be exposed.
