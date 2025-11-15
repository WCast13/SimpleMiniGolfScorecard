# Git Workflow - Quick Reference

## Branch Structure
```
main (stable, TestFlight releases)
  ├── feature/edit-player
  ├── feature/player-stats
  ├── feature/match-play
  ├── feature/team-match-play
  ├── feature/breaking-challenge
  ├── feature/live-activities
  ├── feature/sign-in-apple
  └── v2.0-refactor (long-lived branch for major changes)
```

## Starting a New Feature

1. **Ensure main is up to date:**
   ```bash
   git checkout main
   git pull
   ```

2. **Create feature branch:**
   ```bash
   git checkout -b feature/feature-name
   ```
   Example: `git checkout -b feature/edit-player`

3. **Work on your feature:**
   - Make changes
   - Test functionality
   - Commit frequently with descriptive messages

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "Descriptive message about changes"
   ```

5. **Push to remote:**
   ```bash
   git push origin feature/feature-name
   ```

## Merging to Main

### Option 1: Direct Merge (Simple)
```bash
git checkout main
git pull
git merge feature/feature-name
git push origin main
```

### Option 2: Pull Request (Recommended)
1. Push your feature branch to GitHub
2. Create PR on GitHub: `https://github.com/WCast13/SimpleMiniGolfScorecard/pulls`
3. Review changes
4. Merge via GitHub interface
5. Pull updated main locally:
   ```bash
   git checkout main
   git pull
   ```

## Creating a Release Tag

After merging a feature to main, tag for TestFlight:

```bash
git checkout main
git tag v1.0.0
git push origin v1.0.0
```

Version numbering:
- `v1.0.0` - First TestFlight release
- `v1.1.0` - Added game modes
- `v1.2.0` - Added challenges
- `v1.3.0` - Added live activities & auth
- `v2.0.0` - Major redesign & multiplayer

## Common Commands

### Check status
```bash
git status
git log --oneline -5  # See last 5 commits
```

### Create and switch to new branch
```bash
git checkout -b feature/new-feature
```

### Switch between branches
```bash
git checkout main
git checkout feature/edit-player
```

### Update your branch with latest main
```bash
git checkout feature/your-feature
git merge main
# Or use rebase for cleaner history:
git rebase main
```

### Delete a branch (after merging)
```bash
git branch -d feature/feature-name       # Delete local
git push origin --delete feature/feature-name  # Delete remote
```

## Best Practices

1. **Commit often** - Small, focused commits are better
2. **Descriptive messages** - Explain what and why, not just what
3. **Pull before push** - Always pull latest changes before pushing
4. **Test before merging** - Ensure features work before merging to main
5. **One feature per branch** - Keep branches focused on single features
6. **Clean up branches** - Delete merged branches to keep repo clean

## Branching Strategy Summary

- **main** = Stable, ready for TestFlight (doesn't need to be perfect)
- **feature/** = Individual feature development
- **v2.0-refactor** = Long-lived branch for major v2.0 work

Merge to main when features are functional, even if not fully polished. Tag releases when pushing to TestFlight.

---

For more details, see [DEVELOPMENT_ROADMAP.md](./DEVELOPMENT_ROADMAP.md)
