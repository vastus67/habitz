import 'package:drift/drift.dart';
import 'package:habitz/core/database/app_database.dart';
import 'package:habitz/core/utils/id_generator.dart';

class SeedService {
  SeedService(this._db);

  final AppDatabase _db;

  Future<void> seedIfNeeded() async {
    final existingPlans = await _db.select(_db.workoutPlanEntries).get();
    if (existingPlans.isNotEmpty) return;

    await _seedHabits();
    await _seedPlansAndWorkouts();
  }

  Future<void> _seedHabits() async {
    final templates = [
      ('Water Intake', 'count', 8.0, 'glasses', 'hydration'),
      ('Sleep 7.5h+', 'duration', 7.5, 'hours', 'sleep'),
      ('Run / Walk', 'duration', 30.0, 'min', 'running'),
      ('Meditation', 'duration', 10.0, 'min', 'meditation'),
      ('Reading', 'duration', 20.0, 'min', 'reading'),
      ('Nutrition Log', 'binary', 1.0, 'done', 'nutrition'),
    ];
    for (final tpl in templates) {
      final id = IdGenerator.deterministic('habitSeed', [tpl.$1]);
      await _db.into(_db.habitEntries).insertOnConflictUpdate(
            HabitEntriesCompanion.insert(
              id: id,
              title: tpl.$1,
              type: tpl.$2,
              targetValue: Value(tpl.$3),
              unit: Value(tpl.$4),
              scheduleDays: '1,2,3,4,5,6,7',
              reminders: '08:00,20:00',
              createdAt: DateTime(2026, 1, 1),
              category: Value(tpl.$5),
            ),
          );
    }
  }

  Future<void> _seedPlansAndWorkouts() async {
    final plans = [
      _SeedPlan(
        'beginner_bodyweight_plan',
        'Beginner Bodyweight Plan',
        'fatloss',
        'beginner',
        'unisex',
        3,
        4,
        'none',
        'A simple beginner-friendly bodyweight plan focused on consistency and fat loss.',
        ['bodyweight', 'beginner', 'fatloss'],
      ),
      _SeedPlan(
        'gym_strength_builder',
        'Gym Strength Builder',
        'strength',
        'intermediate',
        'unisex',
        4,
        6,
        'gym',
        'Progressive strength program with upper/lower split and core accessories.',
        ['gym', 'strength', 'builder'],
      ),
      _SeedPlan(
        'fat_loss_program_home',
        'Fat Loss Program',
        'fatloss',
        'beginner',
        'unisex',
        3,
        4,
        'home',
        'Conditioning and circuit structure to improve calorie burn and weekly fitness momentum.',
        ['fatloss', 'conditioning', 'home'],
      ),
    ];

    for (final plan in plans) {
      final planId = IdGenerator.deterministic('plan', [plan.key]);
      await _db.into(_db.workoutPlanEntries).insert(
            WorkoutPlanEntriesCompanion.insert(
              id: planId,
              name: plan.name,
              goal: plan.goal,
              level: plan.level,
              sexVariant: plan.sexVariant,
              daysPerWeek: plan.daysPerWeek,
              durationWeeks: plan.durationWeeks,
              equipment: plan.equipment,
              description: plan.description,
              tags: plan.tags.join(','),
            ),
          );

      final days = _seedDaysForPlan(planId, plan.daysPerWeek, plan.durationWeeks, plan.name);
      for (final day in days) {
        await _db.into(_db.workoutDayEntries).insert(
              WorkoutDayEntriesCompanion.insert(
                id: day.id,
                planId: planId,
                dayIndex: day.dayIndex,
                title: day.title,
              ),
            );
        final dayExercises = _sampleExercisesForDay(plan.name, day.dayIndex);
        for (final exercise in dayExercises) {
          final existingExercise = await (_db.select(_db.exerciseEntries)
                ..where((tbl) => tbl.id.equals(exercise.id)))
              .getSingleOrNull();
          if (existingExercise == null) {
            await _db.into(_db.exerciseEntries).insert(
                  ExerciseEntriesCompanion.insert(
                    id: exercise.id,
                    name: exercise.name,
                    primaryMuscles: exercise.primaryMuscles,
                    equipment: exercise.equipment,
                    instructions: exercise.instructions,
                    videoUrl: Value(exercise.videoUrl),
                  ),
                );
          }

          await _db.into(_db.workoutSetEntries).insert(
                WorkoutSetEntriesCompanion.insert(
                  id: IdGenerator.deterministic('set', [day.id, exercise.id]),
                  workoutDayId: day.id,
                  exerciseId: exercise.id,
                  sets: exercise.sets,
                  reps: exercise.reps,
                  restSeconds: exercise.restSeconds,
                  tempo: const Value('2-1-2'),
                  weightType: exercise.weightType,
                  progressionRule: const Value('Increase reps by 1 weekly'),
                ),
              );
        }
      }
    }
  }

