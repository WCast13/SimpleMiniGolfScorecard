#!/bin/bash

# SimpleMiniGolfScorecard - GitHub Organization Setup Script
# Run this after authenticating with: gh auth login

echo "🎯 Setting up GitHub organization for SimpleMiniGolfScorecard..."
echo ""

# Repository owner and name
REPO="WCast13/SimpleMiniGolfScorecard"

# ============================================
# 1. CREATE LABELS
# ============================================
echo "📋 Creating labels..."

# Version labels
gh label create "v1.0" --description "Version 1.0 - Core Stats & Editing" --color "0e8a16" --repo $REPO 2>/dev/null || echo "  ✓ v1.0 label already exists"
gh label create "v1.1" --description "Version 1.1 - Game Modes" --color "1d76db" --repo $REPO 2>/dev/null || echo "  ✓ v1.1 label already exists"
gh label create "v1.2" --description "Version 1.2 - Long-term Challenges" --color "5319e7" --repo $REPO 2>/dev/null || echo "  ✓ v1.2 label already exists"
gh label create "v1.3" --description "Version 1.3 - Live Activities & Auth" --color "f9d0c4" --repo $REPO 2>/dev/null || echo "  ✓ v1.3 label already exists"
gh label create "v2.0" --description "Version 2.0 - Major UX/Sync Features" --color "d93f0b" --repo $REPO 2>/dev/null || echo "  ✓ v2.0 label already exists"

# Priority labels
gh label create "priority-high" --description "High priority" --color "d73a4a" --repo $REPO 2>/dev/null || echo "  ✓ priority-high label already exists"
gh label create "priority-medium" --description "Medium priority" --color "fbca04" --repo $REPO 2>/dev/null || echo "  ✓ priority-medium label already exists"
gh label create "priority-low" --description "Low priority" --color "0e8a16" --repo $REPO 2>/dev/null || echo "  ✓ priority-low label already exists"

# Type labels
gh label create "feature" --description "New feature" --color "a2eeef" --repo $REPO 2>/dev/null || echo "  ✓ feature label already exists"
gh label create "enhancement" --description "Enhancement to existing feature" --color "84b6eb" --repo $REPO 2>/dev/null || echo "  ✓ enhancement label already exists"
gh label create "refactor" --description "Code refactoring" --color "d4c5f9" --repo $REPO 2>/dev/null || echo "  ✓ refactor label already exists"

echo "✅ Labels created!"
echo ""

# ============================================
# 2. CREATE MILESTONES
# ============================================
echo "🎯 Creating milestones..."

gh api repos/$REPO/milestones -f title="v1.0 - Core Stats & Editing" -f description="Edit player feature, player stats by course, avg score per hole on each course" --silent 2>/dev/null || echo "  ✓ v1.0 milestone already exists"
gh api repos/$REPO/milestones -f title="v1.1 - Game Modes" -f description="Match Play and Team Match Play game modes" --silent 2>/dev/null || echo "  ✓ v1.1 milestone already exists"
gh api repos/$REPO/milestones -f title="v1.2 - Long-term Challenges" -f description="Breaking goal score challenge over multiple rounds" --silent 2>/dev/null || echo "  ✓ v1.2 milestone already exists"
gh api repos/$REPO/milestones -f title="v1.3 - Live Activities & Auth" -f description="Live Activities, Sign In with Apple, Settings" --silent 2>/dev/null || echo "  ✓ v1.3 milestone already exists"
gh api repos/$REPO/milestones -f title="v2.0 - Major UX/Sync Features" -f description="UX/UI redesign, synced games, tournaments, live scoring" --silent 2>/dev/null || echo "  ✓ v2.0 milestone already exists"

echo "✅ Milestones created!"
echo ""

# ============================================
# 3. CREATE ISSUES
# ============================================
echo "📝 Creating issues..."

# v1.0 Issues
gh issue create --repo $REPO --title "Edit Player Feature" --body "## Description
Add ability to edit existing players after creation.

## Tasks
- [ ] Update PlayerFormView to support editing mode
- [ ] Add edit button to PlayersListView
- [ ] Add edit functionality to player detail view
- [ ] Ensure player edits sync via CloudKit

## Acceptance Criteria
- Users can edit player name
- Users can change ball color preference
- Changes persist and sync across devices" --label "v1.0,feature,priority-high" 2>/dev/null || echo "  ✓ Edit Player Feature issue already exists"

