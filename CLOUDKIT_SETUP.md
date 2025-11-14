# CloudKit Setup Instructions

I've created the entitlements file for CloudKit. Follow these steps to complete the setup:

## Step 1: Add Entitlements to Xcode Project

1. Open `SimpleMiniGolfScorecard.xcodeproj` in Xcode
2. Select the project in the navigator (blue icon at the top)
3. Select the **SimpleMiniGolfScorecard** target
4. Go to the **"Signing & Capabilities"** tab
5. Click **"+ Capability"** button
6. Search for and add **"iCloud"**
7. In the iCloud section that appears:
   - Check ✅ **CloudKit**
   - The container should automatically be set to `iCloud.$(CFBundleIdentifier)`

## Step 2: Verify Entitlements File

1. Still in Xcode, go to **"Build Settings"** tab
2. Search for "Code Signing Entitlements"
3. Verify it's set to: `SimpleMiniGolfScorecard/SimpleMiniGolfScorecard.entitlements`
4. If not, click on the value and type the path above

## Step 3: Configure Bundle Identifier (if needed)

1. Go back to **"Signing & Capabilities"** tab
2. Verify your **Bundle Identifier** is set (e.g., `com.yourname.SimpleMiniGolfScorecard`)
3. Make sure your **Team** is selected (required for CloudKit)

## Step 4: Update SwiftData ModelContainer (Optional for Cloud Sync)

To enable CloudKit sync for your SwiftData models, update your app's model container:

### Current Code (SimpleMiniGolfScorecardApp.swift):
```swift
var body: some Scene {
    WindowGroup {
        ContentView()
    }
    .modelContainer(for: [Game.self, Course.self, Player.self, Score.self])
}
```

### Updated Code with CloudKit:
```swift
var body: some Scene {
    WindowGroup {
        ContentView()
    }
    .modelContainer(sharedModelContainer)
}

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Game.self,
        Course.self,
        Player.self,
        Score.self
    ])

    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false,
        cloudKitDatabase: .automatic  // Enable CloudKit sync
    )

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
```

## Step 5: Test CloudKit

1. Build and run the app on a device (simulator may have limitations)
2. Make sure you're signed into iCloud on the device
3. Create some test data (courses, players, games)
4. Check the CloudKit Dashboard:
   - Go to [https://icloud.developer.apple.com/](https://icloud.developer.apple.com/)
   - Sign in with your Apple Developer account
   - Select your app's container
   - Verify data is syncing

## What CloudKit Provides

With CloudKit enabled, your app gets:

✅ **Automatic Cloud Sync** - Data syncs across user's devices
✅ **Backup** - User data is backed up to iCloud
✅ **Cross-Device** - iPhone, iPad, Mac all stay in sync
✅ **Privacy** - Data stays in user's private iCloud storage
✅ **Conflict Resolution** - SwiftData handles merge conflicts

## Important Notes

- **Apple Developer Account Required**: CloudKit requires an active Apple Developer account
- **iCloud Storage**: Uses user's iCloud storage quota
- **Network Required**: Initial sync requires internet connection
- **Testing**: Use TestFlight for testing cloud sync across devices

## Troubleshooting

### "No iCloud account found"
- Make sure device is signed into iCloud (Settings > [Your Name] > iCloud)

### "CloudKit not available"
- Check that iCloud Drive is enabled (Settings > [Your Name] > iCloud > iCloud Drive)

### Container not appearing in CloudKit Dashboard
- Build and run the app at least once
- Data takes a few minutes to appear in dashboard
- Make sure you created test data in the app

## Next Steps

After CloudKit is working:

1. **Test Multi-Device Sync**: Install on multiple devices and verify sync
2. **Handle Offline Mode**: Consider adding offline indicators
3. **Error Handling**: Add user-facing messages for sync errors
4. **Privacy**: Update Privacy Policy to mention iCloud sync

---

**File Created:** `SimpleMiniGolfScorecard.entitlements`
**Date:** 2025-01-14
**Status:** Manual Xcode steps required to complete setup
