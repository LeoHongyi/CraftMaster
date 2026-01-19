# CraftMaster

CraftMaster is a **pixel-styled SwiftUI iOS app** for building mastery through **goals (quests)**, **daily time logging (XP)**, and **game-like motivation loops** (streaks, milestones, achievements).

The core promise is simple: **set a quest → log minutes daily → see progress → earn badges**.

---

### Highlights

- **Goals as Quests (10,000h mindset)**: create goals, track progress, and soft-delete via **Archive** (data never lost).
- **Daily Logging (XP)**: frictionless minutes logging, history editing, and stats.
- **Gamification**: streaks, milestones, achievements, and celebratory UI.
- **Pixel UI Kit**: reusable components (`PixelCard`, `PixelButton`, `PixelBorder`, etc.) for a cohesive retro look.
- **First-run Onboarding**: 4-page, game-menu style onboarding with **pixel wipe “scene transition”**.
- **Robust persistence**: JSON storage with **schema versioning** + migration fallbacks + pre-write decode validation.
- **Global error handling**: centralized error mapping to user-facing alerts.
- **Test coverage**: unit tests for streak logic, repositories, migrations, and order robustness.

---

### App Flow

- **Root entry**
  - `RootEntryView` shows onboarding on first launch (`AppStorage("hasSeenOnboarding")`).
  - After onboarding, the app enters the main experience through `RootGateView`.

- **Boot gating & loading**
  - `AppState` exposes `isReady`.
  - `RootGateView` shows the pixel-styled `LoadingScreen` until the first bootstrap finishes.
  - Subsequent reloads do **not** flash the loading screen.

---

### Feature Modules (high-level)

The project is structured by feature areas under `CraftMaster/Features/`:

- **Goal**
  - Domain: `Goal`, `GoalRepository`, `GoalUseCase`
  - Data: `JSONGoalRepository`, `InMemoryGoalRepository`
  - UI: goal list, add/edit sheets, archived goals screen

- **Log**
  - Domain: `LogEntry`, `LogRepository`, `LogUseCase`
  - Data: `JSONLogRepository`, `InMemoryLogRepository`, migration structs
  - UI: Today / History / Stats screens (pixel styled)

- **Achievements**
  - Domain: `AchievementCatalog`, `AchievementEngine`, `AchievementDefinition`, etc.
  - Data: `JSONAchievementRepository`, `InMemoryAchievementRepository`
  - UI: achievements grid and detail UI

- **AI Coach (local placeholder)**
  - Domain: `AIRepository`, `AICoachUseCase`, `AICoachReport`, `AICoachAdvice`, `AIInsightInput`
  - Data: `LocalAIRepository` (no network; purely local logic), `AIInsightCacheRepository`
  - Used to produce “coach-like” summaries when enough progress exists (e.g. minimum minutes threshold, once-per-day generation rules).

---

### Architecture

CraftMaster follows a clean, testable layering:

- **UI (SwiftUI Views)**
  - Screens bind to `@EnvironmentObject AppState` or local view models.

- **App State (`AppState`)**
  - Single source of truth for loaded data:
    - `allGoals` (including archived), `goals` (active only), `logs`, `stats`, `unlockedAchievements`, etc.
  - Orchestrates async workflows and updates published state.
  - Centralized **error mapping** to `PresentableError` for UI alerts.

- **Use Cases**
  - Encapsulate domain rules and validation (`GoalUseCase`, `LogUseCase`, `AICoachUseCase`).
  - Keep UI logic thin and repositories focused on persistence.

- **Repositories**
  - Protocol-driven `GoalRepository`, `LogRepository`, `AchievementRepository`, `AIRepository`.
  - JSON repositories are implemented as **actors** for safe concurrent access.

---

### Persistence & Data Safety

Repositories use the app’s Documents directory:

- `goals.json`
- `logs.json`
- `achievements_unlocked.json`
- `ai_insight_cache.json`

Key properties:

- **Schema versioning** via a `Persisted<T>` wrapper where applicable.
- **Migration support** (e.g. log v1 → v2) with write-back to v2 on successful load.
- **Pre-write validation**: after encoding, data is decoded again before `.atomic` write to avoid persisting corrupted output.
- **Defensive IO**: “file not found” is treated as empty data (fresh install / system cleared file).

---

### Pixel UI System

The visual identity is built from reusable components in `CraftMaster/Shared/`:

- `PixelTheme`: palette, spacing, fonts
- `PixelCard`: “game menu” panels
- `PixelButton`: large primary CTA feel
- `PixelBorder`: pixel-like borders
- `PixelBadge`, `PixelConfetti`, `PixelNavTitle`, etc.

Onboarding and transitions reuse the same design language:

- `OnboardingView`: 4 pages, paging interaction, skip, page dots
- `PixelWipeTransition`: pixel-block wipe used for “scene change” feel
- `LoadingScreen`: pixel walker animation

---

### Debug Tools

In debug builds, the app includes a `DebugPanelView` for quick actions and stress testing (e.g. massive log seeding).

---

### Running the App

1. Open `CraftMaster.xcodeproj` in Xcode.
2. Select the `CraftMaster` scheme.
3. Run on an iOS Simulator or device.

---

### Running Tests

1. Select the `CraftMasterTests` scheme (or run tests from the main scheme if configured).
2. Press **⌘U** to run unit tests.

Tests include:

- streak and best-streak calculations
- repository persistence and migrations
- robustness tests for ordering and edge cases

---

### Notes / Roadmap Ideas

- Replace `LocalAIRepository` with a real on-device model or network-backed service behind the `AIRepository` protocol.
- Add optional “noise” background and richer pixel animations while keeping the UI crisp and “hard-edged”.
- Expand achievements and add richer goal analytics.

