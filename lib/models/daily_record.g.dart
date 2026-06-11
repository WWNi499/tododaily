part of 'daily_record.dart';

class DailyRecordAdapter extends TypeAdapter<DailyRecord> {
  @override
  final int typeId = 1;

  @override
  DailyRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyRecord(
      dateKey: fields[0] as String,
      ignoreCount: fields[1] as int? ?? 0,
      lastIgnoreTime: fields[2] as DateTime?,
      morningDismissed: fields[3] as bool? ?? false,
      eveningReviewed: fields[4] as bool? ?? false,
      noTodoToday: fields[5] as bool? ?? false,
      eveningReminderCount: fields[6] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, DailyRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0) ..write(obj.dateKey)
      ..writeByte(1) ..write(obj.ignoreCount)
      ..writeByte(2) ..write(obj.lastIgnoreTime)
      ..writeByte(3) ..write(obj.morningDismissed)
      ..writeByte(4) ..write(obj.eveningReviewed)
      ..writeByte(5) ..write(obj.noTodoToday)
      ..writeByte(6) ..write(obj.eveningReminderCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyRecordAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
