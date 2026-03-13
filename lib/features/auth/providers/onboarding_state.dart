import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';

enum OnboardingGoal {
  buildMuscle,
  loseFat,
  improveDiscipline,
  improveHealth,
  buildDailyHabits,
  increaseEnergy,
}

enum FitnessLevel { beginner, intermediate, advanced }

enum HabitRecommendation {
  water,
  walk,
  morningStretch,
  meditation,
  sleep,
  workout,
}

enum AccountChoice { google, apple, email, guest }

class OnboardingState {
  const OnboardingState({
    this.stepIndex = 0,
    this.selectedGoals = const {},
    this.sexVariant,
    this.fitnessLevel,
    this.equipment,
    this.wakeTime = '07:00',
    this.selectedHabits = const {
      HabitRecommendation.water,
      HabitRecommendation.sleep,
      HabitRecommendation.workout,
    },
    this.selectedPlanId,
    this.dailyReminders = true,
    this.workoutReminders = true,
    this.habitReminders = true,
    this.accountChoice,
    this.isGenerating = false,
  });

  final int stepIndex;
  final Set<OnboardingGoal> selectedGoals;
  final SexVariant? sexVariant;
  final FitnessLevel? fitnessLevel;
  final EquipmentType? equipment;
  final String wakeTime;
  final Set<HabitRecommendation> selectedHabits;
  final String? selectedPlanId;
  final bool dailyReminders;
  final bool workoutReminders;
  final bool habitReminders;
  final AccountChoice? accountChoice;
  final bool isGenerating;

  OnboardingState copyWith({
    int? stepIndex,
    Set<OnboardingGoal>? selectedGoals,
    SexVariant? sexVariant,
    FitnessLevel? fitnessLevel,
    EquipmentType? equipment,
    String? wakeTime,
    Set<HabitRecommendation>? selectedHabits,
    String? selectedPlanId,
    bool? dailyReminders,
    bool? workoutReminders,
    bool? habitReminders,
    AccountChoice? accountChoice,
    bool? isGenerating,
  }) {
    return OnboardingState(
      stepIndex: stepIndex ?? this.stepIndex,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      sexVariant: sexVariant ?? this.sexVariant,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      equipment: equipment ?? this.equipment,
      wakeTime: wakeTime ?? this.wakeTime,
      selectedHabits: selectedHabits ?? this.selectedHabits,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      workoutReminders: workoutReminders ?? this.workoutReminders,
      habitReminders: habitReminders ?? this.habitReminders,
      accountChoice: accountChoice ?? this.accountChoice,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(const OnboardingState());

  void setStep(int step) => state = state.copyWith(stepIndex: step);

  void toggleGoal(OnboardingGoal goal) {
    final goals = {...state.selectedGoals};
    goals.contains(goal) ? goals.remove(goal) : goals.add(goal);
    state = state.copyWith(selectedGoals: goals);
  }

  void setSexVariant(SexVariant variant) => state = state.copyWith(sexVariant: variant);

  void setFitnessLevel(FitnessLevel level) => state = state.copyWith(fitnessLevel: level);

  void setEquipment(EquipmentType equipment) => state = state.copyWith(equipment: equipment);

  void setWakeTime(String wakeTime) => state = state.copyWith(wakeTime: wakeTime);

  void toggleHabit(HabitRecommendation habit) {
    final habits = {...state.selectedHabits};
    habits.contains(habit) ? habits.remove(habit) : habits.add(habit);
    state = state.copyWith(selectedHabits: habits);
  }

  void setPlan(String? planId) => state = state.copyWith(selectedPlanId: planId);

  void setReminderDaily(bool value) => state = state.copyWith(dailyReminders: value);

  void setReminderWorkout(bool value) => state = state.copyWith(workoutReminders: value);

  void setReminderHabit(bool value) => state = state.copyWith(habitReminders: value);

  void setAccountChoice(AccountChoice choice) => state = state.copyWith(accountChoice: choice);

  void setGenerating(bool generating) => state = state.copyWith(isGenerating: generating);
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(),
);
