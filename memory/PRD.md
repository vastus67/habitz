# Habitz PRD

## Original problem statement
https://github.com/vastus67/habitz take a look at my app. I want you to complete it with full functionalities ready to be deployed and used

Additional user choices:
- Finish all core user-facing flows end to end
- Fix workout personalization so male/female onboarding selections affect plans correctly
- Include account registration and Google auth
- Skip unrelated new integrations
- Complete the most important production-ready MVP first
- Extend it for Android and iOS using the original Flutter repo as the primary app
- Fully replace the old mobile screens/flows with the new premium Flutter experience

## Architecture decisions
- Original Flutter mobile codebase remains the primary product surface for Android and iOS
- FastAPI backend is the source of truth for auth and onboarding personalization
- Flutter uses secure session storage for auth, deep-link based Google login, and Drift as the local cache/runtime store for plans, habits, profile, and workout execution
- Mobile onboarding, plan list, and plan detail now sync from backend APIs into local Drift so Flutter behavior matches backend personalization logic
- Local workout execution stays fast on-device while plan/habit/profile personalization is synced from backend

## What’s implemented
- Premium Flutter auth flow with register, sign in, Google sign-in callback wiring, session restore, route protection, and logout cleanup
- New mobile visual direction across auth, onboarding, dashboard, plans, habits, analytics, workout day, workout summary, and profile
- Backend-wired onboarding recommendations and completion flow inside Flutter
- Backend-wired mobile plan list/detail sync, including sex-based personalization parity and active-plan activation
- Local Drift syncing for recommended plans, selected plan days/exercises, habits, and profile after backend responses
- Profile controls for goal, sex variant, equipment, wake time, and better mobile polish
- Workout completion now captures effort and notes in the Flutter flow

## Prioritized backlog
### P0
- Run Flutter pub get and device builds once Flutter SDK is available in a native-capable environment
- Validate Android and iOS deep-link Google auth on real devices
- Set final release signing, icons, splash assets, and store metadata

### P1
- Sync workout history and habit logs back to backend for full cross-device continuity
- Add richer plan imagery and motion polish across transitions
- Improve profile/settings detail and workout history naming from backend metadata

### P2
- Add push reminders and local notifications
- Add offline conflict sync strategy
- Add richer onboarding progress animation and recovery insights

## Next tasks
1. Run native Android/iOS builds and verify the Google callback end-to-end
2. Add backend sync for workout/habit completion history so multiple devices stay aligned
3. Finalize store submission assets and release signing details
