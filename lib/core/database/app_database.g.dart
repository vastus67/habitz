// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitEntriesTable extends HabitEntries
    with TableInfo<$HabitEntriesTable, HabitEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetValueMeta =
      const VerificationMeta('targetValue');
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
      'target_value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _scheduleDaysMeta =
      const VerificationMeta('scheduleDays');
  @override
  late final GeneratedColumn<String> scheduleDays = GeneratedColumn<String>(
      'schedule_days', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remindersMeta =
      const VerificationMeta('reminders');
  @override
  late final GeneratedColumn<String> reminders = GeneratedColumn<String>(
      'reminders', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        type,
        targetValue,
        unit,
        scheduleDays,
        reminders,
        createdAt,
        category
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_entries';
  @override
  VerificationContext validateIntegrity(Insertable<HabitEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
          _targetValueMeta,
          targetValue.isAcceptableOrUnknown(
              data['target_value']!, _targetValueMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('schedule_days')) {
      context.handle(
          _scheduleDaysMeta,
          scheduleDays.isAcceptableOrUnknown(
              data['schedule_days']!, _scheduleDaysMeta));
    } else if (isInserting) {
      context.missing(_scheduleDaysMeta);
    }
    if (data.containsKey('reminders')) {
      context.handle(_remindersMeta,
          reminders.isAcceptableOrUnknown(data['reminders']!, _remindersMeta));
    } else if (isInserting) {
      context.missing(_remindersMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      targetValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_value'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      scheduleDays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_days'])!,
      reminders: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminders'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
    );
  }

  @override
  $HabitEntriesTable createAlias(String alias) {
    return $HabitEntriesTable(attachedDatabase, alias);
  }
}

