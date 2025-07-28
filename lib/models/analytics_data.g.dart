// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

import 'package:hive/hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsDataAdapter extends TypeAdapter<AnalyticsData> {
  @override
  final int typeId = 3;

  @override
  AnalyticsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsData(
      date: fields[0] as DateTime,
      completedHabits: fields[1] as int,
      totalHabits: fields[2] as int,
      completionRate: fields[3] as double,
      habitCompletions: (fields[4] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.completedHabits)
      ..writeByte(2)
      ..write(obj.totalHabits)
      ..writeByte(3)
      ..write(obj.completionRate)
      ..writeByte(4)
      ..write(obj.habitCompletions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeeklyAnalyticsAdapter extends TypeAdapter<WeeklyAnalytics> {
  @override
  final int typeId = 4;

  @override
  WeeklyAnalytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyAnalytics(
      weekStart: fields[0] as DateTime,
      weekEnd: fields[1] as DateTime,
      averageCompletionRate: fields[2] as double,
      totalCompletions: fields[3] as int,
      habitPerformance: (fields[4] as Map).cast<String, int>(),
      bestDay: fields[5] as int,
      worstDay: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyAnalytics obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.weekStart)
      ..writeByte(1)
      ..write(obj.weekEnd)
      ..writeByte(2)
      ..write(obj.averageCompletionRate)
      ..writeByte(3)
      ..write(obj.totalCompletions)
      ..writeByte(4)
      ..write(obj.habitPerformance)
      ..writeByte(5)
      ..write(obj.bestDay)
      ..writeByte(6)
      ..write(obj.worstDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyAnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MonthlyAnalyticsAdapter extends TypeAdapter<MonthlyAnalytics> {
  @override
  final int typeId = 5;

  @override
  MonthlyAnalytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlyAnalytics(
      month: fields[0] as DateTime,
      monthlyCompletionRate: fields[1] as double,
      totalCompletions: fields[2] as int,
      streaksStarted: fields[3] as int,
      streaksLost: fields[4] as int,
      habitTrends: (fields[5] as Map).cast<String, double>(),
      bestWeek: fields[6] as int,
      totalActiveHabits: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlyAnalytics obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.monthlyCompletionRate)
      ..writeByte(2)
      ..write(obj.totalCompletions)
      ..writeByte(3)
      ..write(obj.streaksStarted)
      ..writeByte(4)
      ..write(obj.streaksLost)
      ..writeByte(5)
      ..write(obj.habitTrends)
      ..writeByte(6)
      ..write(obj.bestWeek)
      ..writeByte(7)
      ..write(obj.totalActiveHabits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyAnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
