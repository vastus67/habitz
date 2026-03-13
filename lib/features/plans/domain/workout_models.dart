import 'package:habitz/features/profile/domain/user_profile.dart';

enum PlanGoal { strength, fatloss, mobility }

enum PlanLevel { beginner, intermediate, advanced }

class WorkoutPlanModel {
  const WorkoutPlanModel({
    required this.id,
    required this.name,
    required this.goal,
    required this.level,
    required this.sexVariant,
    required this.daysPerWeek,
    required this.durationWeeks,
    required this.equipment,
    required this.description,
    required this.tags,
  });

  final String id;
  final String name;
  final PlanGoal goal;
  final PlanLevel level;
  final SexVariant sexVariant;
  final int daysPerWeek;
  final int durationWeeks;
  final EquipmentType equipment;
  final String description;
  final List<String> tags;

  String get difficulty => level.name;
  int get totalWorkouts => daysPerWeek * durationWeeks;

  String get heroAsset {
    if (sexVariant == SexVariant.female || goal == PlanGoal.mobility) {
      return 'assets/images/workout_splash_2.svg';
    }
    if (equipment == EquipmentType.gym || goal == PlanGoal.strength) {
      return 'assets/images/workout_splash_3.svg';
    }
    return 'assets/images/workout_splash_1.svg';
  }

  String get badgeLabel => '${sexVariant.name.toUpperCase()} • ${equipment.name.toUpperCase()}';
}

class WorkoutDayModel {
  const WorkoutDayModel({
    required this.id,
    required this.planId,
    required this.dayIndex,
    required this.title,
  });

  final String id;
  final String planId;
  final int dayIndex;
  final String title;
}

class ExerciseModel {
  const ExerciseModel({
    required this.id,
    required this.name,
    required this.primaryMuscles,
    required this.equipment,
    required this.instructions,
    this.videoUrl,
  });

  final String id;
  final String name;
  final List<String> primaryMuscles;
  final EquipmentType equipment;
  final String instructions;
  final String? videoUrl;

  String get muscleGroup => primaryMuscles.isEmpty ? 'full body' : primaryMuscles.first;
}

class WorkoutSetModel {
  const WorkoutSetModel({
    required this.id,
    required this.workoutDayId,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.weightType,
    this.tempo,
    this.progressionRule,
  });

  final String id;
  final String workoutDayId;
  final String exerciseId;
  final int sets;
  final String reps;
  final int restSeconds;
  final String weightType;
  final String? tempo;
  final String? progressionRule;
}

class WorkoutSessionLogModel {
  const WorkoutSessionLogModel({
    required this.id,
    required this.planId,
    required this.workoutDayId,
    required this.date,
    required this.completed,
    required this.totalTime,
    required this.perceivedEffort,
    this.completedExercises = 0,
    this.note,
  });

  final String id;
  final String planId;
  final String workoutDayId;
  final DateTime date;
  final bool completed;
  final int totalTime;
  final int perceivedEffort;
  final int completedExercises;
  final String? note;
}

class WorkoutHistoryModel {
  const WorkoutHistoryModel({
    required this.date,
    required this.planId,
    required this.workoutDayId,
    required this.duration,
    required this.completedExercises,
  });

  final DateTime date;
  final String planId;
  final String workoutDayId;
  final int duration;
  final int completedExercises;
}
