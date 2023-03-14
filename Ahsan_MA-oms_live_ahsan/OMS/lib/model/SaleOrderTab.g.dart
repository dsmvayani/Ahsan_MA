// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SaleOrderTab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleOrderTabAdapter extends TypeAdapter<SaleOrderTab> {
  @override
  final int typeId = 4;

  @override
  SaleOrderTab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleOrderTab(
      nBillDate: fields[0] as String,
      nCustomer: fields[1] as Customer,
      nSalesMan: fields[2] as SalesManTab,
      nDescription: fields[3] as String,
      nProductList: (fields[4] as List).cast<Product>(),
      nTotalQuantity: fields[5] as double,
      nTotalItems: fields[6] as double,
      nNetAmount: fields[7] as double,
      isSync: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SaleOrderTab obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.nBillDate)
      ..writeByte(1)
      ..write(obj.nCustomer)
      ..writeByte(2)
      ..write(obj.nSalesMan)
      ..writeByte(3)
      ..write(obj.nDescription)
      ..writeByte(4)
      ..write(obj.nProductList)
      ..writeByte(5)
      ..write(obj.nTotalQuantity)
      ..writeByte(6)
      ..write(obj.nTotalItems)
      ..writeByte(7)
      ..write(obj.nNetAmount)
      ..writeByte(8)
      ..write(obj.isSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleOrderTabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
