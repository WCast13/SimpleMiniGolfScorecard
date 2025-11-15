# GitHub Organization Setup - Manual Guide

This guide helps you manually set up GitHub issues, milestones, and labels through the web interface.

**Repository:** https://github.com/WCast13/SimpleMiniGolfScorecard

---

## Option 1: Automated Setup (Recommended)

1. Authenticate with GitHub CLI:
   ```bash
   gh auth login
   ```
   Follow the prompts to authenticate.

2. Run the setup script:
   ```bash
   chmod +x setup-github-organization.sh
   ./setup-github-organization.sh
   ```

This will automatically create all labels, milestones, and issues.

---

## Option 2: Manual Setup

If you prefer to set up manually through the GitHub web interface:

### Step 1: Create Labels

Go to: https://github.com/WCast13/SimpleMiniGolfScorecard/labels

#### Version Labels
- **v1.0** - Color: `#0e8a16` (green) - Description: "Version 1.0 - Core Stats & Editing"
- **v1.1** - Color: `#1d76db` (blue) - Description: "Version 1.1 - Game Modes"
- **v1.2** - Color: `#5319e7` (purple) - Description: "Version 1.2 - Long-term Challenges"
- **v1.3** - Color: `#f9d0c4` (light pink) - Description: "Version 1.3 - Live Activities & Auth"
- **v2.0** - Color: `#d93f0b` (red) - Description: "Version 2.0 - Major UX/Sync Features"

#### Priority Labels
- **priority-high** - Color: `#d73a4a` (dark red) - Description: "High priority"
- **priority-medium** - Color: `#fbca04` (yellow) - Description: "Medium priority"
- **priority-low** - Color: `#0e8a16` (green) - Description: "Low priority"

#### Type Labels
- **feature** - Color: `#a2eeef` (light blue) - Description: "New feature"
- **enhancement** - Color: `#84b6eb` (medium blue) - Description: "Enhancement to existing feature"
- **refactor** - Color: `#d4c5f9` (light purple) - Description: "Code refactoring"

---

### Step 2: Create Milestones

Go to: https://github.com/WCast13/SimpleMiniGolfScorecard/milestones

1. **v1.0 - Core Stats & Editing**
   - Description: "Edit player feature, player stats by course, avg score per hole on each course"

2. **v1.1 - Game Modes**
   - Description: "Match Play and Team Match Play game modes"

3. **v1.2 - Long-term Challenges**
   - Description: "Breaking goal score challenge over multiple rounds"

4. **v1.3 - Live Activities & Auth**
   - Description: "Live Activities, Sign In with Apple, Settings"

5. **v2.0 - Major UX/Sync Features**
   - Description: "UX/UI redesign, synced games, tournaments, live scoring"

---

### Step 3: Create Issues

Go to: https://github.com/WCast13/SimpleMiniGolfScorecard/issues/new

Create the following issues (copy/paste the title and description for each):

---

#### v1.0 Issue #1: Edit Player Feature

**Labels:** `v1.0`, `feature`, `priority-high`
**Milestone:** v1.0 - Core Stats & Editing

**Description:**
```markdown
## Description
Add ability to edit existing players after creation.

## Tasks
- [ ] Update PlayerFormView to support editing mode
- [ ] Add edit button to PlayersListView
- [ ] Add edit functionality to player detail view
- [ ] Ensure player edits sync via CloudKit

## Acceptance Criteria
- Users can edit player name
- Users can change ball color preference
- Changes persist and sync across devices
```

---

#### v1.0 Issue #2: Player Stats Data Models

**Labels:** `v1.0`, `feature`, `priority-high`
**Milestone:** v1.0 - Core Stats & Editing

**Description:**
```markdown
## Description
Create data models and services for tracking player statistics.

## Tasks
- [ ] Create PlayerStats model with SwiftData
- [ ] Create CourseStats model with SwiftData
- [ ] Build StatsService for calculations
- [ ] Implement avg score per course calculation
- [ ] Implement avg score per hole calculation
- [ ] Add relationships to existing models

## Acceptance Criteria
- Stats accurately track player performance
- Stats update automatically after games
- CloudKit sync supports stats models
```

---

#### v1.0 Issue #3: Player Stats Views

