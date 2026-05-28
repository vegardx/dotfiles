# dnb.ghe.com — DNB work

## Context
DNB GitHub Enterprise Cloud with Data Residency. All work repos live at
https://dnb.ghe.com. Do not reference or cross-link personal github.com repos
from work code, CI, or documentation.

## Artifact management
Nexus: https://nexus.tech.dnb.no — use for published packages, container
images, and internal dependencies.

## GitHub Actions runners

### GitHub-hosted
| Runner | vCPUs | Memory | Disk | Notes |
|---|---|---|---|---|
| `ubuntu-latest` | 4 | 16 GB | 14 GB | Dedicated VM, x64 |
| `ubuntu-slim` | 1 | 5 GB | 14 GB | Container on shared VM, x64. Max 15 min per job. |

### kindling (DNB-hosted — prefer for most jobs)
Ephemeral Firecracker VMs, sub-second boot, shared pool. Default choice for
general CI. Has direct line of sight to Nexus (https://nexus.tech.dnb.no) and
other publicly reachable DNB infrastructure.

```yaml
runs-on: kindling                             # 1 vCPU arm64, default
runs-on: [kindling, vcpu=2]                   # 2 vCPU
runs-on: [kindling, vcpu=4, arch=amd64]       # 4 vCPU x86
runs-on: [kindling, vcpu=8, arch=arm64]       # 8 vCPU ARM
```

Size tiers — `vcpu=` label selects the tier (defaults to `vcpu=1`):
| Label | vCPUs | Memory | Disk |
|---|---|---|---|
| `vcpu=1` | 1 | 3.8 GiB | 59 GiB |
| `vcpu=2` | 2 | 7.7 GiB | 118 GiB |
| `vcpu=4` | 4 | 15.4 GiB | 237 GiB |
| `vcpu=8` | 8 | 30.7 GiB | 474 GiB |

Architecture: `arch=arm64` (default) or `arch=amd64`.

### huginn (DNB-hosted — use when job needs private AWS network access)
Event-driven orchestrator, multi-cloud, slower than kindling. Required when
the job must reach resources inside a private AWS VPC that are not reachable
from the public internet — e.g. private RDS endpoints, internal services with
no public exposure.

Nexus (https://nexus.tech.dnb.no) is reachable from kindling and
GitHub-hosted runners directly — huginn is not needed for that.

```yaml
runs-on: huginn                                           # 1 vCPU arm, defaults
runs-on: [huginn, min-vcpu=4]                             # 4+ vCPU arm, general
runs-on: [huginn, min-vcpu=8, arch=x64, optimized=compute] # 8+ vCPU x64, compute
runs-on: [huginn, min-vcpu=4, capacity-type=on-demand]    # force on-demand
runs-on: [huginn, route=group, route-key=production]      # specific spoke group
```

Key labels:
| Label | Values | Default | Notes |
|---|---|---|---|
| `min-vcpu=X` | 1, 2, 4, 8, 16, 32, 48, 64 | 1 | Minimum vCPU count |
| `arch=X` | `arm`, `x64` | `arm` | x64 min-vcpu auto-adjusted to 2 |
| `optimized=X` | `general`, `compute`, `memory` | `general` | vCPU:memory ratio (1:4, 1:2, 1:8) |
| `capacity-type=X` | `spot`, `on-demand` | `spot` | Spot with on-demand fallback by default |
| `route=group` + `route-key=X` | spoke group name | — | Route to a named spoke pool |

## AWS access — OIDC federation

Never use long-lived AWS credentials in workflows. All AWS access uses OIDC
federation with short-lived tokens.

Self-service setup via `dnb.ghe.com/dnb-tooling/github-oidc-federation`:
fork the repo, add your role config under `configs/<account-name>/`, and open
a PR. Auto-merges after validation (or after account owner approval if you are
not an owner).

Common role conventions:
- `continuous-integration` — read-only, for PRs and non-deploy jobs
- `continuous-deployment` — deploy access, scoped to a deployment environment

Any job that authenticates to AWS needs `permissions: id-token: write`:

```yaml
jobs:
  deploy:
    environment: DNB-MyApp-Dev
    runs-on: kindling
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: aws-actions/configure-aws-credentials@v6
        with:
          aws-region: ${{ vars.AWS_REGION }}
          role-to-assume: ${{ vars.AWS_ROLE_ARN_CONTINUOUS_DEPLOYMENT }}
```

## Deployment environments

Enable `deploymentEnvironments` in `features.json` in your OIDC federation
config to have GitHub environments created and maintained automatically.
Environment names come from `:environment:<name>` patterns in `subject_claims`.

Variables auto-populated on each environment:
- `AWS_ACCOUNT_ID` — AWS account ID
- `AWS_ROLE_ARN_<ROLE_NAME>` — ARN for each configured role
- `AWS_REGION` / `AWS_REGIONS` — when `defaultRegion` is set in `features.json`

The `environment:` field in the workflow must match the name exactly.

Note: environment-scoped variables are not available in `strategy.matrix`
expressions. Use a two-job pattern — first job reads `vars.AWS_REGIONS` and
passes it as a job output, second job uses it in the matrix.

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