  List<_SeedDay> _seedDaysForPlan(
    String planId,
    int daysPerWeek,
    int durationWeeks,
    String planName,
  ) {
    final titles = _dayTitlesForPlan(planName, daysPerWeek);
    final totalDays = daysPerWeek * durationWeeks;
    return List.generate(totalDays, (index) {
      final dayIndex = index + 1;
      final cycleTitle = titles[index % titles.length];
      return _SeedDay(
        id: IdGenerator.deterministic('day', [planId, dayIndex.toString()]),
        dayIndex: dayIndex,
        title: cycleTitle,
      );
    });
  }

  List<String> _dayTitlesForPlan(String planName, int daysPerWeek) {
    if (planName == 'Gym Strength Builder') {
      return ['Upper Body', 'Lower Body', 'Pull Focus', 'Push + Core'];
    }
    if (planName == 'Fat Loss Program') {
      return ['Metabolic Circuit', 'Lower + Core', 'Cardio Conditioning'];
    }
    return ['Upper Body', 'Lower Body', 'Cardio + Core'].take(daysPerWeek).toList();
  }

  List<_SeedExercise> _sampleExercisesForDay(String planName, int dayIndex) {
    if (planName == 'Gym Strength Builder') {
      final phase = (dayIndex - 1) % 4;
      switch (phase) {
        case 0:
          return [
            _SeedExercise('Bench Press', 'chest,triceps', 'gym', 'Control descent and press explosively.', 4, '6-8', 90),
            _SeedExercise('Overhead Press', 'shoulders,triceps', 'gym', 'Brace core and press overhead.', 3, '8', 75),
            _SeedExercise('Incline Dumbbell Press', 'chest,shoulders', 'gym', 'Full range motion.', 3, '10', 60),
          ];
        case 1:
          return [
            _SeedExercise('Barbell Squat', 'legs,glutes', 'gym', 'Squat to parallel with tight brace.', 4, '5-7', 90),
            _SeedExercise('Romanian Deadlift', 'hamstrings,glutes', 'gym', 'Hinge and keep spine neutral.', 3, '8', 75),
            _SeedExercise('Walking Lunges', 'legs,core', 'gym', 'Long stride and controlled depth.', 3, '12', 60),
          ];
        case 2:
          return [
            _SeedExercise('Lat Pulldown', 'back,biceps', 'gym', 'Drive elbows down.', 4, '10', 75),
            _SeedExercise('Seated Cable Row', 'back', 'gym', 'Pause and squeeze lats.', 3, '10-12', 60),
            _SeedExercise('Face Pull', 'rear-delts,upper-back', 'gym', 'Pull rope to eye level.', 3, '12-15', 45),
          ];
        default:
          return [
            _SeedExercise('Dumbbell Shoulder Press', 'shoulders', 'gym', 'Controlled overhead press.', 3, '8-10', 60),
            _SeedExercise('Push-ups', 'chest,triceps', 'none', 'Body straight and elbows close.', 3, '12', 45),
            _SeedExercise('Plank', 'core', 'none', 'Brace and breathe steadily.', 3, '45s', 30),
          ];
      }
    }

    if (planName == 'Fat Loss Program') {
      final phase = (dayIndex - 1) % 3;
      switch (phase) {
        case 0:
          return [
            _SeedExercise('Burpees', 'full-body,cardio', 'none', 'Keep steady pace.', 3, '12', 45),
            _SeedExercise('Dumbbell Thruster', 'legs,shoulders', 'home', 'Drive from squat to press.', 3, '12', 45),
            _SeedExercise('Mountain Climbers', 'core,cardio', 'none', 'Fast but controlled knee drive.', 3, '30s', 30),
          ];
        case 1:
          return [
            _SeedExercise('Goblet Squat', 'legs,core', 'home', 'Keep chest up.', 4, '10', 60),
            _SeedExercise('Reverse Lunge', 'legs,glutes', 'none', 'Step back and balance.', 3, '10/leg', 45),
            _SeedExercise('Dead Bug', 'core', 'none', 'Lower back on floor.', 3, '12/side', 30),
          ];
        default:
          return [
            _SeedExercise('Jump Rope', 'cardio', 'home', 'Stay light on feet.', 4, '60s', 30),
            _SeedExercise('High Knees', 'cardio,core', 'none', 'Drive knees to hip height.', 3, '40s', 30),
            _SeedExercise('Plank Shoulder Tap', 'core,shoulders', 'none', 'Minimize hip sway.', 3, '20', 30),
          ];
      }
    }

    final phase = (dayIndex - 1) % 3;
    switch (phase) {
      case 0:
        return [
          _SeedExercise('Push Ups', 'chest,triceps', 'none', 'Keep body in straight line.', 3, '12', 45),
          _SeedExercise('Pike Push Up', 'shoulders', 'none', 'Hips high and controlled descent.', 3, '8-10', 45),
          _SeedExercise('Plank', 'core', 'none', 'Brace core and hold.', 3, '30s', 30),
        ];
      case 1:
        return [
          _SeedExercise('Bodyweight Squat', 'legs,glutes', 'none', 'Sit back and drive up.', 3, '15', 45),
          _SeedExercise('Glute Bridge', 'glutes,hamstrings', 'none', 'Pause at top.', 3, '15', 45),
          _SeedExercise('Calf Raise', 'calves', 'none', 'Full range repetition.', 3, '20', 30),
        ];
      default:
        return [
          _SeedExercise('Jumping Jacks', 'cardio', 'none', 'Consistent rhythm.', 3, '40s', 30),
          _SeedExercise('Mountain Climbers', 'core,cardio', 'none', 'Keep hips low.', 3, '30s', 30),
          _SeedExercise('Bicycle Crunch', 'core', 'none', 'Controlled twists.', 3, '20', 30),
        ];
    }
  }
}

class _SeedPlan {
  _SeedPlan(
    this.key,
    this.name,
    this.goal,
    this.level,
    this.sexVariant,
    this.daysPerWeek,
    this.durationWeeks,
    this.equipment,
    this.description,
    this.tags,
  );

  final String key;
  final String name;
  final String goal;
  final String level;
  final String sexVariant;
  final int daysPerWeek;
  final int durationWeeks;
  final String equipment;
  final String description;
  final List<String> tags;
}

class _SeedDay {
  _SeedDay({required this.id, required this.dayIndex, required this.title});
  final String id;
  final int dayIndex;
  final String title;
}

class _SeedExercise {
  _SeedExercise(
    this.name,
    this.primaryMuscles,
    this.equipment,
    this.instructions,
    this.sets,
    this.reps,
    this.restSeconds,
  ) : id = IdGenerator.deterministic('exercise', [name]),
       weightType = equipment == 'none' ? 'bodyweight' : 'kg',
       videoUrl = null;

  final String id;
  final String name;
  final String primaryMuscles;
  final String equipment;
  final String instructions;
  final int sets;
  final String reps;
  final int restSeconds;
  final String weightType;
  final String? videoUrl;
}
