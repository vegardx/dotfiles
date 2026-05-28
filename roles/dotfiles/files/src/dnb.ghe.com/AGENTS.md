# dnb.ghe.com — DNB work

## Context
DNB GitHub Enterprise Cloud with Data Residency. All work repos live at
https://dnb.ghe.com. Do not reference or cross-link personal github.com repos
from work code, CI, or documentation.

## Dependabot

Every repo needs `.github/dependabot.yml`. Always include `github-actions`
plus whichever package ecosystems the repo uses:

```yaml
version: 2
updates:
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
```

Add `pip`, `docker`, `maven`, etc. as needed.

## Security
- Never commit AWS credentials, tokens, or internal certificates.
- Work repos are internal — still treat secrets as if they could be exposed.
