import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/features/auth/providers/auth_provider.dart';
import 'package:habitz/features/auth/presentation/widgets/onboarding_step_card.dart';
import 'package:habitz/features/auth/providers/onboarding_state.dart';
import 'package:habitz/features/mobile_sync/mobile_backend_service.dart';
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
  Future<RemoteRecommendations>? _recommendationsFuture;
  String? _recommendationSignature;

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
    final recommendationsFuture = _ensureRecommendations(state, controller);
    return OnboardingStepCard(
      title: 'Recommended habits for you',
      subtitle: 'Toggle what you want to start with.',
      visual: _heroVisual(Icons.task_alt_rounded),
      child: FutureBuilder<RemoteRecommendations>(
        future: recommendationsFuture,
        builder: (context, snapshot) {
          final recommendations = snapshot.data;
          final habits = recommendations?.habits ?? const <RemoteHabitRecommendation>[];
          if (recommendationsFuture == null) {
            return const Text(
              'Complete your core profile first to unlock backend-powered habit recommendations.',
              style: TextStyle(color: AppTheme.textSecondary),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting && habits.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.accent));
          }
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
              style: const TextStyle(color: AppTheme.textSecondary),
            );
          }
          if (habits.isEmpty) {
            return const Text(
              'No recommendations available yet. Continue and Habitz will assign smart defaults.',
              style: TextStyle(color: AppTheme.textSecondary),
            );
          }
          return Column(
            children: [
              for (final habit in habits) ...[
                OnboardingOptionCard(
                  title: habit.title,
                  subtitle: habit.description,
                  selected: state.selectedHabits.contains(_habitEnumFromKey(habit.key)),
                  onTap: () => controller.toggleHabit(_habitEnumFromKey(habit.key)),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
      onContinue: () => _goToStep(7),
      onBack: () => _goToStep(5),
    );
  }

  Widget _plansStep(OnboardingState state, OnboardingController controller) {
    final recommendationsFuture = _ensureRecommendations(state, controller);
    return OnboardingStepCard(
      title: 'Recommended workout plans',
      subtitle: 'Based on your selections. Choose one or skip.',
      visual: _heroVisual(Icons.local_fire_department_rounded),
      child: FutureBuilder<RemoteRecommendations>(
        future: recommendationsFuture,
        builder: (context, snapshot) {
          final plans = (snapshot.data?.plans ?? const <RemotePlanSummary>[]).take(4).toList();
          if (recommendationsFuture == null) {
            return const Text(
              'Complete your core profile first to unlock plan recommendations.',
              style: TextStyle(color: AppTheme.textSecondary),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting && plans.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.accent));
          }
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
              style: const TextStyle(color: AppTheme.textSecondary),
            );
          }
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
                  subtitle: '${plan.level.name} • ${plan.equipment.name} • match ${plan.matchScore ?? '-'}',
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
              'Your onboarding preferences are saved to your account and synced into the mobile app so plans, habits, and workouts stay aligned.',
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
    await ref.read(mobileBackendServiceProvider).completeOnboarding(
          state,
          athleteName: authSession?.name ?? 'Athlete',
        );
  }

  Future<RemoteRecommendations>? _ensureRecommendations(
    OnboardingState state,
    OnboardingController controller,
  ) {
    if (state.sexVariant == null || state.fitnessLevel == null || state.equipment == null || state.selectedGoals.isEmpty) {
      return null;
    }
    final signature = [
      state.selectedGoals.map((goal) => goal.name).toList()..sort(),
      state.sexVariant?.name,
      state.fitnessLevel?.name,
      state.equipment?.name,
      state.wakeTime,
    ].toString();
    if (_recommendationSignature == signature && _recommendationsFuture != null) {
      return _recommendationsFuture;
    }
    _recommendationSignature = signature;
    _recommendationsFuture = ref.read(mobileBackendServiceProvider).fetchRecommendations(state).then((result) {
      final recommendedHabits = result.habits.map((item) => _habitEnumFromKey(item.key)).toSet();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        controller.setHabits(recommendedHabits);
        if (result.plans.isNotEmpty && !result.plans.any((plan) => plan.id == state.selectedPlanId)) {
          controller.setPlan(result.plans.first.id);
        }
      });
      return result;
    });
    return _recommendationsFuture;
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

  HabitRecommendation _habitEnumFromKey(String key) {
    switch (key) {
      case 'water':
        return HabitRecommendation.water;
      case 'walk':
        return HabitRecommendation.walk;
      case 'stretch':
        return HabitRecommendation.morningStretch;
      case 'meditation':
        return HabitRecommendation.meditation;
      case 'sleep':
        return HabitRecommendation.sleep;
      default:
        return HabitRecommendation.workout;
    }
  }

}

void _noop() {}
