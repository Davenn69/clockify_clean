// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityHiveAdapter extends TypeAdapter<ActivityHive> {
  @override
  final int typeId = 0;

  @override
  ActivityHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityHive(
      uuid: fields[0] as String,
      description: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      locationLat: fields[4] as double,
      locationLng: fields[5] as double,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      userUuid: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.locationLat)
      ..writeByte(5)
      ..write(obj.locationLng)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.userUuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
