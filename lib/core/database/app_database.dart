import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class HabitEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get type => text()();
  RealColumn get targetValue => real().withDefault(const Constant(0))();
  TextColumn get unit => text().withDefault(const Constant(''))();
  TextColumn get scheduleDays => text()();
  TextColumn get reminders => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get category => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitLogEntries extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text().references(HabitEntries, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get value => real().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutPlanEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get goal => text()();
  TextColumn get level => text()();
  TextColumn get sexVariant => text()();
  IntColumn get daysPerWeek => integer()();
  IntColumn get durationWeeks => integer()();
  TextColumn get equipment => text()();
  TextColumn get description => text()();
  TextColumn get tags => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutDayEntries extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(WorkoutPlanEntries, #id)();
  IntColumn get dayIndex => integer()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ExerciseEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get primaryMuscles => text()();
  TextColumn get equipment => text()();
  TextColumn get instructions => text()();
  TextColumn get videoUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSetEntries extends Table {
  TextColumn get id => text()();
  TextColumn get workoutDayId => text().references(WorkoutDayEntries, #id)();
  TextColumn get exerciseId => text().references(ExerciseEntries, #id)();
  IntColumn get sets => integer()();
  TextColumn get reps => text()();
  IntColumn get restSeconds => integer()();
  TextColumn get tempo => text().nullable()();
  TextColumn get weightType => text()();
  TextColumn get progressionRule => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSessionLogEntries extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(WorkoutPlanEntries, #id)();
  TextColumn get workoutDayId => text().references(WorkoutDayEntries, #id)();
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get totalTime => integer().withDefault(const Constant(0))();
  IntColumn get perceivedEffort => integer().withDefault(const Constant(5))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserProfileEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant('Athlete'))();
  TextColumn get sexVariant => text().withDefault(const Constant('unisex'))();
  TextColumn get primaryGoal => text().withDefault(const Constant('discipline'))();
  TextColumn get equipment => text().withDefault(const Constant('home'))();
  TextColumn get wakeTime => text().withDefault(const Constant('07:00'))();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get proEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get activePlanId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  HabitEntries,
  HabitLogEntries,
  WorkoutPlanEntries,
  WorkoutDayEntries,
  ExerciseEntries,
  WorkoutSetEntries,
  WorkoutSessionLogEntries,
  UserProfileEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.deleteTable('user_profile_entries');
            await m.createTable(userProfileEntries);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(docsDir.path, 'habitz.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
