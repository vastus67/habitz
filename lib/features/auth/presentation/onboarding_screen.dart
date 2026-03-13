import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/core/utils/id_generator.dart';
import 'package:habitz/features/auth/providers/auth_provider.dart';
import 'package:habitz/features/auth/presentation/widgets/onboarding_step_card.dart';
import 'package:habitz/features/auth/providers/onboarding_state.dart';
import 'package:habitz/features/habits/domain/habit.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';
import 'package:habitz/theme/app_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const List<String> _wakeTimes = ['06:00', '07:00', '08:00', '09:00', '10:00'];
  final PageController _pageController = PageController();
  final FixedExtentScrollController _wakeController = FixedExtentScrollController(initialItem: 1);
  bool _generationStarted = false;

  @override
  void dispose() {
    _pageController.dispose();
    _wakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _welcomeStep(state),
          _goalStep(state, controller),
          _sexStep(state, controller),
          _levelStep(state, controller),
          _equipmentStep(state, controller),
          _wakeTimeStep(state, controller),
          _habitsStep(state, controller),
          _plansStep(state, controller),
          _notificationsStep(state, controller),
          _accountStep(state, controller),
          _generatingStep(state),
          _dashboardEntryStep(state),
        ],
      ),
    );
  }

  Widget _welcomeStep(OnboardingState state) {
    return OnboardingStepCard(
      title: 'Habitz',
      subtitle: 'Build habits. Train consistently. Transform.',
      visual: _heroVisual(Icons.local_fire_department_rounded),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'Your personal behavioral operating system for habits and workouts.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      ),
      continueLabel: 'Get Started',
      onContinue: () => _goToStep(1),
      onBack: null,
    );
  }

  Widget _goalStep(OnboardingState state, OnboardingController controller) {
    return OnboardingStepCard(
      title: 'What is your main goal?',
      subtitle: 'Choose one or more to personalize your plan.',
      visual: _heroVisual(Icons.track_changes_rounded),
      child: Column(
        children: [
          for (final goal in OnboardingGoal.values) ...[
            OnboardingOptionCard(
              title: _goalLabel(goal),
              selected: state.selectedGoals.contains(goal),
              onTap: () => controller.toggleGoal(goal),
            ),
            const SizedBox(height: 10),
          ]
        ],
      ),
      onContinue: () => _goToStep(2),
      canContinue: state.selectedGoals.isNotEmpty,
      onBack: () => _goToStep(0),
    );
  }

  Widget _sexStep(OnboardingState state, OnboardingController controller) {
    return OnboardingStepCard(
      title: 'Choose your workout style',
      subtitle: 'This controls plan variants later.',
      visual: _heroVisual(Icons.fitness_center_rounded),
      child: Column(
        children: [
          OnboardingOptionCard(
            title: 'Male Workouts',
            selected: state.sexVariant == SexVariant.male,
            onTap: () => controller.setSexVariant(SexVariant.male),
          ),
          const SizedBox(height: 10),
          OnboardingOptionCard(
            title: 'Female Workouts',
            selected: state.sexVariant == SexVariant.female,
            onTap: () => controller.setSexVariant(SexVariant.female),
          ),
          const SizedBox(height: 10),
          OnboardingOptionCard(
            title: 'Unisex Programs',
            selected: state.sexVariant == SexVariant.unisex,
            onTap: () => controller.setSexVariant(SexVariant.unisex),
          ),
        ],
      ),
      onContinue: () => _goToStep(3),
      canContinue: state.sexVariant != null,
      onBack: () => _goToStep(1),
    );
  }

  Widget _levelStep(OnboardingState state, OnboardingController controller) {
    return OnboardingStepCard(
      title: 'What is your current level?',
      subtitle: 'We tune intensity and volume to this.',
      visual: _heroVisual(Icons.insights_rounded),
      child: Column(
        children: [
          OnboardingOptionCard(
            title: 'Beginner',
            subtitle: 'New to structured training',
            selected: state.fitnessLevel == FitnessLevel.beginner,
            onTap: () => controller.setFitnessLevel(FitnessLevel.beginner),
          ),
          const SizedBox(height: 10),
          OnboardingOptionCard(
            title: 'Intermediate',
            subtitle: 'Comfortable with regular sessions',
            selected: state.fitnessLevel == FitnessLevel.intermediate,
            onTap: () => controller.setFitnessLevel(FitnessLevel.intermediate),
          ),
          const SizedBox(height: 10),
          OnboardingOptionCard(
            title: 'Advanced',
            subtitle: 'Experienced and performance-focused',
            selected: state.fitnessLevel == FitnessLevel.advanced,
            onTap: () => controller.setFitnessLevel(FitnessLevel.advanced),
          ),
        ],
      ),
      onContinue: () => _goToStep(4),
      canContinue: state.fitnessLevel != null,
      onBack: () => _goToStep(2),
    );
  }

  Widget _equipmentStep(OnboardingState state, OnboardingController controller) {
    return OnboardingStepCard(
      title: 'What equipment do you have?',
      subtitle: 'We suggest realistic plans you can follow.',
      visual: _heroVisual(Icons.fitness_center_rounded),
      child: Column(
        children: [
          OnboardingOptionCard(
            title: 'No equipment',
            selected: state.equipment == EquipmentType.none,
            onTap: () => controller.setEquipment(EquipmentType.none),
          ),
          const SizedBox(height: 10),
          OnboardingOptionCard(
            title: 'Home equipment',
            selected: state.equipment == EquipmentType.home,
            onTap: () => controller.setEquipment(EquipmentType.home),
          ),
          const SizedBox(height: 10),
          OnboardingOptionCard(
            title: 'Full gym access',
            selected: state.equipment == EquipmentType.gym,
            onTap: () => controller.setEquipment(EquipmentType.gym),
          ),
        ],
      ),
      onContinue: () => _goToStep(5),
      canContinue: state.equipment != null,
      onBack: () => _goToStep(3),
    );
  }

  Widget _wakeTimeStep(OnboardingState state, OnboardingController controller) {
    return OnboardingStepCard(
      title: 'When do you usually wake up?',
      subtitle: 'Used to schedule reminders and morning routines.',
      visual: _heroVisual(Icons.alarm_rounded),
      child: SizedBox(
        height: 220,
        child: ListWheelScrollView.useDelegate(
          controller: _wakeController,
          itemExtent: 56,
          perspective: 0.003,
          diameterRatio: 1.4,
          onSelectedItemChanged: (index) => controller.setWakeTime(_wakeTimes[index]),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: _wakeTimes.length,
            builder: (context, index) {
              final time = _wakeTimes[index];
              final selected = time == state.wakeTime;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.accent : AppTheme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected ? AppTheme.accent : const Color(0xFF252D25),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.black : AppTheme.textPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      onContinue: () => _goToStep(6),
      onBack: () => _goToStep(4),
    );
  }

  Widget _habitsStep(OnboardingState state, OnboardingController controller) {
    return OnboardingStepCard(
      title: 'Recommended habits for you',
      subtitle: 'Toggle what you want to start with.',
      visual: _heroVisual(Icons.task_alt_rounded),
      child: Column(
        children: [
          for (final habit in HabitRecommendation.values) ...[
            OnboardingOptionCard(
              title: _habitLabel(habit),
              selected: state.selectedHabits.contains(habit),
              onTap: () => controller.toggleHabit(habit),
            ),
            const SizedBox(height: 10),
          ]
        ],
      ),
      onContinue: () => _goToStep(7),
      onBack: () => _goToStep(5),
    );
  }

  Widget _plansStep(OnboardingState state, OnboardingController controller) {
    final repository = ref.watch(plansRepositoryProvider);
    return OnboardingStepCard(
      title: 'Recommended workout plans',
      subtitle: 'Based on your selections. Choose one or skip.',
      visual: _heroVisual(Icons.local_fire_department_rounded),
      child: StreamBuilder<List<WorkoutPlanModel>>(
        key: ValueKey('${state.sexVariant}-${state.fitnessLevel}-${state.equipment}'),
        stream: repository.watchPlans(
          sexVariant: state.sexVariant,
          level: _mapFitnessLevel(state.fitnessLevel),
          equipment: state.equipment,
          goal: _mapPrimaryPlanGoal(state.selectedGoals),
        ),
        builder: (context, snapshot) {
          final plans = (snapshot.data ?? []).take(3).toList();
          if (plans.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'No exact match yet. Continue and we will assign a smart default.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            );
          }
          return Column(
            children: [
              for (final plan in plans) ...[
                OnboardingOptionCard(
                  title: plan.name,
                  subtitle: '${plan.level.name} • ${plan.equipment.name}',
                  selected: state.selectedPlanId == plan.id,
                  onTap: () => controller.setPlan(plan.id),
                ),
                const SizedBox(height: 10),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => controller.setPlan(null),
                  child: const Text('Skip plan selection'),
                ),
              ),
            ],
          );
        },
      ),
      onContinue: () => _goToStep(8),
      onBack: () => _goToStep(6),
    );
  }

  Widget _notificationsStep(OnboardingState state, OnboardingController controller) {
    return OnboardingStepCard(
      title: 'Stay consistent',
      subtitle: 'Choose reminder types you want enabled.',
      visual: _heroVisual(Icons.notifications_active_rounded),
      child: Column(
        children: [
          SwitchListTile(
            value: state.dailyReminders,
            activeThumbColor: AppTheme.accent,
            title: const Text('Daily reminders'),
            onChanged: controller.setReminderDaily,
          ),
          SwitchListTile(
            value: state.workoutReminders,
            activeThumbColor: AppTheme.accent,
            title: const Text('Workout reminders'),
            onChanged: controller.setReminderWorkout,
          ),
          SwitchListTile(
            value: state.habitReminders,
            activeThumbColor: AppTheme.accent,
            title: const Text('Habit reminders'),
            onChanged: controller.setReminderHabit,
          ),
        ],
      ),
      onContinue: () => _goToStep(9),
      onBack: () => _goToStep(7),
    );
  }

  Widget _accountStep(OnboardingState state, OnboardingController controller) {
    final authSession = ref.watch(authControllerProvider).valueOrNull;
    return OnboardingStepCard(
      title: 'Connected account',
      subtitle: 'Your mobile account is ready. We will generate the system around it.',
      visual: _heroVisual(Icons.account_circle_rounded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingOptionCard(
            title: authSession?.name ?? 'Athlete',
            subtitle: authSession?.email ?? 'Signed in',
            selected: true,
            onTap: _noop,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final provider in authSession?.providers ?? const ['email'])
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.cardSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0x22FFFFFF)),
                  ),
                  child: Text(
                    provider.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              'Your onboarding preferences will be saved locally on this device so the dashboard, habits, and workouts can stay personalized.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
      continueLabel: 'Generate My System',
      onContinue: () async {
        await _goToStep(10);
        await _runGeneration();
      },
      canContinue: true,
      onBack: () => _goToStep(8),
    );
  }

  Widget _generatingStep(OnboardingState state) {
    return OnboardingStepCard(
      title: 'Preparing your Habitz system...',
      subtitle: 'Generating habit schedule, score engine, and workout plan.',
      visual: const SizedBox(
        height: 130,
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.accent,
            strokeWidth: 3,
          ),
        ),
      ),
      child: const SizedBox.shrink(),
      onContinue: null,
      canContinue: false,
      continueLabel: 'Generating...',
      isLoading: state.isGenerating,
      onBack: null,
    );
  }

  Widget _dashboardEntryStep(OnboardingState state) {
    return OnboardingStepCard(
      title: 'You are all set',
      subtitle: 'Your habits and workout plan are ready.',
      visual: _heroVisual(Icons.check_circle_rounded),
      child: Column(
        children: [
          const OnboardingOptionCard(
            title: 'Today\'s habits ready',
            selected: true,
            onTap: _noop,
          ),
          const SizedBox(height: 10),
          const OnboardingOptionCard(
            title: 'Today\'s workout queued',
            selected: true,
            onTap: _noop,
          ),
          const SizedBox(height: 10),
          const OnboardingOptionCard(
            title: 'Progress ring activated',
            selected: true,
            onTap: _noop,
          ),
        ],
      ),
      continueLabel: 'Enter Dashboard',
      onContinue: () => context.go('/home'),
      onBack: null,
    );
  }

  Future<void> _goToStep(int step) async {
    ref.read(onboardingControllerProvider.notifier).setStep(step);
    await _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _runGeneration() async {
    if (_generationStarted) return;
    _generationStarted = true;

    final state = ref.read(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    controller.setGenerating(true);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      await _persistOnboarding(state);
      controller.setGenerating(false);
      await _goToStep(11);
    } catch (_) {
      controller.setGenerating(false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate your setup. Please try again.')),
      );
      _generationStarted = false;
      await _goToStep(9);
    }
  }

  Future<void> _persistOnboarding(OnboardingState state) async {
    final authSession = ref.read(authControllerProvider).valueOrNull;
    final profile = UserProfile(
      id: IdGenerator.deterministic('profile', ['main']),
      name: authSession?.name ?? 'Athlete',
      sexVariant: state.sexVariant ?? SexVariant.unisex,
      primaryGoal: _mapPrimaryUserGoal(state.selectedGoals),
      equipment: state.equipment ?? EquipmentType.home,
      wakeTime: state.wakeTime,
      onboardingCompleted: true,
    );

    await ref.read(profileControllerProvider.notifier).save(
          profile,
          activePlanId: state.selectedPlanId,
        );

    final habitRepo = ref.read(habitsRepositoryProvider);
    final templates = <HabitRecommendation, ({String title, HabitType type, double target, String unit})>{
      HabitRecommendation.water: (title: 'Drink 8 glasses of water', type: HabitType.count, target: 8, unit: 'glasses'),
      HabitRecommendation.walk: (title: 'Walk 10k steps', type: HabitType.target, target: 10000, unit: 'steps'),
      HabitRecommendation.morningStretch: (title: 'Morning stretch', type: HabitType.duration, target: 10, unit: 'min'),
      HabitRecommendation.meditation: (title: 'Meditation', type: HabitType.duration, target: 10, unit: 'min'),
      HabitRecommendation.sleep: (title: 'Sleep 7+ hours', type: HabitType.duration, target: 7, unit: 'hours'),
      HabitRecommendation.workout: (title: 'Workout session', type: HabitType.binary, target: 1, unit: 'done'),
    };

    for (final habit in state.selectedHabits) {
      final cfg = templates[habit]!;
      await habitRepo.upsertHabit(
        HabitModel(
          id: IdGenerator.deterministic('habit', [cfg.title]),
          title: cfg.title,
          type: cfg.type,
          targetValue: cfg.target,
          unit: cfg.unit,
          scheduleDays: const [1, 2, 3, 4, 5, 6, 7],
          reminders: [state.wakeTime],
          createdAt: DateTime.now(),
          category: 'onboarding',
        ),
      );
    }

    final selectedPlanId = state.selectedPlanId ?? await _fallbackPlanId(state);
    if (selectedPlanId != null) {
      await ref.read(plansRepositoryProvider).setActivePlan(selectedPlanId);
    }

    ref.read(hasCompletedOnboardingProvider.notifier).state = true;
  }

  Future<String?> _fallbackPlanId(OnboardingState state) async {
    final plans = await ref
        .read(plansRepositoryProvider)
        .watchPlans(
          sexVariant: state.sexVariant,
          level: _mapFitnessLevel(state.fitnessLevel),
          equipment: state.equipment,
          goal: _mapPrimaryPlanGoal(state.selectedGoals),
        )
        .first;
    return plans.isNotEmpty ? plans.first.id : null;
  }

  Widget _heroVisual(IconData icon) {
    return Container(
      height: 146,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset(
              _heroAssetForIcon(icon),
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0x66000000)],
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xCC0B0F0C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x44FFFFFF)),
                ),
                child: const Text(
                  'MOVE • TRAIN • REPEAT',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 14,
              bottom: 12,
              child: Container(
                height: 42,
                width: 42,
                decoration: const BoxDecoration(
                  color: Color(0xD8C6FF00),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.black, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _heroAssetForIcon(IconData icon) {
    if (icon == Icons.track_changes_rounded ||
        icon == Icons.insights_rounded ||
        icon == Icons.notifications_active_rounded) {
      return 'assets/images/workout_splash_2.svg';
    }
    if (icon == Icons.account_circle_rounded ||
        icon == Icons.check_circle_rounded ||
        icon == Icons.local_fire_department_rounded) {
      return 'assets/images/workout_splash_3.svg';
    }
    return 'assets/images/workout_splash_1.svg';
  }

  String _goalLabel(OnboardingGoal goal) {
    switch (goal) {
      case OnboardingGoal.buildMuscle:
        return 'Build muscle';
      case OnboardingGoal.loseFat:
        return 'Lose fat';
      case OnboardingGoal.improveDiscipline:
        return 'Improve discipline';
      case OnboardingGoal.improveHealth:
        return 'Improve health';
      case OnboardingGoal.buildDailyHabits:
        return 'Build daily habits';
      case OnboardingGoal.increaseEnergy:
        return 'Increase energy';
    }
  }

  String _habitLabel(HabitRecommendation habit) {
    switch (habit) {
      case HabitRecommendation.water:
        return 'Drink 8 glasses of water';
      case HabitRecommendation.walk:
        return 'Walk 10k steps';
      case HabitRecommendation.morningStretch:
        return 'Morning stretch';
      case HabitRecommendation.meditation:
        return 'Meditation';
      case HabitRecommendation.sleep:
        return 'Sleep 7+ hours';
      case HabitRecommendation.workout:
        return 'Workout session';
    }
  }

  UserGoal _mapPrimaryUserGoal(Set<OnboardingGoal> goals) {
    if (goals.contains(OnboardingGoal.buildMuscle)) return UserGoal.strength;
    if (goals.contains(OnboardingGoal.loseFat)) return UserGoal.fatLoss;
    if (goals.contains(OnboardingGoal.improveHealth)) return UserGoal.mobility;
    if (goals.contains(OnboardingGoal.buildDailyHabits)) return UserGoal.discipline;
    if (goals.contains(OnboardingGoal.increaseEnergy)) return UserGoal.sleepReset;
    return UserGoal.discipline;
  }

  PlanLevel? _mapFitnessLevel(FitnessLevel? level) {
    switch (level) {
      case FitnessLevel.beginner:
        return PlanLevel.beginner;
      case FitnessLevel.intermediate:
        return PlanLevel.intermediate;
      case FitnessLevel.advanced:
        return PlanLevel.advanced;
      case null:
        return null;
    }
  }

  PlanGoal? _mapPrimaryPlanGoal(Set<OnboardingGoal> goals) {
    if (goals.contains(OnboardingGoal.loseFat)) return PlanGoal.fatloss;
    if (goals.contains(OnboardingGoal.buildMuscle)) return PlanGoal.strength;
    if (goals.contains(OnboardingGoal.improveHealth)) return PlanGoal.mobility;
    return null;
  }
}

void _noop() {}