**Labels:** `v1.0`, `feature`, `priority-high`
**Milestone:** v1.0 - Core Stats & Editing

**Description:**
```markdown
## Description
Create UI views to display player statistics.

## Tasks
- [ ] Create PlayerStatsView showing stats by course
- [ ] Show average score per hole on each course
- [ ] Integrate stats view into player detail screen
- [ ] Create CourseStatsView for course-level analytics
- [ ] Add charts/visualizations for stats

## Acceptance Criteria
- Users can view their stats by course
- Stats show average per hole
- UI is intuitive and visually appealing
```

---

#### v1.1 Issue #1: Game Mode Infrastructure

**Labels:** `v1.1`, `feature`, `priority-high`
**Milestone:** v1.1 - Game Modes

**Description:**
```markdown
## Description
Build foundational infrastructure for supporting multiple game modes.

## Tasks
- [ ] Create GameMode enum/model
- [ ] Extend Game model to include gameMode property
- [ ] Update NewGameView to allow game mode selection
- [ ] Ensure CloudKit sync supports game modes

## Acceptance Criteria
- Game mode can be selected when creating new game
- Game mode is stored with game data
- Existing games default to standard mode
```

---

#### v1.1 Issue #2: Match Play Game Mode

**Labels:** `v1.1`, `feature`, `priority-high`
**Milestone:** v1.1 - Game Modes

**Description:**
```markdown
## Description
Implement Match Play scoring mode.

## Tasks
- [ ] Create GameModeService with match play rules
- [ ] Update ScorecardView for match play scoring display
- [ ] Create match play results view
- [ ] Implement hole-by-hole win/loss/tie tracking
- [ ] Show match score (holes up/down)

## Acceptance Criteria
- Match play scoring works correctly
- Users understand who won each hole
- Final match result shows overall winner
```

---

#### v1.1 Issue #3: Team Match Play Game Mode

**Labels:** `v1.1`, `feature`, `priority-medium`
**Milestone:** v1.1 - Game Modes

**Description:**
```markdown
## Description
Implement Team Match Play with team grouping.

## Tasks
- [ ] Create team grouping logic or Team model
- [ ] Add team selection in NewGameView
- [ ] Implement team scoring calculations
- [ ] Update scorecard for team display
- [ ] Create team results view

## Acceptance Criteria
- Users can create teams of players
- Team scores calculated correctly
- Results show winning team
```

---

#### v1.2 Issue #1: Challenge Model & Infrastructure

**Labels:** `v1.2`, `feature`, `priority-medium`
**Milestone:** v1.2 - Long-term Challenges

**Description:**
```markdown
## Description
Create data model for long-term challenges (e.g., Breaking 30).

## Tasks
- [ ] Create Challenge model with SwiftData
- [ ] Link challenges to multiple games
- [ ] Implement challenge progress tracking
- [ ] Add CloudKit sync support for challenges
- [ ] Create challenge goal/completion logic

## Acceptance Criteria
- Challenges can track progress over multiple rounds
- Users can set goal scores
- Progress persists across devices
```

---

#### v1.2 Issue #2: Challenge Tracker Views

**Labels:** `v1.2`, `feature`, `priority-medium`
**Milestone:** v1.2 - Long-term Challenges

**Description:**
```markdown
## Description
Build UI for creating and tracking long-term challenges.

## Tasks
- [ ] Create challenge creation interface
- [ ] Build challenge progress tracking UI
- [ ] Show challenge completion status
- [ ] Add challenge history view
- [ ] Implement challenge notifications/celebrations

## Acceptance Criteria
- Users can create challenges with custom goals
- Progress is visible and motivating
- Completion is celebrated appropriately
```

---

#### v1.3 Issue #1: Live Activities Integration

**Labels:** `v1.3`, `feature`, `priority-medium`
**Milestone:** v1.3 - Live Activities & Auth

**Description:**
```markdown
## Description
Add Live Activities for score entry from lock screen.

## Tasks
- [ ] Set up ActivityKit framework
- [ ] Create Live Activity for active games
- [ ] Enable score entry from lock screen
- [ ] Update activity as game progresses
- [ ] Handle activity lifecycle

## Acceptance Criteria
- Live Activity appears during active games
- Users can enter scores from lock screen
- Activity updates reflect current game state
- Works on iOS 16.1+
```