gh issue create --repo $REPO --title "Player Stats Data Models" --body "## Description
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
- CloudKit sync supports stats models" --label "v1.0,feature,priority-high" 2>/dev/null || echo "  ✓ Player Stats Data Models issue already exists"

gh issue create --repo $REPO --title "Player Stats Views" --body "## Description
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
- UI is intuitive and visually appealing" --label "v1.0,feature,priority-high" 2>/dev/null || echo "  ✓ Player Stats Views issue already exists"

# v1.1 Issues
gh issue create --repo $REPO --title "Game Mode Infrastructure" --body "## Description
Build foundational infrastructure for supporting multiple game modes.

## Tasks
- [ ] Create GameMode enum/model
- [ ] Extend Game model to include gameMode property
- [ ] Update NewGameView to allow game mode selection
- [ ] Ensure CloudKit sync supports game modes

## Acceptance Criteria
- Game mode can be selected when creating new game
- Game mode is stored with game data
- Existing games default to standard mode" --label "v1.1,feature,priority-high" 2>/dev/null || echo "  ✓ Game Mode Infrastructure issue already exists"

gh issue create --repo $REPO --title "Match Play Game Mode" --body "## Description
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
- Final match result shows overall winner" --label "v1.1,feature,priority-high" 2>/dev/null || echo "  ✓ Match Play Game Mode issue already exists"

gh issue create --repo $REPO --title "Team Match Play Game Mode" --body "## Description
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
- Results show winning team" --label "v1.1,feature,priority-medium" 2>/dev/null || echo "  ✓ Team Match Play Game Mode issue already exists"

# v1.2 Issues
gh issue create --repo $REPO --title "Challenge Model & Infrastructure" --body "## Description
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
- Progress persists across devices" --label "v1.2,feature,priority-medium" 2>/dev/null || echo "  ✓ Challenge Model & Infrastructure issue already exists"

gh issue create --repo $REPO --title "Challenge Tracker Views" --body "## Description
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
- Completion is celebrated appropriately" --label "v1.2,feature,priority-medium" 2>/dev/null || echo "  ✓ Challenge Tracker Views issue already exists"

# v1.3 Issues
gh issue create --repo $REPO --title "Live Activities Integration" --body "## Description
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
- Works on iOS 16.1+" --label "v1.3,feature,priority-medium" 2>/dev/null || echo "  ✓ Live Activities Integration issue already exists"

gh issue create --repo $REPO --title "Sign In with Apple" --body "## Description
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
- User data properly associated with account" --label "v1.3,feature,priority-medium" 2>/dev/null || echo "  ✓ Sign In with Apple issue already exists"

gh issue create --repo $REPO --title "Settings Screen" --body "## Description
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
- About section shows app version and info" --label "v1.3,feature,priority-low" 2>/dev/null || echo "  ✓ Settings Screen issue already exists"

# v2.0 Issues
gh issue create --repo $REPO --title "UX/UI Redesign" --body "## Description
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
- Consistent design language throughout" --label "v2.0,enhancement,priority-high" 2>/dev/null || echo "  ✓ UX/UI Redesign issue already exists"

gh issue create --repo $REPO --title "Synced Multiplayer Games" --body "## Description
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
- Works reliably across devices" --label "v2.0,feature,priority-high" 2>/dev/null || echo "  ✓ Synced Multiplayer Games issue already exists"

gh issue create --repo $REPO --title "Tournament Functionality" --body "## Description
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
- Tournament results displayed clearly" --label "v2.0,feature,priority-medium" 2>/dev/null || echo "  ✓ Tournament Functionality issue already exists"

gh issue create --repo $REPO --title "Live Scoring Between Players" --body "## Description
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
- Works even with poor connectivity" --label "v2.0,feature,priority-medium" 2>/dev/null || echo "  ✓ Live Scoring Between Players issue already exists"

echo "✅ Issues created!"
echo ""

# ============================================
# SUMMARY
# ============================================
echo "🎉 GitHub organization setup complete!"
echo ""
echo "Summary:"
echo "  - Labels: 11 created (versions, priorities, types)"
echo "  - Milestones: 5 created (v1.0 through v2.0)"
echo "  - Issues: 15 created (all planned features)"
echo ""
echo "Next steps:"
echo "  1. Visit https://github.com/$REPO/issues to view your issues"
echo "  2. Visit https://github.com/$REPO/milestones to view your milestones"
echo "  3. Consider creating a GitHub Projects board at https://github.com/$REPO/projects"
echo ""
echo "Happy coding! 🚀"
