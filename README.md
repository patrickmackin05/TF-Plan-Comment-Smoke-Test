# TF Plan Comment — Smoke Test

Throwaway repo to verify [TF-Plan-Comment](https://github.com/patrickmackin05/TF-Plan-Comment) posts and updates PR comments correctly.

Uses the `local` provider only — no cloud credentials required.

## What's in this repo

| Branch | Purpose |
|--------|---------|
| `main` | Baseline Terraform + committed state (2 `local_file` resources) |
| `test/plan-comment-smoke` | PR branch with create, update, and destroy changes |

## Smoke test checklist

1. **Open the PR** — `test/plan-comment-smoke` → `main`
2. **Wait for the workflow** — check the Actions tab
3. **Confirm the bot comment** appears on the PR with plan summary
4. **Push a second commit** to the PR branch (see below)
5. **Confirm the same comment is updated**, not duplicated

### Optional second push (comment update test)

On branch `test/plan-comment-smoke`, change `app_config` content again:

```hcl
content = "version=3\nenvironment=dev"
```

Commit and push. The workflow re-runs and should update the existing comment.

## Expected plan on the PR

The `test/plan-comment-smoke` branch should produce:

- **Update** — `local_file.app_config` (version 1 → 2)
- **Create** — `local_file.feature_flag` (new resource)
- **Destroy** — `local_file.legacy_marker` (removed)

## Setup (if starting fresh)

```bash
git clone https://github.com/patrickmackin05/TF-Plan-Comment-Smoke-Test.git
cd TF-Plan-Comment-Smoke-Test
git checkout test/plan-comment-smoke
gh pr create --base main --head test/plan-comment-smoke --title "Smoke test TF Plan Comment"
```

## Notes

- `terraform.tfstate` is committed intentionally so plans show realistic diffs (test repo only).
- Requires `patrickmackin05/TF-Plan-Comment@v1` to be published before the workflow will succeed.
