// lib\features\cart\domain\entity\cart_item_entity_hive.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_entity_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemDataAdapter extends TypeAdapter<CartItemData> {
  @override
  final int typeId = 0;

  @override
  CartItemData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemData(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      imagePath: fields[3] as String,
      price: fields[4] as double,
      quantity: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
