import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/seed/bootstrap_provider.dart';
import 'package:habitz/features/analytics/presentation/analytics_screen.dart';
import 'package:habitz/features/auth/presentation/sign_in_screen.dart';
import 'package:habitz/features/auth/providers/auth_provider.dart';
import 'package:habitz/features/auth/presentation/onboarding_screen.dart';
import 'package:habitz/features/dashboard/presentation/home_screen.dart';
import 'package:habitz/features/habits/presentation/habits_screen.dart';
import 'package:habitz/features/profile/presentation/profile_screen.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';
import 'package:habitz/features/workouts/presentation/exercise_execution_screen.dart';
import 'package:habitz/features/workouts/presentation/workout_day_screen.dart';
import 'package:habitz/features/workouts/presentation/workout_plan_detail_screen.dart';
import 'package:habitz/features/workouts/presentation/workout_plans_screen.dart';
import 'package:habitz/features/workouts/presentation/workout_summary_screen.dart';
import 'package:habitz/theme/app_theme.dart';

class HabitzApp extends ConsumerWidget {
  const HabitzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);
    final authState = ref.watch(authControllerProvider);
    if (bootstrap.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (authState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final profileState = ref.watch(profileControllerProvider);
    if (profileState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final isAuthenticated = authState.valueOrNull != null;
    final hasCompletedOnboarding =
      (profileState.valueOrNull?.onboardingCompleted ??
        ref.watch(hasCompletedOnboardingProvider)) ==
      true;
    final router = GoRouter(
      initialLocation: !isAuthenticated
          ? '/auth'
          : hasCompletedOnboarding
              ? '/home'
              : '/onboarding',
      redirect: (context, state) {
        final path = state.matchedLocation;
        if (!isAuthenticated && path != '/auth') {
          return '/auth';
        }
        if (isAuthenticated && !hasCompletedOnboarding && path != '/onboarding') {
          return '/onboarding';
        }
        if (isAuthenticated && hasCompletedOnboarding && (path == '/auth' || path == '/onboarding')) {
          return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/auth',
          builder: (_, __) => const SignInScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => const OnboardingScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainBottomShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/plans', builder: (_, __) => const WorkoutPlansScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/habits', builder: (_, __) => const HabitsScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/analytics',
                builder: (_, __) => const AnalyticsOverviewScreen(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
            ]),
          ],
        ),
        GoRoute(
          path: '/workout-plan/:id',
          builder: (context, state) =>
              WorkoutPlanDetailScreen(planId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/workout-day/:planId/:dayId',
          builder: (context, state) => WorkoutDayScreen(
            planId: state.pathParameters['planId']!,
            dayId: state.pathParameters['dayId']!,
          ),
        ),
        GoRoute(
          path: '/exercise/:planId/:dayId/:exerciseIndex',
          builder: (context, state) => ExerciseExecutionScreen(
            planId: state.pathParameters['planId']!,
            dayId: state.pathParameters['dayId']!,
            exerciseIndex:
                int.tryParse(state.pathParameters['exerciseIndex'] ?? '0') ?? 0,
          ),
        ),
        GoRoute(
          path: '/workout-summary',
          builder: (context, state) => WorkoutSummaryScreen(
            args: state.extra is WorkoutSummaryArgs ? state.extra as WorkoutSummaryArgs : null,
          ),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Habitz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

class MainBottomShell extends StatelessWidget {
  const MainBottomShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E1510), AppTheme.background],
          ),
        ),
        child: navigationShell,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(index,
                  initialLocation: index == navigationShell.currentIndex);
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.fitness_center_outlined), label: 'Plans'),
              NavigationDestination(icon: Icon(Icons.task_alt), label: 'Habits'),
              NavigationDestination(icon: Icon(Icons.insights_outlined), label: 'Analytics'),
              NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