class HabitEntry extends DataClass implements Insertable<HabitEntry> {
  final String id;
  final String title;
  final String type;
  final double targetValue;
  final String unit;
  final String scheduleDays;
  final String reminders;
  final DateTime createdAt;
  final String? category;
  const HabitEntry(
      {required this.id,
      required this.title,
      required this.type,
      required this.targetValue,
      required this.unit,
      required this.scheduleDays,
      required this.reminders,
      required this.createdAt,
      this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['target_value'] = Variable<double>(targetValue);
    map['unit'] = Variable<String>(unit);
    map['schedule_days'] = Variable<String>(scheduleDays);
    map['reminders'] = Variable<String>(reminders);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  HabitEntriesCompanion toCompanion(bool nullToAbsent) {
    return HabitEntriesCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      targetValue: Value(targetValue),
      unit: Value(unit),
      scheduleDays: Value(scheduleDays),
      reminders: Value(reminders),
      createdAt: Value(createdAt),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory HabitEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      unit: serializer.fromJson<String>(json['unit']),
      scheduleDays: serializer.fromJson<String>(json['scheduleDays']),
      reminders: serializer.fromJson<String>(json['reminders']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'targetValue': serializer.toJson<double>(targetValue),
      'unit': serializer.toJson<String>(unit),
      'scheduleDays': serializer.toJson<String>(scheduleDays),
      'reminders': serializer.toJson<String>(reminders),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'category': serializer.toJson<String?>(category),
    };
  }

  HabitEntry copyWith(
          {String? id,
          String? title,
          String? type,
          double? targetValue,
          String? unit,
          String? scheduleDays,
          String? reminders,
          DateTime? createdAt,
          Value<String?> category = const Value.absent()}) =>
      HabitEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        targetValue: targetValue ?? this.targetValue,
        unit: unit ?? this.unit,
        scheduleDays: scheduleDays ?? this.scheduleDays,
        reminders: reminders ?? this.reminders,
        createdAt: createdAt ?? this.createdAt,
        category: category.present ? category.value : this.category,
      );
  HabitEntry copyWithCompanion(HabitEntriesCompanion data) {
    return HabitEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      scheduleDays: data.scheduleDays.present
          ? data.scheduleDays.value
          : this.scheduleDays,
      reminders: data.reminders.present ? data.reminders.value : this.reminders,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('scheduleDays: $scheduleDays, ')
          ..write('reminders: $reminders, ')
          ..write('createdAt: $createdAt, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, type, targetValue, unit,
      scheduleDays, reminders, createdAt, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.unit == this.unit &&
          other.scheduleDays == this.scheduleDays &&
          other.reminders == this.reminders &&
          other.createdAt == this.createdAt &&
          other.category == this.category);
}

class HabitEntriesCompanion extends UpdateCompanion<HabitEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> type;
  final Value<double> targetValue;
  final Value<String> unit;
  final Value<String> scheduleDays;
  final Value<String> reminders;
  final Value<DateTime> createdAt;
  final Value<String?> category;
  final Value<int> rowid;
  const HabitEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.scheduleDays = const Value.absent(),
    this.reminders = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitEntriesCompanion.insert({
    required String id,
    required String title,
    required String type,
    this.targetValue = const Value.absent(),
    this.unit = const Value.absent(),
    required String scheduleDays,
    required String reminders,
    required DateTime createdAt,
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        type = Value(type),
        scheduleDays = Value(scheduleDays),
        reminders = Value(reminders),
        createdAt = Value(createdAt);
  static Insertable<HabitEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? type,
    Expression<double>? targetValue,
    Expression<String>? unit,
    Expression<String>? scheduleDays,
    Expression<String>? reminders,
    Expression<DateTime>? createdAt,
    Expression<String>? category,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (unit != null) 'unit': unit,
      if (scheduleDays != null) 'schedule_days': scheduleDays,
      if (reminders != null) 'reminders': reminders,
      if (createdAt != null) 'created_at': createdAt,
      if (category != null) 'category': category,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? type,
      Value<double>? targetValue,
      Value<String>? unit,
      Value<String>? scheduleDays,
      Value<String>? reminders,
      Value<DateTime>? createdAt,
      Value<String?>? category,
      Value<int>? rowid}) {
    return HabitEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      reminders: reminders ?? this.reminders,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (scheduleDays.present) {
      map['schedule_days'] = Variable<String>(scheduleDays.value);
    }
    if (reminders.present) {
      map['reminders'] = Variable<String>(reminders.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('scheduleDays: $scheduleDays, ')
          ..write('reminders: $reminders, ')
          ..write('createdAt: $createdAt, ')
          ..write('category: $category, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitLogEntriesTable extends HabitLogEntries
    with TableInfo<$HabitLogEntriesTable, HabitLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitLogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _habitIdMeta =
      const VerificationMeta('habitId');
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES habit_entries (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, habitId, date, value, completed, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_log_entries';
  @override
  VerificationContext validateIntegrity(Insertable<HabitLogEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitLogEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      habitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $HabitLogEntriesTable createAlias(String alias) {
    return $HabitLogEntriesTable(attachedDatabase, alias);
  }
}

class HabitLogEntry extends DataClass implements Insertable<HabitLogEntry> {
  final String id;
  final String habitId;
  final DateTime date;
  final double value;
  final bool completed;
  final String? note;
  const HabitLogEntry(
      {required this.id,
      required this.habitId,
      required this.date,
      required this.value,
      required this.completed,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['date'] = Variable<DateTime>(date);
    map['value'] = Variable<double>(value);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  HabitLogEntriesCompanion toCompanion(bool nullToAbsent) {
    return HabitLogEntriesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      date: Value(date),
      value: Value(value),
      completed: Value(completed),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory HabitLogEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitLogEntry(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      date: serializer.fromJson<DateTime>(json['date']),
      value: serializer.fromJson<double>(json['value']),
      completed: serializer.fromJson<bool>(json['completed']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'date': serializer.toJson<DateTime>(date),
      'value': serializer.toJson<double>(value),
      'completed': serializer.toJson<bool>(completed),
      'note': serializer.toJson<String?>(note),
    };
  }

  HabitLogEntry copyWith(
          {String? id,
          String? habitId,
          DateTime? date,
          double? value,
          bool? completed,
          Value<String?> note = const Value.absent()}) =>
      HabitLogEntry(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        date: date ?? this.date,
        value: value ?? this.value,
        completed: completed ?? this.completed,
        note: note.present ? note.value : this.note,
      );
  HabitLogEntry copyWithCompanion(HabitLogEntriesCompanion data) {
    return HabitLogEntry(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      value: data.value.present ? data.value.value : this.value,
      completed: data.completed.present ? data.completed.value : this.completed,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogEntry(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('value: $value, ')
          ..write('completed: $completed, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, date, value, completed, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitLogEntry &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.value == this.value &&
          other.completed == this.completed &&
          other.note == this.note);
}

class HabitLogEntriesCompanion extends UpdateCompanion<HabitLogEntry> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<DateTime> date;
  final Value<double> value;
  final Value<bool> completed;
  final Value<String?> note;
  final Value<int> rowid;
  const HabitLogEntriesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.value = const Value.absent(),
    this.completed = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitLogEntriesCompanion.insert({
    required String id,
    required String habitId,
    required DateTime date,
    this.value = const Value.absent(),
    this.completed = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        habitId = Value(habitId),
        date = Value(date);
  static Insertable<HabitLogEntry> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<DateTime>? date,
    Expression<double>? value,
    Expression<bool>? completed,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (value != null) 'value': value,
      if (completed != null) 'completed': completed,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitLogEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? habitId,
      Value<DateTime>? date,
      Value<double>? value,
      Value<bool>? completed,
      Value<String?>? note,
      Value<int>? rowid}) {
    return HabitLogEntriesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      value: value ?? this.value,
      completed: completed ?? this.completed,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('value: $value, ')
          ..write('completed: $completed, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlanEntriesTable extends WorkoutPlanEntries
    with TableInfo<$WorkoutPlanEntriesTable, WorkoutPlanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlanEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
      'goal', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sexVariantMeta =
      const VerificationMeta('sexVariant');
  @override
  late final GeneratedColumn<String> sexVariant = GeneratedColumn<String>(
      'sex_variant', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _daysPerWeekMeta =
      const VerificationMeta('daysPerWeek');
  @override
  late final GeneratedColumn<int> daysPerWeek = GeneratedColumn<int>(
      'days_per_week', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationWeeksMeta =
      const VerificationMeta('durationWeeks');
  @override
  late final GeneratedColumn<int> durationWeeks = GeneratedColumn<int>(
      'duration_weeks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        goal,
        level,
        sexVariant,
        daysPerWeek,
        durationWeeks,
        equipment,
        description,
        tags
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plan_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutPlanEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
          _goalMeta, goal.isAcceptableOrUnknown(data['goal']!, _goalMeta));
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('sex_variant')) {
      context.handle(
          _sexVariantMeta,
          sexVariant.isAcceptableOrUnknown(
              data['sex_variant']!, _sexVariantMeta));
    } else if (isInserting) {
      context.missing(_sexVariantMeta);
    }
    if (data.containsKey('days_per_week')) {
      context.handle(
          _daysPerWeekMeta,
          daysPerWeek.isAcceptableOrUnknown(
              data['days_per_week']!, _daysPerWeekMeta));
    } else if (isInserting) {
      context.missing(_daysPerWeekMeta);
    }
    if (data.containsKey('duration_weeks')) {
      context.handle(
          _durationWeeksMeta,
          durationWeeks.isAcceptableOrUnknown(
              data['duration_weeks']!, _durationWeeksMeta));
    } else if (isInserting) {
      context.missing(_durationWeeksMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlanEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      goal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      sexVariant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex_variant'])!,
      daysPerWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days_per_week'])!,
      durationWeeks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_weeks'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
    );
  }

  @override
  $WorkoutPlanEntriesTable createAlias(String alias) {
    return $WorkoutPlanEntriesTable(attachedDatabase, alias);
  }
}

class WorkoutPlanEntry extends DataClass
    implements Insertable<WorkoutPlanEntry> {
  final String id;
  final String name;
  final String goal;
  final String level;
  final String sexVariant;
  final int daysPerWeek;
  final int durationWeeks;
  final String equipment;
  final String description;
  final String tags;
  const WorkoutPlanEntry(
      {required this.id,
      required this.name,
      required this.goal,
      required this.level,
      required this.sexVariant,
      required this.daysPerWeek,
      required this.durationWeeks,
      required this.equipment,
      required this.description,
      required this.tags});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['goal'] = Variable<String>(goal);
    map['level'] = Variable<String>(level);
    map['sex_variant'] = Variable<String>(sexVariant);
    map['days_per_week'] = Variable<int>(daysPerWeek);
    map['duration_weeks'] = Variable<int>(durationWeeks);
    map['equipment'] = Variable<String>(equipment);
    map['description'] = Variable<String>(description);
    map['tags'] = Variable<String>(tags);
    return map;
  }

  WorkoutPlanEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlanEntriesCompanion(
      id: Value(id),
      name: Value(name),
      goal: Value(goal),
      level: Value(level),
      sexVariant: Value(sexVariant),
      daysPerWeek: Value(daysPerWeek),
      durationWeeks: Value(durationWeeks),
      equipment: Value(equipment),
      description: Value(description),
      tags: Value(tags),
    );
  }

  factory WorkoutPlanEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlanEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      goal: serializer.fromJson<String>(json['goal']),
      level: serializer.fromJson<String>(json['level']),
      sexVariant: serializer.fromJson<String>(json['sexVariant']),
      daysPerWeek: serializer.fromJson<int>(json['daysPerWeek']),
      durationWeeks: serializer.fromJson<int>(json['durationWeeks']),
      equipment: serializer.fromJson<String>(json['equipment']),
      description: serializer.fromJson<String>(json['description']),
      tags: serializer.fromJson<String>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'goal': serializer.toJson<String>(goal),
      'level': serializer.toJson<String>(level),
      'sexVariant': serializer.toJson<String>(sexVariant),
      'daysPerWeek': serializer.toJson<int>(daysPerWeek),
      'durationWeeks': serializer.toJson<int>(durationWeeks),
      'equipment': serializer.toJson<String>(equipment),
      'description': serializer.toJson<String>(description),
      'tags': serializer.toJson<String>(tags),
    };
  }

  WorkoutPlanEntry copyWith(
          {String? id,
          String? name,
          String? goal,
          String? level,
          String? sexVariant,
          int? daysPerWeek,
          int? durationWeeks,
          String? equipment,
          String? description,
          String? tags}) =>
      WorkoutPlanEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        goal: goal ?? this.goal,
        level: level ?? this.level,
        sexVariant: sexVariant ?? this.sexVariant,
        daysPerWeek: daysPerWeek ?? this.daysPerWeek,
        durationWeeks: durationWeeks ?? this.durationWeeks,
        equipment: equipment ?? this.equipment,
        description: description ?? this.description,
        tags: tags ?? this.tags,
      );
  WorkoutPlanEntry copyWithCompanion(WorkoutPlanEntriesCompanion data) {
    return WorkoutPlanEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      goal: data.goal.present ? data.goal.value : this.goal,
      level: data.level.present ? data.level.value : this.level,
      sexVariant:
          data.sexVariant.present ? data.sexVariant.value : this.sexVariant,
      daysPerWeek:
          data.daysPerWeek.present ? data.daysPerWeek.value : this.daysPerWeek,
      durationWeeks: data.durationWeeks.present
          ? data.durationWeeks.value
          : this.durationWeeks,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      description:
          data.description.present ? data.description.value : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goal: $goal, ')
          ..write('level: $level, ')
          ..write('sexVariant: $sexVariant, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('durationWeeks: $durationWeeks, ')
          ..write('equipment: $equipment, ')
          ..write('description: $description, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, goal, level, sexVariant,
      daysPerWeek, durationWeeks, equipment, description, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlanEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.goal == this.goal &&
          other.level == this.level &&
          other.sexVariant == this.sexVariant &&
          other.daysPerWeek == this.daysPerWeek &&
          other.durationWeeks == this.durationWeeks &&
          other.equipment == this.equipment &&
          other.description == this.description &&
          other.tags == this.tags);
}

class WorkoutPlanEntriesCompanion extends UpdateCompanion<WorkoutPlanEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> goal;
  final Value<String> level;
  final Value<String> sexVariant;
  final Value<int> daysPerWeek;
  final Value<int> durationWeeks;
  final Value<String> equipment;
  final Value<String> description;
  final Value<String> tags;
  final Value<int> rowid;
  const WorkoutPlanEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.goal = const Value.absent(),
    this.level = const Value.absent(),
    this.sexVariant = const Value.absent(),
    this.daysPerWeek = const Value.absent(),
    this.durationWeeks = const Value.absent(),
    this.equipment = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPlanEntriesCompanion.insert({
    required String id,
    required String name,
    required String goal,
    required String level,
    required String sexVariant,
    required int daysPerWeek,
    required int durationWeeks,
    required String equipment,
    required String description,
    required String tags,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        goal = Value(goal),
        level = Value(level),
        sexVariant = Value(sexVariant),
        daysPerWeek = Value(daysPerWeek),
        durationWeeks = Value(durationWeeks),
        equipment = Value(equipment),
        description = Value(description),
        tags = Value(tags);
  static Insertable<WorkoutPlanEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? goal,
    Expression<String>? level,
    Expression<String>? sexVariant,
    Expression<int>? daysPerWeek,
    Expression<int>? durationWeeks,
    Expression<String>? equipment,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (goal != null) 'goal': goal,
      if (level != null) 'level': level,
      if (sexVariant != null) 'sex_variant': sexVariant,
      if (daysPerWeek != null) 'days_per_week': daysPerWeek,
      if (durationWeeks != null) 'duration_weeks': durationWeeks,
      if (equipment != null) 'equipment': equipment,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPlanEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? goal,
      Value<String>? level,
      Value<String>? sexVariant,
      Value<int>? daysPerWeek,
      Value<int>? durationWeeks,
      Value<String>? equipment,
      Value<String>? description,
      Value<String>? tags,
      Value<int>? rowid}) {
    return WorkoutPlanEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      sexVariant: sexVariant ?? this.sexVariant,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      equipment: equipment ?? this.equipment,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (sexVariant.present) {
      map['sex_variant'] = Variable<String>(sexVariant.value);
    }
    if (daysPerWeek.present) {
      map['days_per_week'] = Variable<int>(daysPerWeek.value);
    }
    if (durationWeeks.present) {
      map['duration_weeks'] = Variable<int>(durationWeeks.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goal: $goal, ')
          ..write('level: $level, ')
          ..write('sexVariant: $sexVariant, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('durationWeeks: $durationWeeks, ')
          ..write('equipment: $equipment, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutDayEntriesTable extends WorkoutDayEntries
    with TableInfo<$WorkoutDayEntriesTable, WorkoutDayEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutDayEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_plan_entries (id)'));
  static const VerificationMeta _dayIndexMeta =
      const VerificationMeta('dayIndex');
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
      'day_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, planId, dayIndex, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_day_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutDayEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(_dayIndexMeta,
          dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta));
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutDayEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutDayEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_id'])!,
      dayIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_index'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
    );
  }

  @override
  $WorkoutDayEntriesTable createAlias(String alias) {
    return $WorkoutDayEntriesTable(attachedDatabase, alias);
  }
}

class WorkoutDayEntry extends DataClass implements Insertable<WorkoutDayEntry> {
  final String id;
  final String planId;
  final int dayIndex;
  final String title;
  const WorkoutDayEntry(
      {required this.id,
      required this.planId,
      required this.dayIndex,
      required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['day_index'] = Variable<int>(dayIndex);
    map['title'] = Variable<String>(title);
    return map;
  }

  WorkoutDayEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutDayEntriesCompanion(
      id: Value(id),
      planId: Value(planId),
      dayIndex: Value(dayIndex),
      title: Value(title),
    );
  }

  factory WorkoutDayEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutDayEntry(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'title': serializer.toJson<String>(title),
    };
  }

  WorkoutDayEntry copyWith(
          {String? id, String? planId, int? dayIndex, String? title}) =>
      WorkoutDayEntry(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        dayIndex: dayIndex ?? this.dayIndex,
        title: title ?? this.title,
      );
  WorkoutDayEntry copyWithCompanion(WorkoutDayEntriesCompanion data) {
    return WorkoutDayEntry(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDayEntry(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, dayIndex, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutDayEntry &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.dayIndex == this.dayIndex &&
          other.title == this.title);
}

class WorkoutDayEntriesCompanion extends UpdateCompanion<WorkoutDayEntry> {
  final Value<String> id;
  final Value<String> planId;
  final Value<int> dayIndex;
  final Value<String> title;
  final Value<int> rowid;
  const WorkoutDayEntriesCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.title = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutDayEntriesCompanion.insert({
    required String id,
    required String planId,
    required int dayIndex,
    required String title,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        planId = Value(planId),
        dayIndex = Value(dayIndex),
        title = Value(title);
  static Insertable<WorkoutDayEntry> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<int>? dayIndex,
    Expression<String>? title,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (title != null) 'title': title,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutDayEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? planId,
      Value<int>? dayIndex,
      Value<String>? title,
      Value<int>? rowid}) {
    return WorkoutDayEntriesCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      dayIndex: dayIndex ?? this.dayIndex,
      title: title ?? this.title,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDayEntriesCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('title: $title, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseEntriesTable extends ExerciseEntries
    with TableInfo<$ExerciseEntriesTable, ExerciseEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _primaryMusclesMeta =
      const VerificationMeta('primaryMuscles');
  @override
  late final GeneratedColumn<String> primaryMuscles = GeneratedColumn<String>(
      'primary_muscles', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _videoUrlMeta =
      const VerificationMeta('videoUrl');
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
      'video_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, primaryMuscles, equipment, instructions, videoUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_entries';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('primary_muscles')) {
      context.handle(
          _primaryMusclesMeta,
          primaryMuscles.isAcceptableOrUnknown(
              data['primary_muscles']!, _primaryMusclesMeta));
    } else if (isInserting) {
      context.missing(_primaryMusclesMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    } else if (isInserting) {
      context.missing(_instructionsMeta);
    }
    if (data.containsKey('video_url')) {
      context.handle(_videoUrlMeta,
          videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      primaryMuscles: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_muscles'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions'])!,
      videoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}video_url']),
    );
  }

  @override
  $ExerciseEntriesTable createAlias(String alias) {
    return $ExerciseEntriesTable(attachedDatabase, alias);
  }
}

class ExerciseEntry extends DataClass implements Insertable<ExerciseEntry> {
  final String id;
  final String name;
  final String primaryMuscles;
  final String equipment;
  final String instructions;
  final String? videoUrl;
  const ExerciseEntry(
      {required this.id,
      required this.name,
      required this.primaryMuscles,
      required this.equipment,
      required this.instructions,
      this.videoUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['primary_muscles'] = Variable<String>(primaryMuscles);
    map['equipment'] = Variable<String>(equipment);
    map['instructions'] = Variable<String>(instructions);
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    return map;
  }

  ExerciseEntriesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseEntriesCompanion(
      id: Value(id),
      name: Value(name),
      primaryMuscles: Value(primaryMuscles),
      equipment: Value(equipment),
      instructions: Value(instructions),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
    );
  }

  factory ExerciseEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      primaryMuscles: serializer.fromJson<String>(json['primaryMuscles']),
      equipment: serializer.fromJson<String>(json['equipment']),
      instructions: serializer.fromJson<String>(json['instructions']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'primaryMuscles': serializer.toJson<String>(primaryMuscles),
      'equipment': serializer.toJson<String>(equipment),
      'instructions': serializer.toJson<String>(instructions),
      'videoUrl': serializer.toJson<String?>(videoUrl),
    };
  }

  ExerciseEntry copyWith(
          {String? id,
          String? name,
          String? primaryMuscles,
          String? equipment,
          String? instructions,
          Value<String?> videoUrl = const Value.absent()}) =>
      ExerciseEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        primaryMuscles: primaryMuscles ?? this.primaryMuscles,
        equipment: equipment ?? this.equipment,
        instructions: instructions ?? this.instructions,
        videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
      );
  ExerciseEntry copyWithCompanion(ExerciseEntriesCompanion data) {
    return ExerciseEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      primaryMuscles: data.primaryMuscles.present
          ? data.primaryMuscles.value
          : this.primaryMuscles,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('instructions: $instructions, ')
          ..write('videoUrl: $videoUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, primaryMuscles, equipment, instructions, videoUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.primaryMuscles == this.primaryMuscles &&
          other.equipment == this.equipment &&
          other.instructions == this.instructions &&
          other.videoUrl == this.videoUrl);
}

class ExerciseEntriesCompanion extends UpdateCompanion<ExerciseEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> primaryMuscles;
  final Value<String> equipment;
  final Value<String> instructions;
  final Value<String?> videoUrl;
  final Value<int> rowid;
  const ExerciseEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryMuscles = const Value.absent(),
    this.equipment = const Value.absent(),
    this.instructions = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseEntriesCompanion.insert({
    required String id,
    required String name,
    required String primaryMuscles,
    required String equipment,
    required String instructions,
    this.videoUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        primaryMuscles = Value(primaryMuscles),
        equipment = Value(equipment),
        instructions = Value(instructions);
  static Insertable<ExerciseEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? primaryMuscles,
    Expression<String>? equipment,
    Expression<String>? instructions,
    Expression<String>? videoUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (primaryMuscles != null) 'primary_muscles': primaryMuscles,
      if (equipment != null) 'equipment': equipment,
      if (instructions != null) 'instructions': instructions,
      if (videoUrl != null) 'video_url': videoUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? primaryMuscles,
      Value<String>? equipment,
      Value<String>? instructions,
      Value<String?>? videoUrl,
      Value<int>? rowid}) {
    return ExerciseEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      videoUrl: videoUrl ?? this.videoUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (primaryMuscles.present) {
      map['primary_muscles'] = Variable<String>(primaryMuscles.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('instructions: $instructions, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetEntriesTable extends WorkoutSetEntries
    with TableInfo<$WorkoutSetEntriesTable, WorkoutSetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutDayIdMeta =
      const VerificationMeta('workoutDayId');
  @override
  late final GeneratedColumn<String> workoutDayId = GeneratedColumn<String>(
      'workout_day_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_day_entries (id)'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercise_entries (id)'));
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
      'sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<String> reps = GeneratedColumn<String>(
      'reps', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _restSecondsMeta =
      const VerificationMeta('restSeconds');
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
      'rest_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<String> tempo = GeneratedColumn<String>(
      'tempo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightTypeMeta =
      const VerificationMeta('weightType');
  @override
  late final GeneratedColumn<String> weightType = GeneratedColumn<String>(
      'weight_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressionRuleMeta =
      const VerificationMeta('progressionRule');
  @override
  late final GeneratedColumn<String> progressionRule = GeneratedColumn<String>(
      'progression_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workoutDayId,
        exerciseId,
        sets,
        reps,
        restSeconds,
        tempo,
        weightType,
        progressionRule
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_set_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSetEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_day_id')) {
      context.handle(
          _workoutDayIdMeta,
          workoutDayId.isAcceptableOrUnknown(
              data['workout_day_id']!, _workoutDayIdMeta));
    } else if (isInserting) {
      context.missing(_workoutDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
          _setsMeta, sets.isAcceptableOrUnknown(data['sets']!, _setsMeta));
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
          _restSecondsMeta,
          restSeconds.isAcceptableOrUnknown(
              data['rest_seconds']!, _restSecondsMeta));
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('tempo')) {
      context.handle(
          _tempoMeta, tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta));
    }
    if (data.containsKey('weight_type')) {
      context.handle(
          _weightTypeMeta,
          weightType.isAcceptableOrUnknown(
              data['weight_type']!, _weightTypeMeta));
    } else if (isInserting) {
      context.missing(_weightTypeMeta);
    }
    if (data.containsKey('progression_rule')) {
      context.handle(
          _progressionRuleMeta,
          progressionRule.isAcceptableOrUnknown(
              data['progression_rule']!, _progressionRuleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutDayId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_day_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      sets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sets'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reps'])!,
      restSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_seconds'])!,
      tempo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tempo']),
      weightType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weight_type'])!,
      progressionRule: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}progression_rule']),
    );
  }

  @override
  $WorkoutSetEntriesTable createAlias(String alias) {
    return $WorkoutSetEntriesTable(attachedDatabase, alias);
  }
}

class WorkoutSetEntry extends DataClass implements Insertable<WorkoutSetEntry> {
  final String id;
  final String workoutDayId;
  final String exerciseId;
  final int sets;
  final String reps;
  final int restSeconds;
  final String? tempo;
  final String weightType;
  final String? progressionRule;
  const WorkoutSetEntry(
      {required this.id,
      required this.workoutDayId,
      required this.exerciseId,
      required this.sets,
      required this.reps,
      required this.restSeconds,
      this.tempo,
      required this.weightType,
      this.progressionRule});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_day_id'] = Variable<String>(workoutDayId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sets'] = Variable<int>(sets);
    map['reps'] = Variable<String>(reps);
    map['rest_seconds'] = Variable<int>(restSeconds);
    if (!nullToAbsent || tempo != null) {
      map['tempo'] = Variable<String>(tempo);
    }
    map['weight_type'] = Variable<String>(weightType);
    if (!nullToAbsent || progressionRule != null) {
      map['progression_rule'] = Variable<String>(progressionRule);
    }
    return map;
  }

  WorkoutSetEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetEntriesCompanion(
      id: Value(id),
      workoutDayId: Value(workoutDayId),
      exerciseId: Value(exerciseId),
      sets: Value(sets),
      reps: Value(reps),
      restSeconds: Value(restSeconds),
      tempo:
          tempo == null && nullToAbsent ? const Value.absent() : Value(tempo),
      weightType: Value(weightType),
      progressionRule: progressionRule == null && nullToAbsent
          ? const Value.absent()
          : Value(progressionRule),
    );
  }

  factory WorkoutSetEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetEntry(
      id: serializer.fromJson<String>(json['id']),
      workoutDayId: serializer.fromJson<String>(json['workoutDayId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sets: serializer.fromJson<int>(json['sets']),
      reps: serializer.fromJson<String>(json['reps']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      tempo: serializer.fromJson<String?>(json['tempo']),
      weightType: serializer.fromJson<String>(json['weightType']),
      progressionRule: serializer.fromJson<String?>(json['progressionRule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutDayId': serializer.toJson<String>(workoutDayId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sets': serializer.toJson<int>(sets),
      'reps': serializer.toJson<String>(reps),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'tempo': serializer.toJson<String?>(tempo),
      'weightType': serializer.toJson<String>(weightType),
      'progressionRule': serializer.toJson<String?>(progressionRule),
    };
  }

  WorkoutSetEntry copyWith(
          {String? id,
          String? workoutDayId,
          String? exerciseId,
          int? sets,
          String? reps,
          int? restSeconds,
          Value<String?> tempo = const Value.absent(),
          String? weightType,
          Value<String?> progressionRule = const Value.absent()}) =>
      WorkoutSetEntry(
        id: id ?? this.id,
        workoutDayId: workoutDayId ?? this.workoutDayId,
        exerciseId: exerciseId ?? this.exerciseId,
        sets: sets ?? this.sets,
        reps: reps ?? this.reps,
        restSeconds: restSeconds ?? this.restSeconds,
        tempo: tempo.present ? tempo.value : this.tempo,
        weightType: weightType ?? this.weightType,
        progressionRule: progressionRule.present
            ? progressionRule.value
            : this.progressionRule,
      );
  WorkoutSetEntry copyWithCompanion(WorkoutSetEntriesCompanion data) {
    return WorkoutSetEntry(
      id: data.id.present ? data.id.value : this.id,
      workoutDayId: data.workoutDayId.present
          ? data.workoutDayId.value
          : this.workoutDayId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      restSeconds:
          data.restSeconds.present ? data.restSeconds.value : this.restSeconds,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      weightType:
          data.weightType.present ? data.weightType.value : this.weightType,
      progressionRule: data.progressionRule.present
          ? data.progressionRule.value
          : this.progressionRule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetEntry(')
          ..write('id: $id, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('tempo: $tempo, ')
          ..write('weightType: $weightType, ')
          ..write('progressionRule: $progressionRule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutDayId, exerciseId, sets, reps,
      restSeconds, tempo, weightType, progressionRule);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetEntry &&
          other.id == this.id &&
          other.workoutDayId == this.workoutDayId &&
          other.exerciseId == this.exerciseId &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.restSeconds == this.restSeconds &&
          other.tempo == this.tempo &&
          other.weightType == this.weightType &&
          other.progressionRule == this.progressionRule);
}

class WorkoutSetEntriesCompanion extends UpdateCompanion<WorkoutSetEntry> {
  final Value<String> id;
  final Value<String> workoutDayId;
  final Value<String> exerciseId;
  final Value<int> sets;
  final Value<String> reps;
  final Value<int> restSeconds;
  final Value<String?> tempo;
  final Value<String> weightType;
  final Value<String?> progressionRule;
  final Value<int> rowid;
  const WorkoutSetEntriesCompanion({
    this.id = const Value.absent(),
    this.workoutDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.tempo = const Value.absent(),
    this.weightType = const Value.absent(),
    this.progressionRule = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetEntriesCompanion.insert({
    required String id,
    required String workoutDayId,
    required String exerciseId,
    required int sets,
    required String reps,
    required int restSeconds,
    this.tempo = const Value.absent(),
    required String weightType,
    this.progressionRule = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workoutDayId = Value(workoutDayId),
        exerciseId = Value(exerciseId),
        sets = Value(sets),
        reps = Value(reps),
        restSeconds = Value(restSeconds),
        weightType = Value(weightType);
  static Insertable<WorkoutSetEntry> custom({
    Expression<String>? id,
    Expression<String>? workoutDayId,
    Expression<String>? exerciseId,
    Expression<int>? sets,
    Expression<String>? reps,
    Expression<int>? restSeconds,
    Expression<String>? tempo,
    Expression<String>? weightType,
    Expression<String>? progressionRule,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutDayId != null) 'workout_day_id': workoutDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (tempo != null) 'tempo': tempo,
      if (weightType != null) 'weight_type': weightType,
      if (progressionRule != null) 'progression_rule': progressionRule,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? workoutDayId,
      Value<String>? exerciseId,
      Value<int>? sets,
      Value<String>? reps,
      Value<int>? restSeconds,
      Value<String?>? tempo,
      Value<String>? weightType,
      Value<String?>? progressionRule,
      Value<int>? rowid}) {
    return WorkoutSetEntriesCompanion(
      id: id ?? this.id,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      tempo: tempo ?? this.tempo,
      weightType: weightType ?? this.weightType,
      progressionRule: progressionRule ?? this.progressionRule,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutDayId.present) {
      map['workout_day_id'] = Variable<String>(workoutDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<String>(reps.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<String>(tempo.value);
    }
    if (weightType.present) {
      map['weight_type'] = Variable<String>(weightType.value);
    }
    if (progressionRule.present) {
      map['progression_rule'] = Variable<String>(progressionRule.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('tempo: $tempo, ')
          ..write('weightType: $weightType, ')
          ..write('progressionRule: $progressionRule, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionLogEntriesTable extends WorkoutSessionLogEntries
    with TableInfo<$WorkoutSessionLogEntriesTable, WorkoutSessionLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionLogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_plan_entries (id)'));
  static const VerificationMeta _workoutDayIdMeta =
      const VerificationMeta('workoutDayId');
  @override
  late final GeneratedColumn<String> workoutDayId = GeneratedColumn<String>(
      'workout_day_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_day_entries (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _totalTimeMeta =
      const VerificationMeta('totalTime');
  @override
  late final GeneratedColumn<int> totalTime = GeneratedColumn<int>(
      'total_time', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _perceivedEffortMeta =
      const VerificationMeta('perceivedEffort');
  @override
  late final GeneratedColumn<int> perceivedEffort = GeneratedColumn<int>(
      'perceived_effort', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        planId,
        workoutDayId,
        date,
        completed,
        totalTime,
        perceivedEffort,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_session_log_entries';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkoutSessionLogEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('workout_day_id')) {
      context.handle(
          _workoutDayIdMeta,
          workoutDayId.isAcceptableOrUnknown(
              data['workout_day_id']!, _workoutDayIdMeta));
    } else if (isInserting) {
      context.missing(_workoutDayIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('total_time')) {
      context.handle(_totalTimeMeta,
          totalTime.isAcceptableOrUnknown(data['total_time']!, _totalTimeMeta));
    }
    if (data.containsKey('perceived_effort')) {
      context.handle(
          _perceivedEffortMeta,
          perceivedEffort.isAcceptableOrUnknown(
              data['perceived_effort']!, _perceivedEffortMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionLogEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_id'])!,
      workoutDayId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_day_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      totalTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_time'])!,
      perceivedEffort: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}perceived_effort'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $WorkoutSessionLogEntriesTable createAlias(String alias) {
    return $WorkoutSessionLogEntriesTable(attachedDatabase, alias);
  }
}

class WorkoutSessionLogEntry extends DataClass
    implements Insertable<WorkoutSessionLogEntry> {
  final String id;
  final String planId;
  final String workoutDayId;
  final DateTime date;
  final bool completed;
  final int totalTime;
  final int perceivedEffort;
  final String? note;
  const WorkoutSessionLogEntry(
      {required this.id,
      required this.planId,
      required this.workoutDayId,
      required this.date,
      required this.completed,
      required this.totalTime,
      required this.perceivedEffort,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['workout_day_id'] = Variable<String>(workoutDayId);
    map['date'] = Variable<DateTime>(date);
    map['completed'] = Variable<bool>(completed);
    map['total_time'] = Variable<int>(totalTime);
    map['perceived_effort'] = Variable<int>(perceivedEffort);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WorkoutSessionLogEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionLogEntriesCompanion(
      id: Value(id),
      planId: Value(planId),
      workoutDayId: Value(workoutDayId),
      date: Value(date),
      completed: Value(completed),
      totalTime: Value(totalTime),
      perceivedEffort: Value(perceivedEffort),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WorkoutSessionLogEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionLogEntry(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      workoutDayId: serializer.fromJson<String>(json['workoutDayId']),
      date: serializer.fromJson<DateTime>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
      totalTime: serializer.fromJson<int>(json['totalTime']),
      perceivedEffort: serializer.fromJson<int>(json['perceivedEffort']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'workoutDayId': serializer.toJson<String>(workoutDayId),
      'date': serializer.toJson<DateTime>(date),
      'completed': serializer.toJson<bool>(completed),
      'totalTime': serializer.toJson<int>(totalTime),
      'perceivedEffort': serializer.toJson<int>(perceivedEffort),
      'note': serializer.toJson<String?>(note),
    };
  }

  WorkoutSessionLogEntry copyWith(
          {String? id,
          String? planId,
          String? workoutDayId,
          DateTime? date,
          bool? completed,
          int? totalTime,
          int? perceivedEffort,
          Value<String?> note = const Value.absent()}) =>
      WorkoutSessionLogEntry(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        workoutDayId: workoutDayId ?? this.workoutDayId,
        date: date ?? this.date,
        completed: completed ?? this.completed,
        totalTime: totalTime ?? this.totalTime,
        perceivedEffort: perceivedEffort ?? this.perceivedEffort,
        note: note.present ? note.value : this.note,
      );
  WorkoutSessionLogEntry copyWithCompanion(
      WorkoutSessionLogEntriesCompanion data) {
    return WorkoutSessionLogEntry(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      workoutDayId: data.workoutDayId.present
          ? data.workoutDayId.value
          : this.workoutDayId,
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
      totalTime: data.totalTime.present ? data.totalTime.value : this.totalTime,
      perceivedEffort: data.perceivedEffort.present
          ? data.perceivedEffort.value
          : this.perceivedEffort,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionLogEntry(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('totalTime: $totalTime, ')
          ..write('perceivedEffort: $perceivedEffort, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, workoutDayId, date, completed,
      totalTime, perceivedEffort, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionLogEntry &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.workoutDayId == this.workoutDayId &&
          other.date == this.date &&
          other.completed == this.completed &&
          other.totalTime == this.totalTime &&
          other.perceivedEffort == this.perceivedEffort &&
          other.note == this.note);
}

class WorkoutSessionLogEntriesCompanion
    extends UpdateCompanion<WorkoutSessionLogEntry> {
  final Value<String> id;
  final Value<String> planId;
  final Value<String> workoutDayId;
  final Value<DateTime> date;
  final Value<bool> completed;
  final Value<int> totalTime;
  final Value<int> perceivedEffort;
  final Value<String?> note;
  final Value<int> rowid;
  const WorkoutSessionLogEntriesCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.workoutDayId = const Value.absent(),
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
    this.totalTime = const Value.absent(),
    this.perceivedEffort = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionLogEntriesCompanion.insert({
    required String id,
    required String planId,
    required String workoutDayId,
    required DateTime date,
    this.completed = const Value.absent(),
    this.totalTime = const Value.absent(),
    this.perceivedEffort = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        planId = Value(planId),
        workoutDayId = Value(workoutDayId),
        date = Value(date);
  static Insertable<WorkoutSessionLogEntry> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? workoutDayId,
    Expression<DateTime>? date,
    Expression<bool>? completed,
    Expression<int>? totalTime,
    Expression<int>? perceivedEffort,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (workoutDayId != null) 'workout_day_id': workoutDayId,
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
      if (totalTime != null) 'total_time': totalTime,
      if (perceivedEffort != null) 'perceived_effort': perceivedEffort,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionLogEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? planId,
      Value<String>? workoutDayId,
      Value<DateTime>? date,
      Value<bool>? completed,
      Value<int>? totalTime,
      Value<int>? perceivedEffort,
      Value<String?>? note,
      Value<int>? rowid}) {
    return WorkoutSessionLogEntriesCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      workoutDayId: workoutDayId ?? this.workoutDayId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      totalTime: totalTime ?? this.totalTime,
      perceivedEffort: perceivedEffort ?? this.perceivedEffort,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (workoutDayId.present) {
      map['workout_day_id'] = Variable<String>(workoutDayId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (totalTime.present) {
      map['total_time'] = Variable<int>(totalTime.value);
    }
    if (perceivedEffort.present) {
      map['perceived_effort'] = Variable<int>(perceivedEffort.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionLogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('workoutDayId: $workoutDayId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('totalTime: $totalTime, ')
          ..write('perceivedEffort: $perceivedEffort, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfileEntriesTable extends UserProfileEntries
    with TableInfo<$UserProfileEntriesTable, UserProfileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Athlete'));
  static const VerificationMeta _sexVariantMeta =
      const VerificationMeta('sexVariant');
  @override
  late final GeneratedColumn<String> sexVariant = GeneratedColumn<String>(
      'sex_variant', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unisex'));
  static const VerificationMeta _primaryGoalMeta =
      const VerificationMeta('primaryGoal');
  @override
  late final GeneratedColumn<String> primaryGoal = GeneratedColumn<String>(
      'primary_goal', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('discipline'));
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('home'));
  static const VerificationMeta _wakeTimeMeta =
      const VerificationMeta('wakeTime');
  @override
  late final GeneratedColumn<String> wakeTime = GeneratedColumn<String>(
      'wake_time', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('07:00'));
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
      'onboarding_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("onboarding_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _proEnabledMeta =
      const VerificationMeta('proEnabled');
  @override
  late final GeneratedColumn<bool> proEnabled = GeneratedColumn<bool>(
      'pro_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pro_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _activePlanIdMeta =
      const VerificationMeta('activePlanId');
  @override
  late final GeneratedColumn<String> activePlanId = GeneratedColumn<String>(
      'active_plan_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        sexVariant,
        primaryGoal,
        equipment,
        wakeTime,
        onboardingCompleted,
        proEnabled,
        activePlanId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile_entries';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfileEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('sex_variant')) {
      context.handle(
          _sexVariantMeta,
          sexVariant.isAcceptableOrUnknown(
              data['sex_variant']!, _sexVariantMeta));
    }
    if (data.containsKey('primary_goal')) {
      context.handle(
          _primaryGoalMeta,
          primaryGoal.isAcceptableOrUnknown(
              data['primary_goal']!, _primaryGoalMeta));
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    }
    if (data.containsKey('wake_time')) {
      context.handle(_wakeTimeMeta,
          wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta));
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
          _onboardingCompletedMeta,
          onboardingCompleted.isAcceptableOrUnknown(
              data['onboarding_completed']!, _onboardingCompletedMeta));
    }
    if (data.containsKey('pro_enabled')) {
      context.handle(
          _proEnabledMeta,
          proEnabled.isAcceptableOrUnknown(
              data['pro_enabled']!, _proEnabledMeta));
    }
    if (data.containsKey('active_plan_id')) {
      context.handle(
          _activePlanIdMeta,
          activePlanId.isAcceptableOrUnknown(
              data['active_plan_id']!, _activePlanIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sexVariant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex_variant'])!,
      primaryGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}primary_goal'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      wakeTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}wake_time'])!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}onboarding_completed'])!,
      proEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pro_enabled'])!,
      activePlanId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}active_plan_id']),
    );
  }

  @override
  $UserProfileEntriesTable createAlias(String alias) {
    return $UserProfileEntriesTable(attachedDatabase, alias);
  }
}

class UserProfileEntry extends DataClass
    implements Insertable<UserProfileEntry> {
  final String id;
  final String name;
  final String sexVariant;
  final String primaryGoal;
  final String equipment;
  final String wakeTime;
  final bool onboardingCompleted;
  final bool proEnabled;
  final String? activePlanId;
  const UserProfileEntry(
      {required this.id,
      required this.name,
      required this.sexVariant,
      required this.primaryGoal,
      required this.equipment,
      required this.wakeTime,
      required this.onboardingCompleted,
      required this.proEnabled,
      this.activePlanId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sex_variant'] = Variable<String>(sexVariant);
    map['primary_goal'] = Variable<String>(primaryGoal);
    map['equipment'] = Variable<String>(equipment);
    map['wake_time'] = Variable<String>(wakeTime);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['pro_enabled'] = Variable<bool>(proEnabled);
    if (!nullToAbsent || activePlanId != null) {
      map['active_plan_id'] = Variable<String>(activePlanId);
    }
    return map;
  }

  UserProfileEntriesCompanion toCompanion(bool nullToAbsent) {
    return UserProfileEntriesCompanion(
      id: Value(id),
      name: Value(name),
      sexVariant: Value(sexVariant),
      primaryGoal: Value(primaryGoal),
      equipment: Value(equipment),
      wakeTime: Value(wakeTime),
      onboardingCompleted: Value(onboardingCompleted),
      proEnabled: Value(proEnabled),
      activePlanId: activePlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(activePlanId),
    );
  }

  factory UserProfileEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sexVariant: serializer.fromJson<String>(json['sexVariant']),
      primaryGoal: serializer.fromJson<String>(json['primaryGoal']),
      equipment: serializer.fromJson<String>(json['equipment']),
      wakeTime: serializer.fromJson<String>(json['wakeTime']),
      onboardingCompleted:
          serializer.fromJson<bool>(json['onboardingCompleted']),
      proEnabled: serializer.fromJson<bool>(json['proEnabled']),
      activePlanId: serializer.fromJson<String?>(json['activePlanId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sexVariant': serializer.toJson<String>(sexVariant),
      'primaryGoal': serializer.toJson<String>(primaryGoal),
      'equipment': serializer.toJson<String>(equipment),
      'wakeTime': serializer.toJson<String>(wakeTime),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'proEnabled': serializer.toJson<bool>(proEnabled),
      'activePlanId': serializer.toJson<String?>(activePlanId),
    };
  }

  UserProfileEntry copyWith(
          {String? id,
          String? name,
          String? sexVariant,
          String? primaryGoal,
          String? equipment,
          String? wakeTime,
          bool? onboardingCompleted,
          bool? proEnabled,
          Value<String?> activePlanId = const Value.absent()}) =>
      UserProfileEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        sexVariant: sexVariant ?? this.sexVariant,
        primaryGoal: primaryGoal ?? this.primaryGoal,
        equipment: equipment ?? this.equipment,
        wakeTime: wakeTime ?? this.wakeTime,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        proEnabled: proEnabled ?? this.proEnabled,
        activePlanId:
            activePlanId.present ? activePlanId.value : this.activePlanId,
      );
  UserProfileEntry copyWithCompanion(UserProfileEntriesCompanion data) {
    return UserProfileEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sexVariant:
          data.sexVariant.present ? data.sexVariant.value : this.sexVariant,
      primaryGoal:
          data.primaryGoal.present ? data.primaryGoal.value : this.primaryGoal,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      proEnabled:
          data.proEnabled.present ? data.proEnabled.value : this.proEnabled,
      activePlanId: data.activePlanId.present
          ? data.activePlanId.value
          : this.activePlanId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sexVariant: $sexVariant, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('equipment: $equipment, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('proEnabled: $proEnabled, ')
          ..write('activePlanId: $activePlanId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sexVariant, primaryGoal, equipment,
      wakeTime, onboardingCompleted, proEnabled, activePlanId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.sexVariant == this.sexVariant &&
          other.primaryGoal == this.primaryGoal &&
          other.equipment == this.equipment &&
          other.wakeTime == this.wakeTime &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.proEnabled == this.proEnabled &&
          other.activePlanId == this.activePlanId);
}

class UserProfileEntriesCompanion extends UpdateCompanion<UserProfileEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> sexVariant;
  final Value<String> primaryGoal;
  final Value<String> equipment;
  final Value<String> wakeTime;
  final Value<bool> onboardingCompleted;
  final Value<bool> proEnabled;
  final Value<String?> activePlanId;
  final Value<int> rowid;
  const UserProfileEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sexVariant = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.equipment = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.proEnabled = const Value.absent(),
    this.activePlanId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfileEntriesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.sexVariant = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.equipment = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.proEnabled = const Value.absent(),
    this.activePlanId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UserProfileEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sexVariant,
    Expression<String>? primaryGoal,
    Expression<String>? equipment,
    Expression<String>? wakeTime,
    Expression<bool>? onboardingCompleted,
    Expression<bool>? proEnabled,
    Expression<String>? activePlanId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sexVariant != null) 'sex_variant': sexVariant,
      if (primaryGoal != null) 'primary_goal': primaryGoal,
      if (equipment != null) 'equipment': equipment,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (proEnabled != null) 'pro_enabled': proEnabled,
      if (activePlanId != null) 'active_plan_id': activePlanId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfileEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? sexVariant,
      Value<String>? primaryGoal,
      Value<String>? equipment,
      Value<String>? wakeTime,
      Value<bool>? onboardingCompleted,
      Value<bool>? proEnabled,
      Value<String?>? activePlanId,
      Value<int>? rowid}) {
    return UserProfileEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sexVariant: sexVariant ?? this.sexVariant,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      equipment: equipment ?? this.equipment,
      wakeTime: wakeTime ?? this.wakeTime,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      proEnabled: proEnabled ?? this.proEnabled,
      activePlanId: activePlanId ?? this.activePlanId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sexVariant.present) {
      map['sex_variant'] = Variable<String>(sexVariant.value);
    }
    if (primaryGoal.present) {
      map['primary_goal'] = Variable<String>(primaryGoal.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<String>(wakeTime.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (proEnabled.present) {
      map['pro_enabled'] = Variable<bool>(proEnabled.value);
    }
    if (activePlanId.present) {
      map['active_plan_id'] = Variable<String>(activePlanId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sexVariant: $sexVariant, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('equipment: $equipment, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('proEnabled: $proEnabled, ')
          ..write('activePlanId: $activePlanId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitEntriesTable habitEntries = $HabitEntriesTable(this);
  late final $HabitLogEntriesTable habitLogEntries =
      $HabitLogEntriesTable(this);
  late final $WorkoutPlanEntriesTable workoutPlanEntries =
      $WorkoutPlanEntriesTable(this);
  late final $WorkoutDayEntriesTable workoutDayEntries =
      $WorkoutDayEntriesTable(this);
  late final $ExerciseEntriesTable exerciseEntries =
      $ExerciseEntriesTable(this);
  late final $WorkoutSetEntriesTable workoutSetEntries =
      $WorkoutSetEntriesTable(this);
  late final $WorkoutSessionLogEntriesTable workoutSessionLogEntries =
      $WorkoutSessionLogEntriesTable(this);
  late final $UserProfileEntriesTable userProfileEntries =
      $UserProfileEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        habitEntries,
        habitLogEntries,
        workoutPlanEntries,
        workoutDayEntries,
        exerciseEntries,
        workoutSetEntries,
        workoutSessionLogEntries,
        userProfileEntries
      ];
}

typedef $$HabitEntriesTableCreateCompanionBuilder = HabitEntriesCompanion
    Function({
  required String id,
  required String title,
  required String type,
  Value<double> targetValue,
  Value<String> unit,
  required String scheduleDays,
  required String reminders,
  required DateTime createdAt,
  Value<String?> category,
  Value<int> rowid,
});
typedef $$HabitEntriesTableUpdateCompanionBuilder = HabitEntriesCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> type,
  Value<double> targetValue,
  Value<String> unit,
  Value<String> scheduleDays,
  Value<String> reminders,
  Value<DateTime> createdAt,
  Value<String?> category,
  Value<int> rowid,
});

final class $$HabitEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $HabitEntriesTable, HabitEntry> {
  $$HabitEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitLogEntriesTable, List<HabitLogEntry>>
      _habitLogEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.habitLogEntries,
              aliasName: $_aliasNameGenerator(
                  db.habitEntries.id, db.habitLogEntries.habitId));

  $$HabitLogEntriesTableProcessedTableManager get habitLogEntriesRefs {
    final manager =
        $$HabitLogEntriesTableTableManager($_db, $_db.habitLogEntries)
            .filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_habitLogEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HabitEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleDays => $composableBuilder(
      column: $table.scheduleDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminders => $composableBuilder(
      column: $table.reminders, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  Expression<bool> habitLogEntriesRefs(
      Expression<bool> Function($$HabitLogEntriesTableFilterComposer f) f) {
    final $$HabitLogEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitLogEntries,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitLogEntriesTableFilterComposer(
              $db: $db,
              $table: $db.habitLogEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleDays => $composableBuilder(
      column: $table.scheduleDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminders => $composableBuilder(
      column: $table.reminders, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$HabitEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get scheduleDays => $composableBuilder(
      column: $table.scheduleDays, builder: (column) => column);

  GeneratedColumn<String> get reminders =>
      $composableBuilder(column: $table.reminders, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  Expression<T> habitLogEntriesRefs<T extends Object>(
      Expression<T> Function($$HabitLogEntriesTableAnnotationComposer a) f) {
    final $$HabitLogEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitLogEntries,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitLogEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.habitLogEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitEntriesTable,
    HabitEntry,
    $$HabitEntriesTableFilterComposer,
    $$HabitEntriesTableOrderingComposer,
    $$HabitEntriesTableAnnotationComposer,
    $$HabitEntriesTableCreateCompanionBuilder,
    $$HabitEntriesTableUpdateCompanionBuilder,
    (HabitEntry, $$HabitEntriesTableReferences),
    HabitEntry,
    PrefetchHooks Function({bool habitLogEntriesRefs})> {
  $$HabitEntriesTableTableManager(_$AppDatabase db, $HabitEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> targetValue = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String> scheduleDays = const Value.absent(),
            Value<String> reminders = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitEntriesCompanion(
            id: id,
            title: title,
            type: type,
            targetValue: targetValue,
            unit: unit,
            scheduleDays: scheduleDays,
            reminders: reminders,
            createdAt: createdAt,
            category: category,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String type,
            Value<double> targetValue = const Value.absent(),
            Value<String> unit = const Value.absent(),
            required String scheduleDays,
            required String reminders,
            required DateTime createdAt,
            Value<String?> category = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitEntriesCompanion.insert(
            id: id,
            title: title,
            type: type,
            targetValue: targetValue,
            unit: unit,
            scheduleDays: scheduleDays,
            reminders: reminders,
            createdAt: createdAt,
            category: category,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HabitEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({habitLogEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitLogEntriesRefs) db.habitLogEntries
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitLogEntriesRefs)
                    await $_getPrefetchedData<HabitEntry, $HabitEntriesTable,
                            HabitLogEntry>(
                        currentTable: table,
                        referencedTable: $$HabitEntriesTableReferences
                            ._habitLogEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HabitEntriesTableReferences(db, table, p0)
                                .habitLogEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.habitId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HabitEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitEntriesTable,
    HabitEntry,
    $$HabitEntriesTableFilterComposer,
    $$HabitEntriesTableOrderingComposer,
    $$HabitEntriesTableAnnotationComposer,
    $$HabitEntriesTableCreateCompanionBuilder,
    $$HabitEntriesTableUpdateCompanionBuilder,
    (HabitEntry, $$HabitEntriesTableReferences),
    HabitEntry,
    PrefetchHooks Function({bool habitLogEntriesRefs})>;
typedef $$HabitLogEntriesTableCreateCompanionBuilder = HabitLogEntriesCompanion
    Function({
  required String id,
  required String habitId,
  required DateTime date,
  Value<double> value,
  Value<bool> completed,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$HabitLogEntriesTableUpdateCompanionBuilder = HabitLogEntriesCompanion
    Function({
  Value<String> id,
  Value<String> habitId,
  Value<DateTime> date,
  Value<double> value,
  Value<bool> completed,
  Value<String?> note,
  Value<int> rowid,
});

final class $$HabitLogEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $HabitLogEntriesTable, HabitLogEntry> {
  $$HabitLogEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HabitEntriesTable _habitIdTable(_$AppDatabase db) =>
      db.habitEntries.createAlias(
          $_aliasNameGenerator(db.habitLogEntries.habitId, db.habitEntries.id));

  $$HabitEntriesTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitEntriesTableTableManager($_db, $_db.habitEntries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HabitLogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitLogEntriesTable> {
  $$HabitLogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$HabitEntriesTableFilterComposer get habitId {
    final $$HabitEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habitEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitEntriesTableFilterComposer(
              $db: $db,
              $table: $db.habitEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitLogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitLogEntriesTable> {
  $$HabitLogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$HabitEntriesTableOrderingComposer get habitId {
    final $$HabitEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habitEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.habitEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitLogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitLogEntriesTable> {
  $$HabitLogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$HabitEntriesTableAnnotationComposer get habitId {
    final $$HabitEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habitEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.habitEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitLogEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitLogEntriesTable,
    HabitLogEntry,
    $$HabitLogEntriesTableFilterComposer,
    $$HabitLogEntriesTableOrderingComposer,
    $$HabitLogEntriesTableAnnotationComposer,
    $$HabitLogEntriesTableCreateCompanionBuilder,
    $$HabitLogEntriesTableUpdateCompanionBuilder,
    (HabitLogEntry, $$HabitLogEntriesTableReferences),
    HabitLogEntry,
    PrefetchHooks Function({bool habitId})> {
  $$HabitLogEntriesTableTableManager(
      _$AppDatabase db, $HabitLogEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitLogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitLogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitLogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> habitId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitLogEntriesCompanion(
            id: id,
            habitId: habitId,
            date: date,
            value: value,
            completed: completed,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String habitId,
            required DateTime date,
            Value<double> value = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitLogEntriesCompanion.insert(
            id: id,
            habitId: habitId,
            date: date,
            value: value,
            completed: completed,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HabitLogEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (habitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.habitId,
                    referencedTable:
                        $$HabitLogEntriesTableReferences._habitIdTable(db),
                    referencedColumn:
                        $$HabitLogEntriesTableReferences._habitIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HabitLogEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitLogEntriesTable,
    HabitLogEntry,
    $$HabitLogEntriesTableFilterComposer,
    $$HabitLogEntriesTableOrderingComposer,
    $$HabitLogEntriesTableAnnotationComposer,
    $$HabitLogEntriesTableCreateCompanionBuilder,
    $$HabitLogEntriesTableUpdateCompanionBuilder,
    (HabitLogEntry, $$HabitLogEntriesTableReferences),
    HabitLogEntry,
    PrefetchHooks Function({bool habitId})>;
typedef $$WorkoutPlanEntriesTableCreateCompanionBuilder
    = WorkoutPlanEntriesCompanion Function({
  required String id,
  required String name,
  required String goal,
  required String level,
  required String sexVariant,
  required int daysPerWeek,
  required int durationWeeks,
  required String equipment,
  required String description,
  required String tags,
  Value<int> rowid,
});
typedef $$WorkoutPlanEntriesTableUpdateCompanionBuilder
    = WorkoutPlanEntriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> goal,
  Value<String> level,
  Value<String> sexVariant,
  Value<int> daysPerWeek,
  Value<int> durationWeeks,
  Value<String> equipment,
  Value<String> description,
  Value<String> tags,
  Value<int> rowid,
});

final class $$WorkoutPlanEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutPlanEntriesTable, WorkoutPlanEntry> {
  $$WorkoutPlanEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutDayEntriesTable, List<WorkoutDayEntry>>
      _workoutDayEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutDayEntries,
              aliasName: $_aliasNameGenerator(
                  db.workoutPlanEntries.id, db.workoutDayEntries.planId));

  $$WorkoutDayEntriesTableProcessedTableManager get workoutDayEntriesRefs {
    final manager =
        $$WorkoutDayEntriesTableTableManager($_db, $_db.workoutDayEntries)
            .filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutDayEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutSessionLogEntriesTable,
      List<WorkoutSessionLogEntry>> _workoutSessionLogEntriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.workoutSessionLogEntries,
          aliasName: $_aliasNameGenerator(
              db.workoutPlanEntries.id, db.workoutSessionLogEntries.planId));

  $$WorkoutSessionLogEntriesTableProcessedTableManager
      get workoutSessionLogEntriesRefs {
    final manager = $$WorkoutSessionLogEntriesTableTableManager(
            $_db, $_db.workoutSessionLogEntries)
        .filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutSessionLogEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutPlanEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlanEntriesTable> {
  $$WorkoutPlanEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goal => $composableBuilder(
      column: $table.goal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sexVariant => $composableBuilder(
      column: $table.sexVariant, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get daysPerWeek => $composableBuilder(
      column: $table.daysPerWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationWeeks => $composableBuilder(
      column: $table.durationWeeks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  Expression<bool> workoutDayEntriesRefs(
      Expression<bool> Function($$WorkoutDayEntriesTableFilterComposer f) f) {
    final $$WorkoutDayEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutDayEntries,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutDayEntriesTableFilterComposer(
              $db: $db,
              $table: $db.workoutDayEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workoutSessionLogEntriesRefs(
      Expression<bool> Function($$WorkoutSessionLogEntriesTableFilterComposer f)
          f) {
    final $$WorkoutSessionLogEntriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutSessionLogEntries,
            getReferencedColumn: (t) => t.planId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutSessionLogEntriesTableFilterComposer(
                  $db: $db,
                  $table: $db.workoutSessionLogEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutPlanEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlanEntriesTable> {
  $$WorkoutPlanEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goal => $composableBuilder(
      column: $table.goal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sexVariant => $composableBuilder(
      column: $table.sexVariant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get daysPerWeek => $composableBuilder(
      column: $table.daysPerWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationWeeks => $composableBuilder(
      column: $table.durationWeeks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutPlanEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlanEntriesTable> {
  $$WorkoutPlanEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get sexVariant => $composableBuilder(
      column: $table.sexVariant, builder: (column) => column);

  GeneratedColumn<int> get daysPerWeek => $composableBuilder(
      column: $table.daysPerWeek, builder: (column) => column);

  GeneratedColumn<int> get durationWeeks => $composableBuilder(
      column: $table.durationWeeks, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  Expression<T> workoutDayEntriesRefs<T extends Object>(
      Expression<T> Function($$WorkoutDayEntriesTableAnnotationComposer a) f) {
    final $$WorkoutDayEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutDayEntries,
            getReferencedColumn: (t) => t.planId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutDayEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutDayEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> workoutSessionLogEntriesRefs<T extends Object>(
      Expression<T> Function(
              $$WorkoutSessionLogEntriesTableAnnotationComposer a)
          f) {
    final $$WorkoutSessionLogEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutSessionLogEntries,
            getReferencedColumn: (t) => t.planId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutSessionLogEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutSessionLogEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutPlanEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutPlanEntriesTable,
    WorkoutPlanEntry,
    $$WorkoutPlanEntriesTableFilterComposer,
    $$WorkoutPlanEntriesTableOrderingComposer,
    $$WorkoutPlanEntriesTableAnnotationComposer,
    $$WorkoutPlanEntriesTableCreateCompanionBuilder,
    $$WorkoutPlanEntriesTableUpdateCompanionBuilder,
    (WorkoutPlanEntry, $$WorkoutPlanEntriesTableReferences),
    WorkoutPlanEntry,
    PrefetchHooks Function(
        {bool workoutDayEntriesRefs, bool workoutSessionLogEntriesRefs})> {
  $$WorkoutPlanEntriesTableTableManager(
      _$AppDatabase db, $WorkoutPlanEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPlanEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPlanEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlanEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> goal = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> sexVariant = const Value.absent(),
            Value<int> daysPerWeek = const Value.absent(),
            Value<int> durationWeeks = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutPlanEntriesCompanion(
            id: id,
            name: name,
            goal: goal,
            level: level,
            sexVariant: sexVariant,
            daysPerWeek: daysPerWeek,
            durationWeeks: durationWeeks,
            equipment: equipment,
            description: description,
            tags: tags,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String goal,
            required String level,
            required String sexVariant,
            required int daysPerWeek,
            required int durationWeeks,
            required String equipment,
            required String description,
            required String tags,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutPlanEntriesCompanion.insert(
            id: id,
            name: name,
            goal: goal,
            level: level,
            sexVariant: sexVariant,
            daysPerWeek: daysPerWeek,
            durationWeeks: durationWeeks,
            equipment: equipment,
            description: description,
            tags: tags,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutPlanEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {workoutDayEntriesRefs = false,
              workoutSessionLogEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutDayEntriesRefs) db.workoutDayEntries,
                if (workoutSessionLogEntriesRefs) db.workoutSessionLogEntries
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutDayEntriesRefs)
                    await $_getPrefetchedData<WorkoutPlanEntry,
                            $WorkoutPlanEntriesTable, WorkoutDayEntry>(
                        currentTable: table,
                        referencedTable: $$WorkoutPlanEntriesTableReferences
                            ._workoutDayEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutPlanEntriesTableReferences(db, table, p0)
                                .workoutDayEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.planId == item.id),
                        typedResults: items),
                  if (workoutSessionLogEntriesRefs)
                    await $_getPrefetchedData<WorkoutPlanEntry,
                            $WorkoutPlanEntriesTable, WorkoutSessionLogEntry>(
                        currentTable: table,
                        referencedTable: $$WorkoutPlanEntriesTableReferences
                            ._workoutSessionLogEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutPlanEntriesTableReferences(db, table, p0)
                                .workoutSessionLogEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.planId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutPlanEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutPlanEntriesTable,
    WorkoutPlanEntry,
    $$WorkoutPlanEntriesTableFilterComposer,
    $$WorkoutPlanEntriesTableOrderingComposer,
    $$WorkoutPlanEntriesTableAnnotationComposer,
    $$WorkoutPlanEntriesTableCreateCompanionBuilder,
    $$WorkoutPlanEntriesTableUpdateCompanionBuilder,
    (WorkoutPlanEntry, $$WorkoutPlanEntriesTableReferences),
    WorkoutPlanEntry,
    PrefetchHooks Function(
        {bool workoutDayEntriesRefs, bool workoutSessionLogEntriesRefs})>;
typedef $$WorkoutDayEntriesTableCreateCompanionBuilder
    = WorkoutDayEntriesCompanion Function({
  required String id,
  required String planId,
  required int dayIndex,
  required String title,
  Value<int> rowid,
});
typedef $$WorkoutDayEntriesTableUpdateCompanionBuilder
    = WorkoutDayEntriesCompanion Function({
  Value<String> id,
  Value<String> planId,
  Value<int> dayIndex,
  Value<String> title,
  Value<int> rowid,
});

final class $$WorkoutDayEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutDayEntriesTable, WorkoutDayEntry> {
  $$WorkoutDayEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutPlanEntriesTable _planIdTable(_$AppDatabase db) =>
      db.workoutPlanEntries.createAlias($_aliasNameGenerator(
          db.workoutDayEntries.planId, db.workoutPlanEntries.id));

  $$WorkoutPlanEntriesTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager =
        $$WorkoutPlanEntriesTableTableManager($_db, $_db.workoutPlanEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WorkoutSetEntriesTable, List<WorkoutSetEntry>>
      _workoutSetEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutSetEntries,
              aliasName: $_aliasNameGenerator(
                  db.workoutDayEntries.id, db.workoutSetEntries.workoutDayId));

  $$WorkoutSetEntriesTableProcessedTableManager get workoutSetEntriesRefs {
    final manager = $$WorkoutSetEntriesTableTableManager(
            $_db, $_db.workoutSetEntries)
        .filter(
            (f) => f.workoutDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutSetEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutSessionLogEntriesTable,
      List<WorkoutSessionLogEntry>> _workoutSessionLogEntriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.workoutSessionLogEntries,
          aliasName: $_aliasNameGenerator(db.workoutDayEntries.id,
              db.workoutSessionLogEntries.workoutDayId));

  $$WorkoutSessionLogEntriesTableProcessedTableManager
      get workoutSessionLogEntriesRefs {
    final manager = $$WorkoutSessionLogEntriesTableTableManager(
            $_db, $_db.workoutSessionLogEntries)
        .filter(
            (f) => f.workoutDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutSessionLogEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutDayEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutDayEntriesTable> {
  $$WorkoutDayEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayIndex => $composableBuilder(
      column: $table.dayIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  $$WorkoutPlanEntriesTableFilterComposer get planId {
    final $$WorkoutPlanEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.workoutPlanEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutPlanEntriesTableFilterComposer(
              $db: $db,
              $table: $db.workoutPlanEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> workoutSetEntriesRefs(
      Expression<bool> Function($$WorkoutSetEntriesTableFilterComposer f) f) {
    final $$WorkoutSetEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSetEntries,
        getReferencedColumn: (t) => t.workoutDayId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSetEntriesTableFilterComposer(
              $db: $db,
              $table: $db.workoutSetEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workoutSessionLogEntriesRefs(
      Expression<bool> Function($$WorkoutSessionLogEntriesTableFilterComposer f)
          f) {
    final $$WorkoutSessionLogEntriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutSessionLogEntries,
            getReferencedColumn: (t) => t.workoutDayId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutSessionLogEntriesTableFilterComposer(
                  $db: $db,
                  $table: $db.workoutSessionLogEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutDayEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutDayEntriesTable> {
  $$WorkoutDayEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayIndex => $composableBuilder(
      column: $table.dayIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  $$WorkoutPlanEntriesTableOrderingComposer get planId {
    final $$WorkoutPlanEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.workoutPlanEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutPlanEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutPlanEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutDayEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutDayEntriesTable> {
  $$WorkoutDayEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  $$WorkoutPlanEntriesTableAnnotationComposer get planId {
    final $$WorkoutPlanEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.planId,
            referencedTable: $db.workoutPlanEntries,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutPlanEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutPlanEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> workoutSetEntriesRefs<T extends Object>(
      Expression<T> Function($$WorkoutSetEntriesTableAnnotationComposer a) f) {
    final $$WorkoutSetEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutSetEntries,
            getReferencedColumn: (t) => t.workoutDayId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutSetEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutSetEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> workoutSessionLogEntriesRefs<T extends Object>(
      Expression<T> Function(
              $$WorkoutSessionLogEntriesTableAnnotationComposer a)
          f) {
    final $$WorkoutSessionLogEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutSessionLogEntries,
            getReferencedColumn: (t) => t.workoutDayId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutSessionLogEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutSessionLogEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutDayEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutDayEntriesTable,
    WorkoutDayEntry,
    $$WorkoutDayEntriesTableFilterComposer,
    $$WorkoutDayEntriesTableOrderingComposer,
    $$WorkoutDayEntriesTableAnnotationComposer,
    $$WorkoutDayEntriesTableCreateCompanionBuilder,
    $$WorkoutDayEntriesTableUpdateCompanionBuilder,
    (WorkoutDayEntry, $$WorkoutDayEntriesTableReferences),
    WorkoutDayEntry,
    PrefetchHooks Function(
        {bool planId,
        bool workoutSetEntriesRefs,
        bool workoutSessionLogEntriesRefs})> {
  $$WorkoutDayEntriesTableTableManager(
      _$AppDatabase db, $WorkoutDayEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutDayEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutDayEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutDayEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> planId = const Value.absent(),
            Value<int> dayIndex = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutDayEntriesCompanion(
            id: id,
            planId: planId,
            dayIndex: dayIndex,
            title: title,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String planId,
            required int dayIndex,
            required String title,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutDayEntriesCompanion.insert(
            id: id,
            planId: planId,
            dayIndex: dayIndex,
            title: title,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutDayEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {planId = false,
              workoutSetEntriesRefs = false,
              workoutSessionLogEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutSetEntriesRefs) db.workoutSetEntries,
                if (workoutSessionLogEntriesRefs) db.workoutSessionLogEntries
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (planId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.planId,
                    referencedTable:
                        $$WorkoutDayEntriesTableReferences._planIdTable(db),
                    referencedColumn:
                        $$WorkoutDayEntriesTableReferences._planIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetEntriesRefs)
                    await $_getPrefetchedData<WorkoutDayEntry,
                            $WorkoutDayEntriesTable, WorkoutSetEntry>(
                        currentTable: table,
                        referencedTable: $$WorkoutDayEntriesTableReferences
                            ._workoutSetEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutDayEntriesTableReferences(db, table, p0)
                                .workoutSetEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.workoutDayId == item.id),
                        typedResults: items),
                  if (workoutSessionLogEntriesRefs)
                    await $_getPrefetchedData<WorkoutDayEntry,
                            $WorkoutDayEntriesTable, WorkoutSessionLogEntry>(
                        currentTable: table,
                        referencedTable: $$WorkoutDayEntriesTableReferences
                            ._workoutSessionLogEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutDayEntriesTableReferences(db, table, p0)
                                .workoutSessionLogEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.workoutDayId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutDayEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutDayEntriesTable,
    WorkoutDayEntry,
    $$WorkoutDayEntriesTableFilterComposer,
    $$WorkoutDayEntriesTableOrderingComposer,
    $$WorkoutDayEntriesTableAnnotationComposer,
    $$WorkoutDayEntriesTableCreateCompanionBuilder,
    $$WorkoutDayEntriesTableUpdateCompanionBuilder,
    (WorkoutDayEntry, $$WorkoutDayEntriesTableReferences),
    WorkoutDayEntry,
    PrefetchHooks Function(
        {bool planId,
        bool workoutSetEntriesRefs,
        bool workoutSessionLogEntriesRefs})>;
typedef $$ExerciseEntriesTableCreateCompanionBuilder = ExerciseEntriesCompanion
    Function({
  required String id,
  required String name,
  required String primaryMuscles,
  required String equipment,
  required String instructions,
  Value<String?> videoUrl,
  Value<int> rowid,
});
typedef $$ExerciseEntriesTableUpdateCompanionBuilder = ExerciseEntriesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> primaryMuscles,
  Value<String> equipment,
  Value<String> instructions,
  Value<String?> videoUrl,
  Value<int> rowid,
});

final class $$ExerciseEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $ExerciseEntriesTable, ExerciseEntry> {
  $$ExerciseEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutSetEntriesTable, List<WorkoutSetEntry>>
      _workoutSetEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutSetEntries,
              aliasName: $_aliasNameGenerator(
                  db.exerciseEntries.id, db.workoutSetEntries.exerciseId));

  $$WorkoutSetEntriesTableProcessedTableManager get workoutSetEntriesRefs {
    final manager = $$WorkoutSetEntriesTableTableManager(
            $_db, $_db.workoutSetEntries)
        .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutSetEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExerciseEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseEntriesTable> {
  $$ExerciseEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryMuscles => $composableBuilder(
      column: $table.primaryMuscles,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoUrl => $composableBuilder(
      column: $table.videoUrl, builder: (column) => ColumnFilters(column));

  Expression<bool> workoutSetEntriesRefs(
      Expression<bool> Function($$WorkoutSetEntriesTableFilterComposer f) f) {
    final $$WorkoutSetEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSetEntries,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSetEntriesTableFilterComposer(
              $db: $db,
              $table: $db.workoutSetEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExerciseEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseEntriesTable> {
  $$ExerciseEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryMuscles => $composableBuilder(
      column: $table.primaryMuscles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoUrl => $composableBuilder(
      column: $table.videoUrl, builder: (column) => ColumnOrderings(column));
}

class $$ExerciseEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseEntriesTable> {
  $$ExerciseEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get primaryMuscles => $composableBuilder(
      column: $table.primaryMuscles, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  Expression<T> workoutSetEntriesRefs<T extends Object>(
      Expression<T> Function($$WorkoutSetEntriesTableAnnotationComposer a) f) {
    final $$WorkoutSetEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutSetEntries,
            getReferencedColumn: (t) => t.exerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutSetEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutSetEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExerciseEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseEntriesTable,
    ExerciseEntry,
    $$ExerciseEntriesTableFilterComposer,
    $$ExerciseEntriesTableOrderingComposer,
    $$ExerciseEntriesTableAnnotationComposer,
    $$ExerciseEntriesTableCreateCompanionBuilder,
    $$ExerciseEntriesTableUpdateCompanionBuilder,
    (ExerciseEntry, $$ExerciseEntriesTableReferences),
    ExerciseEntry,
    PrefetchHooks Function({bool workoutSetEntriesRefs})> {
  $$ExerciseEntriesTableTableManager(
      _$AppDatabase db, $ExerciseEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> primaryMuscles = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> instructions = const Value.absent(),
            Value<String?> videoUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseEntriesCompanion(
            id: id,
            name: name,
            primaryMuscles: primaryMuscles,
            equipment: equipment,
            instructions: instructions,
            videoUrl: videoUrl,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String primaryMuscles,
            required String equipment,
            required String instructions,
            Value<String?> videoUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseEntriesCompanion.insert(
            id: id,
            name: name,
            primaryMuscles: primaryMuscles,
            equipment: equipment,
            instructions: instructions,
            videoUrl: videoUrl,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExerciseEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({workoutSetEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutSetEntriesRefs) db.workoutSetEntries
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetEntriesRefs)
                    await $_getPrefetchedData<ExerciseEntry,
                            $ExerciseEntriesTable, WorkoutSetEntry>(
                        currentTable: table,
                        referencedTable: $$ExerciseEntriesTableReferences
                            ._workoutSetEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExerciseEntriesTableReferences(db, table, p0)
                                .workoutSetEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExerciseEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExerciseEntriesTable,
    ExerciseEntry,
    $$ExerciseEntriesTableFilterComposer,
    $$ExerciseEntriesTableOrderingComposer,
    $$ExerciseEntriesTableAnnotationComposer,
    $$ExerciseEntriesTableCreateCompanionBuilder,
    $$ExerciseEntriesTableUpdateCompanionBuilder,
    (ExerciseEntry, $$ExerciseEntriesTableReferences),
    ExerciseEntry,
    PrefetchHooks Function({bool workoutSetEntriesRefs})>;
typedef $$WorkoutSetEntriesTableCreateCompanionBuilder
    = WorkoutSetEntriesCompanion Function({
  required String id,
  required String workoutDayId,
  required String exerciseId,
  required int sets,
  required String reps,
  required int restSeconds,
  Value<String?> tempo,
  required String weightType,
  Value<String?> progressionRule,
  Value<int> rowid,
});
typedef $$WorkoutSetEntriesTableUpdateCompanionBuilder
    = WorkoutSetEntriesCompanion Function({
  Value<String> id,
  Value<String> workoutDayId,
  Value<String> exerciseId,
  Value<int> sets,
  Value<String> reps,
  Value<int> restSeconds,
  Value<String?> tempo,
  Value<String> weightType,
  Value<String?> progressionRule,
  Value<int> rowid,
});

final class $$WorkoutSetEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutSetEntriesTable, WorkoutSetEntry> {
  $$WorkoutSetEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutDayEntriesTable _workoutDayIdTable(_$AppDatabase db) =>
      db.workoutDayEntries.createAlias($_aliasNameGenerator(
          db.workoutSetEntries.workoutDayId, db.workoutDayEntries.id));

  $$WorkoutDayEntriesTableProcessedTableManager get workoutDayId {
    final $_column = $_itemColumn<String>('workout_day_id')!;

    final manager =
        $$WorkoutDayEntriesTableTableManager($_db, $_db.workoutDayEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExerciseEntriesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exerciseEntries.createAlias($_aliasNameGenerator(
          db.workoutSetEntries.exerciseId, db.exerciseEntries.id));

  $$ExerciseEntriesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager =
        $$ExerciseEntriesTableTableManager($_db, $_db.exerciseEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutSetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetEntriesTable> {
  $$WorkoutSetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tempo => $composableBuilder(
      column: $table.tempo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weightType => $composableBuilder(
      column: $table.weightType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get progressionRule => $composableBuilder(
      column: $table.progressionRule,
      builder: (column) => ColumnFilters(column));

  $$WorkoutDayEntriesTableFilterComposer get workoutDayId {
    final $$WorkoutDayEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutDayId,
        referencedTable: $db.workoutDayEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutDayEntriesTableFilterComposer(
              $db: $db,
              $table: $db.workoutDayEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExerciseEntriesTableFilterComposer get exerciseId {
    final $$ExerciseEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exerciseEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseEntriesTableFilterComposer(
              $db: $db,
              $table: $db.exerciseEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetEntriesTable> {
  $$WorkoutSetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tempo => $composableBuilder(
      column: $table.tempo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weightType => $composableBuilder(
      column: $table.weightType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get progressionRule => $composableBuilder(
      column: $table.progressionRule,
      builder: (column) => ColumnOrderings(column));

  $$WorkoutDayEntriesTableOrderingComposer get workoutDayId {
    final $$WorkoutDayEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutDayId,
        referencedTable: $db.workoutDayEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutDayEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutDayEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExerciseEntriesTableOrderingComposer get exerciseId {
    final $$ExerciseEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exerciseEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.exerciseEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetEntriesTable> {
  $$WorkoutSetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<String> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
      column: $table.restSeconds, builder: (column) => column);

  GeneratedColumn<String> get tempo =>
      $composableBuilder(column: $table.tempo, builder: (column) => column);

  GeneratedColumn<String> get weightType => $composableBuilder(
      column: $table.weightType, builder: (column) => column);

  GeneratedColumn<String> get progressionRule => $composableBuilder(
      column: $table.progressionRule, builder: (column) => column);

  $$WorkoutDayEntriesTableAnnotationComposer get workoutDayId {
    final $$WorkoutDayEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.workoutDayId,
            referencedTable: $db.workoutDayEntries,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutDayEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutDayEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$ExerciseEntriesTableAnnotationComposer get exerciseId {
    final $$ExerciseEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exerciseEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.exerciseEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSetEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSetEntriesTable,
    WorkoutSetEntry,
    $$WorkoutSetEntriesTableFilterComposer,
    $$WorkoutSetEntriesTableOrderingComposer,
    $$WorkoutSetEntriesTableAnnotationComposer,
    $$WorkoutSetEntriesTableCreateCompanionBuilder,
    $$WorkoutSetEntriesTableUpdateCompanionBuilder,
    (WorkoutSetEntry, $$WorkoutSetEntriesTableReferences),
    WorkoutSetEntry,
    PrefetchHooks Function({bool workoutDayId, bool exerciseId})> {
  $$WorkoutSetEntriesTableTableManager(
      _$AppDatabase db, $WorkoutSetEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workoutDayId = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<int> sets = const Value.absent(),
            Value<String> reps = const Value.absent(),
            Value<int> restSeconds = const Value.absent(),
            Value<String?> tempo = const Value.absent(),
            Value<String> weightType = const Value.absent(),
            Value<String?> progressionRule = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSetEntriesCompanion(
            id: id,
            workoutDayId: workoutDayId,
            exerciseId: exerciseId,
            sets: sets,
            reps: reps,
            restSeconds: restSeconds,
            tempo: tempo,
            weightType: weightType,
            progressionRule: progressionRule,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String workoutDayId,
            required String exerciseId,
            required int sets,
            required String reps,
            required int restSeconds,
            Value<String?> tempo = const Value.absent(),
            required String weightType,
            Value<String?> progressionRule = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSetEntriesCompanion.insert(
            id: id,
            workoutDayId: workoutDayId,
            exerciseId: exerciseId,
            sets: sets,
            reps: reps,
            restSeconds: restSeconds,
            tempo: tempo,
            weightType: weightType,
            progressionRule: progressionRule,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutSetEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({workoutDayId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (workoutDayId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.workoutDayId,
                    referencedTable: $$WorkoutSetEntriesTableReferences
                        ._workoutDayIdTable(db),
                    referencedColumn: $$WorkoutSetEntriesTableReferences
                        ._workoutDayIdTable(db)
                        .id,
                  ) as T;
                }
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable:
                        $$WorkoutSetEntriesTableReferences._exerciseIdTable(db),
                    referencedColumn: $$WorkoutSetEntriesTableReferences
                        ._exerciseIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorkoutSetEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSetEntriesTable,
    WorkoutSetEntry,
    $$WorkoutSetEntriesTableFilterComposer,
    $$WorkoutSetEntriesTableOrderingComposer,
    $$WorkoutSetEntriesTableAnnotationComposer,
    $$WorkoutSetEntriesTableCreateCompanionBuilder,
    $$WorkoutSetEntriesTableUpdateCompanionBuilder,
    (WorkoutSetEntry, $$WorkoutSetEntriesTableReferences),
    WorkoutSetEntry,
    PrefetchHooks Function({bool workoutDayId, bool exerciseId})>;
typedef $$WorkoutSessionLogEntriesTableCreateCompanionBuilder
    = WorkoutSessionLogEntriesCompanion Function({
  required String id,
  required String planId,
  required String workoutDayId,
  required DateTime date,
  Value<bool> completed,
  Value<int> totalTime,
  Value<int> perceivedEffort,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$WorkoutSessionLogEntriesTableUpdateCompanionBuilder
    = WorkoutSessionLogEntriesCompanion Function({
  Value<String> id,
  Value<String> planId,
  Value<String> workoutDayId,
  Value<DateTime> date,
  Value<bool> completed,
  Value<int> totalTime,
  Value<int> perceivedEffort,
  Value<String?> note,
  Value<int> rowid,
});

final class $$WorkoutSessionLogEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutSessionLogEntriesTable, WorkoutSessionLogEntry> {
  $$WorkoutSessionLogEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutPlanEntriesTable _planIdTable(_$AppDatabase db) =>
      db.workoutPlanEntries.createAlias($_aliasNameGenerator(
          db.workoutSessionLogEntries.planId, db.workoutPlanEntries.id));

  $$WorkoutPlanEntriesTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager =
        $$WorkoutPlanEntriesTableTableManager($_db, $_db.workoutPlanEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WorkoutDayEntriesTable _workoutDayIdTable(_$AppDatabase db) =>
      db.workoutDayEntries.createAlias($_aliasNameGenerator(
          db.workoutSessionLogEntries.workoutDayId, db.workoutDayEntries.id));

  $$WorkoutDayEntriesTableProcessedTableManager get workoutDayId {
    final $_column = $_itemColumn<String>('workout_day_id')!;

    final manager =
        $$WorkoutDayEntriesTableTableManager($_db, $_db.workoutDayEntries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutSessionLogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionLogEntriesTable> {
  $$WorkoutSessionLogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTime => $composableBuilder(
      column: $table.totalTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get perceivedEffort => $composableBuilder(
      column: $table.perceivedEffort,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$WorkoutPlanEntriesTableFilterComposer get planId {
    final $$WorkoutPlanEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.workoutPlanEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutPlanEntriesTableFilterComposer(
              $db: $db,
              $table: $db.workoutPlanEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WorkoutDayEntriesTableFilterComposer get workoutDayId {
    final $$WorkoutDayEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutDayId,
        referencedTable: $db.workoutDayEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutDayEntriesTableFilterComposer(
              $db: $db,
              $table: $db.workoutDayEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSessionLogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionLogEntriesTable> {
  $$WorkoutSessionLogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTime => $composableBuilder(
      column: $table.totalTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get perceivedEffort => $composableBuilder(
      column: $table.perceivedEffort,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$WorkoutPlanEntriesTableOrderingComposer get planId {
    final $$WorkoutPlanEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.workoutPlanEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutPlanEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutPlanEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WorkoutDayEntriesTableOrderingComposer get workoutDayId {
    final $$WorkoutDayEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutDayId,
        referencedTable: $db.workoutDayEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutDayEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutDayEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSessionLogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionLogEntriesTable> {
  $$WorkoutSessionLogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get totalTime =>
      $composableBuilder(column: $table.totalTime, builder: (column) => column);

  GeneratedColumn<int> get perceivedEffort => $composableBuilder(
      column: $table.perceivedEffort, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$WorkoutPlanEntriesTableAnnotationComposer get planId {
    final $$WorkoutPlanEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.planId,
            referencedTable: $db.workoutPlanEntries,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutPlanEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutPlanEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$WorkoutDayEntriesTableAnnotationComposer get workoutDayId {
    final $$WorkoutDayEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.workoutDayId,
            referencedTable: $db.workoutDayEntries,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutDayEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutDayEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$WorkoutSessionLogEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSessionLogEntriesTable,
    WorkoutSessionLogEntry,
    $$WorkoutSessionLogEntriesTableFilterComposer,
    $$WorkoutSessionLogEntriesTableOrderingComposer,
    $$WorkoutSessionLogEntriesTableAnnotationComposer,
    $$WorkoutSessionLogEntriesTableCreateCompanionBuilder,
    $$WorkoutSessionLogEntriesTableUpdateCompanionBuilder,
    (WorkoutSessionLogEntry, $$WorkoutSessionLogEntriesTableReferences),
    WorkoutSessionLogEntry,
    PrefetchHooks Function({bool planId, bool workoutDayId})> {
  $$WorkoutSessionLogEntriesTableTableManager(
      _$AppDatabase db, $WorkoutSessionLogEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionLogEntriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionLogEntriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionLogEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> planId = const Value.absent(),
            Value<String> workoutDayId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int> totalTime = const Value.absent(),
            Value<int> perceivedEffort = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionLogEntriesCompanion(
            id: id,
            planId: planId,
            workoutDayId: workoutDayId,
            date: date,
            completed: completed,
            totalTime: totalTime,
            perceivedEffort: perceivedEffort,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String planId,
            required String workoutDayId,
            required DateTime date,
            Value<bool> completed = const Value.absent(),
            Value<int> totalTime = const Value.absent(),
            Value<int> perceivedEffort = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionLogEntriesCompanion.insert(
            id: id,
            planId: planId,
            workoutDayId: workoutDayId,
            date: date,
            completed: completed,
            totalTime: totalTime,
            perceivedEffort: perceivedEffort,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutSessionLogEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({planId = false, workoutDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (planId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.planId,
                    referencedTable: $$WorkoutSessionLogEntriesTableReferences
                        ._planIdTable(db),
                    referencedColumn: $$WorkoutSessionLogEntriesTableReferences
                        ._planIdTable(db)
                        .id,
                  ) as T;
                }
                if (workoutDayId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.workoutDayId,
                    referencedTable: $$WorkoutSessionLogEntriesTableReferences
                        ._workoutDayIdTable(db),
                    referencedColumn: $$WorkoutSessionLogEntriesTableReferences
                        ._workoutDayIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorkoutSessionLogEntriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $WorkoutSessionLogEntriesTable,
        WorkoutSessionLogEntry,
        $$WorkoutSessionLogEntriesTableFilterComposer,
        $$WorkoutSessionLogEntriesTableOrderingComposer,
        $$WorkoutSessionLogEntriesTableAnnotationComposer,
        $$WorkoutSessionLogEntriesTableCreateCompanionBuilder,
        $$WorkoutSessionLogEntriesTableUpdateCompanionBuilder,
        (WorkoutSessionLogEntry, $$WorkoutSessionLogEntriesTableReferences),
        WorkoutSessionLogEntry,
        PrefetchHooks Function({bool planId, bool workoutDayId})>;
typedef $$UserProfileEntriesTableCreateCompanionBuilder
    = UserProfileEntriesCompanion Function({
  required String id,
  Value<String> name,
  Value<String> sexVariant,
  Value<String> primaryGoal,
  Value<String> equipment,
  Value<String> wakeTime,
  Value<bool> onboardingCompleted,
  Value<bool> proEnabled,
  Value<String?> activePlanId,
  Value<int> rowid,
});
typedef $$UserProfileEntriesTableUpdateCompanionBuilder
    = UserProfileEntriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> sexVariant,
  Value<String> primaryGoal,
  Value<String> equipment,
  Value<String> wakeTime,
  Value<bool> onboardingCompleted,
  Value<bool> proEnabled,
  Value<String?> activePlanId,
  Value<int> rowid,
});

class $$UserProfileEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileEntriesTable> {
  $$UserProfileEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sexVariant => $composableBuilder(
      column: $table.sexVariant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryGoal => $composableBuilder(
      column: $table.primaryGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wakeTime => $composableBuilder(
      column: $table.wakeTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get proEnabled => $composableBuilder(
      column: $table.proEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activePlanId => $composableBuilder(
      column: $table.activePlanId, builder: (column) => ColumnFilters(column));
}

class $$UserProfileEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileEntriesTable> {
  $$UserProfileEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sexVariant => $composableBuilder(
      column: $table.sexVariant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryGoal => $composableBuilder(
      column: $table.primaryGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wakeTime => $composableBuilder(
      column: $table.wakeTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get proEnabled => $composableBuilder(
      column: $table.proEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activePlanId => $composableBuilder(
      column: $table.activePlanId,
      builder: (column) => ColumnOrderings(column));
}

class $$UserProfileEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileEntriesTable> {
  $$UserProfileEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sexVariant => $composableBuilder(
      column: $table.sexVariant, builder: (column) => column);

  GeneratedColumn<String> get primaryGoal => $composableBuilder(
      column: $table.primaryGoal, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted, builder: (column) => column);

  GeneratedColumn<bool> get proEnabled => $composableBuilder(
      column: $table.proEnabled, builder: (column) => column);

  GeneratedColumn<String> get activePlanId => $composableBuilder(
      column: $table.activePlanId, builder: (column) => column);
}

class $$UserProfileEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfileEntriesTable,
    UserProfileEntry,
    $$UserProfileEntriesTableFilterComposer,
    $$UserProfileEntriesTableOrderingComposer,
    $$UserProfileEntriesTableAnnotationComposer,
    $$UserProfileEntriesTableCreateCompanionBuilder,
    $$UserProfileEntriesTableUpdateCompanionBuilder,
    (
      UserProfileEntry,
      BaseReferences<_$AppDatabase, $UserProfileEntriesTable, UserProfileEntry>
    ),
    UserProfileEntry,
    PrefetchHooks Function()> {
  $$UserProfileEntriesTableTableManager(
      _$AppDatabase db, $UserProfileEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> sexVariant = const Value.absent(),
            Value<String> primaryGoal = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> wakeTime = const Value.absent(),
            Value<bool> onboardingCompleted = const Value.absent(),
            Value<bool> proEnabled = const Value.absent(),
            Value<String?> activePlanId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfileEntriesCompanion(
            id: id,
            name: name,
            sexVariant: sexVariant,
            primaryGoal: primaryGoal,
            equipment: equipment,
            wakeTime: wakeTime,
            onboardingCompleted: onboardingCompleted,
            proEnabled: proEnabled,
            activePlanId: activePlanId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> name = const Value.absent(),
            Value<String> sexVariant = const Value.absent(),
            Value<String> primaryGoal = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> wakeTime = const Value.absent(),
            Value<bool> onboardingCompleted = const Value.absent(),
            Value<bool> proEnabled = const Value.absent(),
            Value<String?> activePlanId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfileEntriesCompanion.insert(
            id: id,
            name: name,
            sexVariant: sexVariant,
            primaryGoal: primaryGoal,
            equipment: equipment,
            wakeTime: wakeTime,
            onboardingCompleted: onboardingCompleted,
            proEnabled: proEnabled,
            activePlanId: activePlanId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfileEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfileEntriesTable,
    UserProfileEntry,
    $$UserProfileEntriesTableFilterComposer,
    $$UserProfileEntriesTableOrderingComposer,
    $$UserProfileEntriesTableAnnotationComposer,
    $$UserProfileEntriesTableCreateCompanionBuilder,
    $$UserProfileEntriesTableUpdateCompanionBuilder,
    (
      UserProfileEntry,
      BaseReferences<_$AppDatabase, $UserProfileEntriesTable, UserProfileEntry>
    ),
    UserProfileEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitEntriesTableTableManager get habitEntries =>
      $$HabitEntriesTableTableManager(_db, _db.habitEntries);
  $$HabitLogEntriesTableTableManager get habitLogEntries =>
      $$HabitLogEntriesTableTableManager(_db, _db.habitLogEntries);
  $$WorkoutPlanEntriesTableTableManager get workoutPlanEntries =>
      $$WorkoutPlanEntriesTableTableManager(_db, _db.workoutPlanEntries);
  $$WorkoutDayEntriesTableTableManager get workoutDayEntries =>
      $$WorkoutDayEntriesTableTableManager(_db, _db.workoutDayEntries);
  $$ExerciseEntriesTableTableManager get exerciseEntries =>
      $$ExerciseEntriesTableTableManager(_db, _db.exerciseEntries);
  $$WorkoutSetEntriesTableTableManager get workoutSetEntries =>
      $$WorkoutSetEntriesTableTableManager(_db, _db.workoutSetEntries);
  $$WorkoutSessionLogEntriesTableTableManager get workoutSessionLogEntries =>
      $$WorkoutSessionLogEntriesTableTableManager(
          _db, _db.workoutSessionLogEntries);
  $$UserProfileEntriesTableTableManager get userProfileEntries =>
      $$UserProfileEntriesTableTableManager(_db, _db.userProfileEntries);
}
