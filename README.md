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

## Setup

### 1. Create the GitHub repo and push

Create a new **public** repo at https://github.com/new named `TF-Plan-Comment-Smoke-Test` (no README/license — this repo has them).

Then from this folder:

```bash
cd "/Users/patrickmackin/non-work repos/TF-Plan-Comment-Smoke-Test"
git remote add origin https://github.com/patrickmackin05/TF-Plan-Comment-Smoke-Test.git
git push -u origin main
git push -u origin test/plan-comment-smoke
```

### 2. Open the PR

```bash
gh pr create --base main --head test/plan-comment-smoke \
  --title "Smoke test: TF Plan Comment" \
  --body "Verifies plan comment posting and update-on-push behavior."
```

Or open manually: https://github.com/patrickmackin05/TF-Plan-Comment-Smoke-Test/compare/main...test/plan-comment-smoke

### 3. Run the checklist above

Requires `patrickmackin05/TF-Plan-Comment@v1` to be published. If the workflow fails because the release tag doesn't exist yet, temporarily change the workflow to `@main` and push.

## Notes

- `terraform.tfstate` is committed intentionally so plans show realistic diffs (test repo only).
- Requires `patrickmackin05/TF-Plan-Comment@v1` to be published before the workflow will succeed.
