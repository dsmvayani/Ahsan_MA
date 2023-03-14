// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SalesManTab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesManTabAdapter extends TypeAdapter<SalesManTab> {
  @override
  final int typeId = 2;

  @override
  SalesManTab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesManTab(
      nSalesManCode: fields[0] as String,
      nSalesMan: fields[1] as String,
      nShortName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SalesManTab obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nSalesManCode)
      ..writeByte(1)
      ..write(obj.nSalesMan)
      ..writeByte(2)
      ..write(obj.nShortName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesManTabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
