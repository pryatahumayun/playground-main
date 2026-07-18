# Git Emergency Cheatsheet


> The safest production rule is usually:
>
> **Do not rewrite shared branch history. Use `git revert` unless you are completely sure a reset is appropriate.**

---

# Quick Decision Guide

```text
Bad commit already pushed to a shared branch?
    ↓
Use git revert

Bad commit only exists locally?
    ↓
Use git reset

Need one specific good commit from another branch?
    ↓
Use git cherry-pick

Need to find a lost commit?
    ↓
Use git reflog
```

---

# First: Do Not Panic-Push 

Before changing anything:

```bash
git status
git branch --show-current
git log --oneline --decorate -10
```

Confirm:

- Which branch you are on
- Whether you have local changes
- Which commit caused the problem
- Whether the commit has already been pushed
- Whether other people may have pulled it

---

# Get the Latest Remote State

```bash
git fetch --all --prune
```

This updates your local view of remote branches without merging anything.

Check the remote branch history:

```bash
git log origin/main --oneline --decorate -10
```

Replace `main` with the correct branch name.

---

# Find the Bad Commit

Show recent commits:

```bash
git log --oneline --decorate -20
```

Show commits with author and date:

```bash
git log --pretty=format:"%h | %an | %ad | %s" --date=short -20
```

Show what changed in a commit:

```bash
git show <commit-hash>
```

Example:

```bash
git show a1b2c3d
```

Show only changed file names:

```bash
git show --name-only <commit-hash>
```

---

# Safest Fix for a Shared Branch: Revert

`git revert` creates a new commit that undoes an earlier commit.

It does not erase history.

This is usually the safest choice for:

- `main`
- `master`
- `develop`
- Release branches
- Shared environment branches
- Changes already deployed

## Revert One Commit

```bash
git checkout main
git pull
git revert <commit-hash>
git push origin main
```

Example:

```bash
git revert a1b2c3d
```

Git may open an editor for the revert commit message.

Save and close the editor to continue.

---

## Revert Without Opening the Editor

```bash
git revert <commit-hash> --no-edit
```

Example:

```bash
git revert a1b2c3d --no-edit
```

---

## Revert Multiple Commits

Revert commits one at a time, usually newest first:

```bash
git revert <newest-commit>
git revert <older-commit>
```

Or revert a range without committing each one separately:

```bash
git revert --no-commit <oldest-commit>^..<newest-commit>
git commit -m "Revert unapproved deployment changes"
git push
```

Example:

```bash
git revert --no-commit a1b2c3d^..f6e7d8c
git commit -m "Revert unapproved deployment changes"
```

---

# Revert a Merge Commit

A merge commit needs the `-m` option.

```bash
git revert -m 1 <merge-commit-hash>
```

Example:

```bash
git revert -m 1 a1b2c3d
```

`-m 1` usually means:

> Keep the first parent, usually the target branch, and undo the merged branch changes.

Check the merge parents before running it:

```bash
git show <merge-commit-hash>
```

Do not guess blindly with merge commits.

---

# Revert Through a New Branch and Pull Request

This is safer when branch protection exists.

```bash
git checkout main
git pull
git checkout -b revert/unapproved-change
git revert <commit-hash>
git push -u origin revert/unapproved-change
```

Then open a Pull Request.

Example branch name:

```text
revert/unapproved-prod-deployment
```

This gives everyone a clean audit trail.

---

# When Revert Has Conflicts

Git may stop and ask you to resolve conflicts.

Check the conflicted files:

```bash
git status
```

Fix the files, then stage them:

```bash
git add .
```

Continue the revert:

```bash
git revert --continue
```

Cancel the revert completely:

```bash
git revert --abort
```

---

# Undo a Local Commit That Was Not Pushed

Use `git reset` only when the commit is local or you are sure rewriting history is safe.

## Undo Commit but Keep Changes Staged

```bash
git reset --soft HEAD~1
```

Use this when the commit message was wrong or the commit needs to be rebuilt.

---

## Undo Commit and Keep Changes Unstaged

```bash
git reset HEAD~1
```