---

#### v1.3 Issue #2: Sign In with Apple

**Labels:** `v1.3`, `feature`, `priority-medium`
**Milestone:** v1.3 - Live Activities & Auth

**Description:**
```markdown
## Description
Implement Sign In with Apple authentication.

## Tasks
- [ ] Create AuthService
- [ ] Add Sign In with Apple button
- [ ] Implement authentication flow
- [ ] Create user profile management
- [ ] Link CloudKit data to user account

## Acceptance Criteria
- Users can sign in with Apple ID
- Authentication persists across sessions
- User data properly associated with account
```

---

#### v1.3 Issue #3: Settings Screen

**Labels:** `v1.3`, `feature`, `priority-low`
**Milestone:** v1.3 - Live Activities & Auth

**Description:**
```markdown
## Description
Create app settings and preferences screen.

## Tasks
- [ ] Create SettingsView
- [ ] Add app preferences (theme, notifications, etc.)
- [ ] Add about section
- [ ] Add privacy/data management
- [ ] Implement settings persistence

## Acceptance Criteria
- Settings are accessible from main navigation
- Preferences persist across sessions
- About section shows app version and info
```

---

#### v2.0 Issue #1: UX/UI Redesign

**Labels:** `v2.0`, `enhancement`, `priority-high`
**Milestone:** v2.0 - Major UX/Sync Features

**Description:**
```markdown
## Description
Major redesign of app UX/UI for v2.0.

## Tasks
- [ ] Create new design system
- [ ] Update navigation structure
- [ ] Enhance visual design
- [ ] Improve user flows
- [ ] Update all views with new design

## Acceptance Criteria
- Modern, polished UI
- Improved user experience
- Consistent design language throughout
```

---

#### v2.0 Issue #2: Synced Multiplayer Games

**Labels:** `v2.0`, `feature`, `priority-high`
**Milestone:** v2.0 - Major UX/Sync Features

**Description:**
```markdown
## Description
Enable real-time synced games between multiple players.

## Tasks
- [ ] Design sync architecture
- [ ] Create SyncService
- [ ] Implement real-time game sessions
- [ ] Handle conflict resolution
- [ ] Build multiplayer game flow

## Acceptance Criteria
- Multiple players can join same game
- Scores sync in real-time
- Conflicts resolved gracefully
- Works reliably across devices
```

---

#### v2.0 Issue #3: Tournament Functionality

**Labels:** `v2.0`, `feature`, `priority-medium`
**Milestone:** v2.0 - Major UX/Sync Features

**Description:**
```markdown
## Description
Add tournament support with multi-round management.

## Tasks
- [ ] Create Tournament model
- [ ] Build bracket/leaderboard system
- [ ] Implement multi-round tracking
- [ ] Create tournament results view
- [ ] Add tournament management UI

## Acceptance Criteria
- Users can create tournaments
- Multiple rounds tracked correctly
- Leaderboards update in real-time
- Tournament results displayed clearly
```

---

#### v2.0 Issue #4: Live Scoring Between Players

**Labels:** `v2.0`, `feature`, `priority-medium`
**Milestone:** v2.0 - Major UX/Sync Features

**Description:**
```markdown
## Description
Enable live score updates between players during games.

## Tasks
- [ ] Implement real-time score updates
- [ ] Add push notifications for scores
- [ ] Create live leaderboard
- [ ] Build spectator mode
- [ ] Handle offline scenarios

## Acceptance Criteria
- Scores update live for all players
- Notifications sent on score entry
- Leaderboard reflects current standings
- Works even with poor connectivity
```

---

## Summary

After completing all steps, you'll have:
- **11 labels** (versions, priorities, types)
- **5 milestones** (v1.0 through v2.0)
- **15 issues** (all planned features)

**Next Steps:**
1. Visit your [Issues page](https://github.com/WCast13/SimpleMiniGolfScorecard/issues)
2. Visit your [Milestones page](https://github.com/WCast13/SimpleMiniGolfScorecard/milestones)
3. Consider creating a [GitHub Projects board](https://github.com/WCast13/SimpleMiniGolfScorecard/projects)

---

**Tip:** Use the automated script (`setup-github-organization.sh`) to save time!
