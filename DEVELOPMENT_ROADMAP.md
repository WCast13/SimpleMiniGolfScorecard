# SimpleMiniGolfScorecard - Development Roadmap- As Of 11/14/25

**Project Context:** Solo developer, TestFlight beta releases, moderate timeline (months), moderate stability requirements

**Current Status:** MVP functional - core game flow working (create players → create courses → start game → enter scores → view results)

---

## Version Roadmap

### v1.0 - Core Stats & Editing
- Edit player feature
- Player stats by course
- Average score per hole on each course

### v1.1 - Game Modes
- Match Play
- Team Match Play

### v1.2 - Long-term Challenges
- Breaking {goal score} challenge over multiple rounds
- Example: Breaking 30 challenge

### v1.3 - Enhancements
- Live Activities for score entry
- Sign In with Apple
- Settings screen

### v2.0 - Major Features
- UX/UI redesign
- Synced games between players
- Tournament functionality
- Live scoring between players

---

## 1. Git Branching Strategy

### Branch Structure
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

### Workflow
- `main` = stable enough for TestFlight (doesn't need to be perfect)
- Create feature branches for each major feature
- Merge to `main` when feature is functional (even if not polished)
- Tag releases: `v1.0.0`, `v1.1.0`, etc. when pushing to TestFlight
- For v2.0 major refactor, use a long-lived branch initially, then merge when ready

### Example Workflow
```bash
# Start new feature
git checkout main
git pull
git checkout -b feature/edit-player

# ... implement feature ...

git add .
git commit -m "Add edit player functionality"
git push origin feature/edit-player

# Create PR, review, merge to main
# Then tag for TestFlight release

git checkout main
git tag v1.0.0
git push origin v1.0.0
```

---

## 2. GitHub Project Management

### Issues Setup
One issue per feature with labels:
- **Version labels:** `v1.0`, `v1.1`, `v1.2`, `v1.3`, `v2.0`
- **Priority labels:** `priority-high`, `priority-medium`, `priority-low`
- **Type labels:** `feature`, `bug`, `enhancement`, `refactor`

### Milestones
- Milestone: `v1.0 - Core Stats & Editing`
- Milestone: `v1.1 - Game Modes`
- Milestone: `v1.2 - Long-term Challenges`
- Milestone: `v1.3 - Live Activities & Auth`
- Milestone: `v2.0 - Major UX/Sync Features`

### GitHub Projects Board (Optional)
Columns: Backlog → Ready → In Progress → Testing → Done
Group by milestone to see version progress

---

## 3. Code Organization Strategy

### Extended MVVM Structure
```
CoreAppMVVM/
├── Models/
│   ├── Player.swift (EXTEND for stats)
│   ├── Game.swift (EXTEND for game modes)
│   ├── Course.swift (EXTEND for course stats)
│   ├── Score.swift
│   ├── GameMode.swift (NEW - v1.1)
│   ├── PlayerStats.swift (NEW - v1.0)
│   ├── CourseStats.swift (NEW - v1.0)
│   ├── Challenge.swift (NEW - v1.2)
│   └── SyncedGame.swift (NEW - v2.0)
├── Views/
│   ├── Stats/ (NEW - v1.0)
│   │   ├── PlayerStatsView.swift
│   │   └── CourseStatsView.swift
│   ├── GameModes/ (NEW - v1.1)
│   │   ├── MatchPlayView.swift
│   │   └── TeamMatchPlayView.swift
│   ├── Challenges/ (NEW - v1.2)
│   │   └── ChallengeTrackerView.swift
│   ├── LiveActivities/ (NEW - v1.3)
│   └── Tournaments/ (NEW - v2.0)
├── ViewModels/
│   ├── PlayerStatsViewModel.swift (NEW - v1.0)
│   ├── GameModeViewModel.swift (NEW - v1.1)
│   └── ChallengeViewModel.swift (NEW - v1.2)
└── Services/ (NEW folder)
    ├── StatsService.swift (v1.0 - calculation logic)
    ├── GameModeService.swift (v1.1 - game mode rules)
    ├── SyncService.swift (v2.0 - multiplayer sync)
    └── AuthService.swift (v1.3 - Sign in with Apple)
```

**Key Principle:** Create new files/folders for new features rather than bloating existing ones.

---

## 4. Development Order & Timeline

### Phase 1: v1.0 Foundation (3-4 weeks)

#### 1. Edit Player Feature (2-3 days)
- Extend Player model if needed
- Update PlayerFormView to support editing
- Add edit button to PlayersListView

#### 2. Stats Data Models (3-4 days)
- Create PlayerStats model
- Create CourseStats model
- Build StatsService for calculations

#### 3. Stats Views (4-5 days)
- PlayerStatsView (avg score per course, per hole)
- Integrate into player detail screen
- CourseStatsView (course-level analytics)

**TestFlight Release: v1.0.0**

---

### Phase 2: v1.1 Game Modes (3-4 weeks)

#### 1. Game Mode Infrastructure (2-3 days)
- Create GameMode enum/model
- Extend Game model to include gameMode property
- Update NewGameView to select game mode

#### 2. Match Play Mode (3-4 days)
- GameModeService with match play rules
- Update ScorecardView for match play scoring
- Match play results view

#### 3. Team Match Play (3-4 days)
- Team model or grouping logic
- Team selection in NewGameView
- Team scoring display

**TestFlight Release: v1.1.0**

---

### Phase 3: v1.2 Long-term Challenges (2-3 weeks)

#### 1. Challenge Model (2 days)
- Challenge model (goal score, progress tracking)
- Link to multiple games

#### 2. Challenge Views (3-4 days)
- Create challenge interface
- Progress tracking UI
- Challenge results/completion

**TestFlight Release: v1.2.0**

---

### Phase 4: v1.3 Enhancements (3-4 weeks)

These are independent and can be built in any order:

#### Live Activities (5-7 days)
- Complex, needs iOS 16.1+
- ActivityKit integration
- Lock screen score entry widget

#### Sign In with Apple (2-3 days)
- AuthService implementation
- Sign-in UI
- User profile management

#### Settings Screen (2-3 days)
- App preferences
- About section
- User settings

**TestFlight Release: v1.3.0**

---

### Phase 5: v2.0 Major Refactor (10-14 weeks)

**Work on separate branch initially: `v2.0-refactor`**

#### UX/UI Redesign (2-3 weeks)
- New design system
- Updated navigation
- Enhanced visual design

#### Synced Games/Multiplayer (3-4 weeks)
- Real-time sync architecture
- Multiplayer game sessions
- Conflict resolution

#### Tournament Functionality (2-3 weeks)
- Tournament model
- Bracket/leaderboard systems
- Multi-round management

#### Live Scoring (2-3 weeks)
- Real-time score updates between players
- Push notifications
- Live leaderboards

**TestFlight Release: v2.0.0**

---

### Total Timeline Estimate
- **v1.0-1.3:** 8-12 weeks
- **v2.0:** 10-14 weeks
- **Overall:** 4-6 months

---

## 5. Feature Flags (Optional)

Mostly avoid feature flags for v1.0-1.3. Consider using them only for v2.0 features:

```swift
// FeatureFlags.swift
struct FeatureFlags {
    static let enableSyncedGames = false
    static let enableTournaments = false
    static let enableLiveScoring = false
}

// In view
if FeatureFlags.enableSyncedGames {
    // Show synced game option
}
```

This lets you merge v2.0 work to main without exposing it to TestFlight users.

---

## 6. Testing Strategy

### Per Version TestFlight Releases

**v1.0:** Focus on stats calculation accuracy
**v1.1:** Test different game modes thoroughly
**v1.2:** Long-term challenge tracking validation
**v1.3:** Live Activities on lock screen testing
**v2.0:** Extended beta for sync features

### Testing Checklist per Release
1. Manual testing of new features
2. Regression testing of core flow (create game → score → results)
3. CloudKit sync verification
4. TestFlight beta release
5. Collect feedback, iterate

### Recommended Unit Tests
- `StatsService` calculation accuracy
- `GameModeService` scoring rules
- Challenge progress tracking
- Sync conflict resolution (v2.0)

---

## 7. Risk Management

### Potential Blockers

**Live Activities**
- Complex, iOS 16.1+ requirement
- Needs ActivityKit framework
- **Mitigation:** Research early in v1.3, prototype before committing

**Sign In with Apple**
- Requires Apple Developer Program enrollment
- **Mitigation:** Ensure account is set up before starting

**Synced Games**
- Requires real-time sync architecture (complex)
- **Mitigation:** Prototype sync architecture before committing to v2.0

**v2.0 UX Changes**
- Might break existing flows
- **Mitigation:** Keep v2.0 on separate branch until stable, use feature flags

---

## 8. Documentation To Create

### Recommended Files
1. `ROADMAP.md` - High-level version plans and progress
2. `ARCHITECTURE.md` - MVVM structure explanation
3. `CONTRIBUTING.md` - How to add new features (for future reference)
4. Update `FILE_STRUCTURE.md` as you add folders

---

## 9. Immediate Next Steps

### Recommended Approach

**Week 1:**
1. Set up GitHub issues/milestones (1 hour)
2. Start "Edit Player" feature (quick win, 2-3 days)

**Week 2-3:**
- Build stats models + StatsService
- Create PlayerStatsView and CourseStatsView

**Week 4:**
- Polish and bug fixes
- TestFlight v1.0 release

**Weeks 5-8:** v1.1 game modes

**Weeks 9-12:** v1.2 challenges + v1.3 features

**Months 4-6:** v2.0 major work

---

## 10. Current Architecture Overview

### What's Already Working
- Core game flow: create players → create courses → start game → enter scores → view results
- Data persistence with CloudKit sync
- MVVM architecture properly structured
- Multi-screen navigation with TabView
- Scoring logic and calculations
- Game state management

### What Needs Integration
- NewGameViewModel (exists but not fully used)
- CourseFormViewModel (exists but not integrated)
- Some ViewModels need better integration with Views

### Missing Core Features (Pre-v1.0)
1. Error handling for CloudKit sync failures
2. Offline mode indicators
3. Edit game/scores after creation
4. Search/filter in lists
5. Accessibility labels
6. Unit test coverage

---

## 11. Success Metrics

### v1.0 Success Criteria
- Edit player functionality works
- Stats calculations are accurate
- Users can view their performance by course and hole
- No major CloudKit sync issues

### v1.1 Success Criteria
- Match Play scoring works correctly
- Team Match Play supports multiple team configurations
- Game mode selection is intuitive

### v1.2 Success Criteria
- Challenges track progress across multiple games
- Users complete and share challenge achievements
- Challenge UI is motivating

### v1.3 Success Criteria
- Live Activities work on lock screen
- Sign In with Apple authentication works
- Settings persist correctly

### v2.0 Success Criteria
- Synced games work reliably between players
- Tournament functionality handles multi-round competitions
- Live scoring updates in real-time
- New UX improves user satisfaction

---

## Quick Reference

### Current Git Commands
```bash
# Check status
git status

# Create feature branch
git checkout -b feature/feature-name

# Commit changes
git add .
git commit -m "Description of changes"

# Push to remote
git push origin feature/feature-name

# Tag release
git tag v1.0.0
git push origin v1.0.0

# Merge to main
git checkout main
git merge feature/feature-name
git push origin main
```

### Project Structure
```
SimpleMiniGolfScorecard/
├── App/                    # App entry point
├── CoreAppMVVM/           # Main app code (MVVM)
├── Helpers/               # Utilities
├── Resources/             # Assets, Info.plist
└── SimpleMiniGolfScorecard.xcodeproj/
```

---

**Last Updated:** 2025-11-14
**Version:** 1.0
**Status:** In Planning Phase