This is the default mixed reset.

Your file changes remain locally.

---

## Delete the Commit and Its Changes

```bash
git reset --hard HEAD~1
```

This permanently removes local changes from the working tree.

Be careful.

```text
--soft  = remove commit, keep staged changes
--mixed = remove commit, keep unstaged changes
--hard  = remove commit and changes
```

---

# Reset a Local Branch to Match Remote

Use this when your local branch is messy and you want it to match the remote exactly.

```bash
git fetch origin
git reset --hard origin/main
```

This deletes uncommitted local changes.

Check first:

```bash
git status
```

---

# Force Push Warning

Avoid this on shared branches:

```bash
git push --force
```

If rewriting history is absolutely required, use:

```bash
git push --force-with-lease
```

`--force-with-lease` is safer because it refuses to overwrite remote work you did not know about.

Still, do not use it casually on production or shared branches.

---

# Restore a File

## Restore One File to the Last Commit

```bash
git restore path/to/file
```

Example:

```bash
git restore appsettings.json
```

This discards uncommitted changes in that file.

---

## Restore One File from Another Commit

```bash
git restore --source <commit-hash> path/to/file
```

Example:

```bash
git restore --source a1b2c3d appsettings.json
```

Then commit the restored version:

```bash
git add appsettings.json
git commit -m "Restore appsettings.json from known good commit"
```

---

## Restore a File from the Remote Branch

```bash
git restore --source origin/main path/to/file
```

---

# Unstage a File

```bash
git restore --staged path/to/file
```

Example:

```bash
git restore --staged appsettings.json
```

The file remains changed locally, but it is removed from the staged commit.

---

# Save Work Before Emergency Fixes

Use stash when you have unfinished local work.

```bash
git stash push -m "WIP before emergency revert"
```

List stashes:

```bash
git stash list
```

Restore the latest stash:

```bash
git stash pop
```

Restore without deleting the stash entry:

```bash
git stash apply
```

Stash untracked files too:

```bash
git stash push -u -m "WIP before emergency revert"
```

---

# Recover a Lost Commit with Reflog

`git reflog` records where `HEAD` has recently been.

```bash
git reflog
```

Example output:

```text
a1b2c3d HEAD@{0}: reset: moving to HEAD~1
f6e7d8c HEAD@{1}: commit: Add deployment changes
```

Recover the lost commit by creating a branch:

```bash
git checkout -b recovery/found-commit f6e7d8c
```

Or cherry-pick it:

```bash
git cherry-pick f6e7d8c
```

---

# Cherry-Pick a Good Commit

Use cherry-pick when you need one specific commit from another branch.

```bash
git checkout target-branch
git pull
git cherry-pick <commit-hash>
```

Example:

```bash
git cherry-pick a1b2c3d
```

If there are conflicts:

```bash
git status
```

Resolve them, then:

```bash
git add .
git cherry-pick --continue
```

Cancel:

```bash
git cherry-pick --abort
```

---

# Compare Branches

Show commits that exist in one branch but not another:

```bash
git log main..feature-branch --oneline
```

Show file differences:

```bash
git diff main..feature-branch
```

Compare remote branches:

```bash
git diff origin/main..origin/feature-branch
```

Show only changed file names:

```bash
git diff --name-only origin/main..origin/feature-branch
```

---

# Find Who Changed Something

Show who last changed each line:

```bash
git blame path/to/file
```

Search commits that changed a specific line or word:

```bash
git log -S "search text" --oneline
```

Example:

```bash
git log -S "UseNewAuthenticationFlow" --oneline
```

Search commit messages:

```bash
git log --grep="deployment" --oneline
```

Search by author:

```bash
git log --author="Chris" --oneline
```

---

# Tag a Known Good Version

Create a tag before risky deployment work:

```bash
git tag known-good-prod-2026-07-14
git push origin known-good-prod-2026-07-14
```

Return to that version later:

```bash
git checkout known-good-prod-2026-07-14
```

Create a recovery branch from it:

```bash
git checkout -b recovery/known-good known-good-prod-2026-07-14
```

---

