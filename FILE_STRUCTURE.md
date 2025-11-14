# SimpleMiniGolfScorecard - File Structure

## Overview
This project uses a **feature-based architecture** where files are organized by domain feature rather than technical layer.

## Directory Structure

```
SimpleMiniGolfScorecard/
├── App/                        # Application entry and root views
│   ├── SimpleMiniGolfScorecardApp.swift    # App entry point
│   └── ContentView.swift                    # Root navigation view
│
├── Features/                   # Feature modules organized by domain
│   ├── Courses/               # Course management feature
│   │   ├── Models/
│   │   │   └── Course.swift
│   │   ├── Views/
│   │   │   ├── CoursesListView.swift
│   │   │   ├── CourseDetailView.swift
│   │   │   ├── CourseFormView.swift
│   │   │   └── LocationPickerView.swift
│   │   └── ViewModels/
│   │       └── CourseFormViewModel.swift
│   │
│   ├── Players/               # Player management feature
│   │   ├── Models/
│   │   │   └── Player.swift
│   │   ├── Views/
│   │   │   ├── PlayersListView.swift
│   │   │   └── PlayerFormView.swift
│   │   └── ViewModels/
│   │       └── PlayerFormViewModel.swift
│   │
│   ├── Games/                 # Game management feature
│   │   ├── Models/
│   │   │   ├── Game.swift
│   │   │   └── Score.swift
│   │   ├── Views/
│   │   │   ├── GamesListView.swift
│   │   │   ├── NewGameView.swift
│   │   │   └── GameResultsView.swift
│   │   └── ViewModels/
│   │       └── NewGameViewModel.swift
│   │
│   └── Scoring/               # Scoring/Scorecard feature
│       ├── Views/
│       │   ├── ScorecardView.swift
│       │   ├── ScorecardTableView.swift
│       │   ├── ScorePickerView.swift
│       │   └── DetailedScorecard.swift
│       └── ViewModels/
│           └── ScorecardViewModel.swift
│
├── Core/                      # Shared/reusable code
│   ├── Helpers/              # Utility helpers
│   │   ├── DateFormatterHelper.swift
│   │   ├── PreviewHelper.swift
│   │   └── ScoreColorHelper.swift
│   ├── Utilities/            # App-wide utilities
│   │   └── SeedData.swift
│   └── Extensions/           # Swift extensions (future)
│
└── Resources/                 # Non-code assets
    ├── Assets.xcassets/      # Images, colors, icons
    └── Info.plist            # App configuration

SimpleMiniGolfScorecard.entitlements    # CloudKit entitlements
```

## Feature Breakdown

### 🏌️ Courses Feature (6 files)
**Purpose:** Manage golf courses
- **Model:** Course data structure with location support
- **Views:** List, detail, form, and location picker
- **ViewModel:** Form validation and save logic

### 👥 Players Feature (4 files)
**Purpose:** Manage players and their preferences
- **Model:** Player data with ball color preferences
- **Views:** List and form for player management
- **ViewModel:** Player form validation

### 🎮 Games Feature (5 files)
**Purpose:** Game session management
- **Models:** Game and Score data structures
- **Views:** List, creation, and results display
- **ViewModel:** Game creation flow

### 📊 Scoring Feature (5 files)
**Purpose:** Live scoring during gameplay
- **Views:** Scorecard, table, picker, detailed views
- **ViewModel:** Score management and state

### 🛠️ Core (4 files)
**Purpose:** Shared utilities across features
- **Helpers:** Reusable formatting and preview tools
- **Utilities:** Seed data for development

## Architecture Benefits

### ✅ Feature Isolation
Each feature is self-contained with its own Models, Views, and ViewModels. Changes to one feature don't affect others.

### ✅ Easy Navigation
Find all related code in one place. No jumping between Models/, Views/, and ViewModels/ folders.

### ✅ Scalability
Adding new features is straightforward:
```bash
Features/NewFeature/
├── Models/
├── Views/
└── ViewModels/
```

### ✅ Team Collaboration
Multiple developers can work on different features simultaneously with minimal conflicts.

### ✅ Clear Dependencies
It's easy to see which features depend on shared Core components vs. feature-specific code.

### ✅ Testability
Features can be unit tested independently without loading the entire app.

## File Organization Guidelines

### When to Add to a Feature
- Code specific to that domain feature
- Views that are only used within that feature
- Models that represent that domain concept

### When to Add to Core
- Utilities used by 2+ features
- Extensions on standard types (String, Date, etc.)
- Shared UI components
- App-wide constants

### When to Create a New Feature
- Represents a distinct user workflow
- Has its own data models
- Could be developed/tested independently
- Has 3+ related views

## Migration Notes

### Previous Structure (Layer-Based)
```
├── Models/           # All models together
├── Views/            # All views together
├── ViewModels/       # All ViewModels together
├── Helpers/          # Utilities
└── Utilities/        # More utilities
```

### Current Structure (Feature-Based)
Features are grouped by domain, making it easier to understand what each part of the app does.

## Development Workflow

### Adding a New Feature
1. Create feature folder: `Features/FeatureName/`
2. Add subfolders: `Models/`, `Views/`, `ViewModels/`
3. Implement feature files
4. Share common code via `Core/`

### Modifying Existing Feature
1. Navigate to feature folder: `Features/FeatureName/`
2. All related files are in one place
3. Make changes without affecting other features

### Adding Shared Utilities
1. If used by 2+ features, add to `Core/Helpers/`
2. If app-wide config/data, add to `Core/Utilities/`
3. Document usage in this file

## Future Enhancements

Potential additions to consider:

- **Core/Extensions/** - Swift type extensions
- **Core/Components/** - Reusable UI components
- **Core/Networking/** - API layer (if adding backend)
- **Core/Database/** - SwiftData/CloudKit utilities
- **Features/Settings/** - App settings feature
- **Features/Statistics/** - Game statistics and analytics

---

**Last Updated:** 2025-01-14
**Architecture:** Feature-based (domain-driven)
**Total Files:** 27 Swift files organized into 4 features + core
