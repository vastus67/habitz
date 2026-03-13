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
- Keep the stronger visual direction and graphics from the new web app look

## Architecture decisions
- Kept the original Flutter mobile codebase as the primary product surface inside the repo and enhanced it for Android/iOS delivery
- Added a mobile auth layer using the FastAPI backend already built in this workspace for email/password sign-in and Google session exchange
- Preserved the app’s local-first Drift data model for plans, habits, workouts, and profile state, while using secure session storage for auth
- Added deep-link based Google login handling for native mobile with Android/iOS scheme configuration
- Reworked plan seeding and filtering so onboarding sex selection now prioritizes exact-match plans with unisex fallbacks

## What’s implemented
- Native mobile auth entry flow: register, sign in, secure session restore, Google auth deep-link flow scaffolding, logout
- Route gating so users go auth -> onboarding -> app shell correctly
- Personalized workout catalog updates with male/female/unisex plan variants and better filtering behavior
- Visual polish updates across theme, auth, plans, profile, progress, and dashboard surfaces
- Android/iOS package identifiers and deep-link settings updated for mobile app readiness
- Local user-progress reset on logout to avoid cross-account data leakage on device

## Prioritized backlog
### P0
- Run Flutter pub get / codegen / real device builds once Flutter SDK is available
- Validate Google auth redirect end-to-end on physical Android and iPhone devices
- Add release signing assets and store metadata/screenshots

### P1
- Sync onboarding/profile selections back to backend so mobile and web stay consistent across devices
- Improve analytics and workout history visualizations on smaller screens
- Add edit-profile fields for primary goal and equipment directly in a richer mobile settings form

### P2
- Add push reminders and local notifications for habits/workouts
- Add offline-first sync conflict handling
- Add richer plan hero media and motion transitions

## Next tasks
1. Run native builds and verify deep link auth on Android and iOS
2. Finalize app store assets, signing, and production API URL via dart-define
3. Add cross-device profile/data sync so mobile and web stay aligned