# Emergency Rollback Workflow

Use this when an unapproved commit reaches a shared branch.

```bash
git fetch --all --prune
git checkout main
git pull
git log --oneline --decorate -20
git show <bad-commit-hash>
git checkout -b revert/unapproved-change
git revert <bad-commit-hash> --no-edit
git push -u origin revert/unapproved-change
```

Then:

```text
1. Open a Pull Request
2. Review the revert
3. Merge the revert
4. Run the deployment pipeline
5. Confirm the environment is healthy
6. Record the original commit and revert commit
```

---

# Emergency Direct Revert

Only use this if the team allows direct pushes and the situation truly requires it.

```bash
git fetch origin
git checkout main
git pull
git revert <bad-commit-hash> --no-edit
git push origin main
```

This is still safer than resetting and force-pushing the branch.

---

# Verify the Revert

Check history:

```bash
git log --oneline --decorate -10
```

Check the changed files:

```bash
git show --stat HEAD
```

Compare against the commit before the bad change:

```bash
git diff <known-good-commit>..HEAD
```

Run tests:

```bash
dotnet test
```

Or for Node projects:

```bash
npm test
```

Then verify the deployment pipeline and environment.

---

# Git Commands I Should Avoid Using Blindly

```bash
git reset --hard
git clean -fd
git push --force
git rebase
git revert -m
```

These commands are useful, but they can destroy work or change shared history when used incorrectly.

---

# Branch Protection Recommendations

To stop direct deployments and surprise commits:

- Require Pull Requests for protected branches
- Require at least one reviewer
- Block direct pushes
- Require successful build validation
- Require linked work items
- Require comment resolution
- Restrict who can bypass policies
- Restrict who can manually run production deployments
- Require environment approvals
- Add deployment checks for production
- Keep branch and pipeline audit logs

---

# Azure DevOps Protection Ideas

For important branches:

```text
Repos
  ↓
Branches
  ↓
Branch Policies
```

Useful policies:

- Minimum number of reviewers
- Build validation
- Check for linked work items
- Check for comment resolution
- Limit merge types
- Automatically include required reviewers

For production environments:

```text
Pipelines
  ↓
Environments
  ↓
Approvals and Checks
```

Useful controls:

- Manual approval before production
- Exclusive lock
- Branch control
- Business-hours checks
- Required template checks
- Restricted pipeline permissions

---

# Commit Message Examples

```text
Revert unapproved production deployment
```

```text
Revert commit a1b2c3d due to failed deployment validation
```

```text
Restore configuration from known good version
```

```text
Rollback release after production regression
```

```text
Reapply approved changes through Pull Request
```

---

# Incident Notes Template

```markdown
## Git Deployment Incident

**Branch:**  
`main`

**Bad Commit:**  
`<commit-hash>`

**Author:**  
`<author>`

**Deployment Time:**  
`<date and time>`

**Problem:**  
Describe what failed or changed.

**Immediate Action:**  
Reverted commit `<commit-hash>` using commit `<revert-commit-hash>`.

**Validation:**  
- Build passed
- Tests passed
- Deployment completed
- Application health confirmed

**Follow-Up:**  
- Reapply required changes through a Pull Request
- Review branch permissions
- Add or update production approval checks
```

---

# Fast Reference

## Revert a pushed commit

```bash
git revert <commit-hash>
git push
```

## Undo a local commit but keep changes

```bash
git reset --soft HEAD~1
```

## Throw away a local commit and its changes

```bash
git reset --hard HEAD~1
```

## Restore a file

```bash
git restore path/to/file
```

## Find lost commits

```bash
git reflog
```

## Apply one specific commit

```bash
git cherry-pick <commit-hash>
```

## Save unfinished work

```bash
git stash push -u -m "WIP"
```

## Compare branches

```bash
git diff origin/main..origin/feature-branch
```

---

# Main Rule

```text
Already pushed to a shared branch?
Use revert.

Only local?
Reset may be okay.

Unsure?
Create a backup branch before doing anything.
```

Create a backup branch:

```bash
git branch backup/before-emergency-fix
```

