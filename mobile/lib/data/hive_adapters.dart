/// Hive Adapters for Local Storage (Offline Support)
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)
/// Enables offline-first architecture with Hive key-value store.

import 'package:hive/hive.dart';
import 'package:warranty_shield/domain/entities/warranty_entity.dart';
import 'package:warranty_shield/domain/entities/user_entity.dart';

// Type adapters for Hive storage
class WarrantyAdapter extends TypeAdapter<WarrantyEntity> {
  @override
  final int typeId = 0;

  @override
  WarrantyEntity read(BinaryReader reader) {
    return WarrantyEntity(
      id: reader.readString(),
      userId: reader.readString(),
      productName: reader.readString(),
      purchaseDate: DateTime.fromMicrosecondsSinceEpoch(reader.readInteger()),
      warrantyDurationMonths: reader.readInteger(),
      retailer: reader.readString(),
      price: reader.readDouble(),
      expirationDate: DateTime.fromMicrosecondsSinceEpoch(reader.readInteger()),
      createdAt: DateTime.fromMicrosecondsSinceEpoch(reader.readInteger()),
      updatedAt: reader.readByte() == 1 ? DateTime.fromMicrosecondsSinceEpoch(reader.readInteger()) : null,
      status: WarrantyEntity.calculateStatus(
        DateTime.fromMicrosecondsSinceEpoch(reader.readInteger()),
      ),
    );
  }

  @override
  void write(BinaryWriter writer, WarrantyEntity obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.userId);
    writer.writeString(obj.productName);
    writer.writeInteger(obj.purchaseDate.toMicrosecondsSinceEpoch());
    writer.writeInteger(obj.warrantyDurationMonths);
    writer.writeString(obj.retailer);
    writer.writeDouble(obj.price);
    writer.writeInteger(obj.expirationDate.toMicrosecondsSinceEpoch());
    writer.writeInteger(obj.createdAt.toMicrosecondsSinceEpoch());
    if (obj.updatedAt != null) {
      writer.writeByte(1);
      writer.writeInteger(obj.updatedAt!.toMicrosecondsSinceEpoch());
    } else {
      writer.writeByte(0);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool equals(WarrantyEntity e) => typeId == e.hashCode;
}

class UserAdapter extends TypeAdapter<UserEntity> {
  @override
  final int typeId = 1;

  @override
  UserEntity read(BinaryReader reader) {
    return UserEntity(
      id: reader.readString(),
      email: reader.readString(),
      firebaseUid: reader.readString(),
      deviceToken: reader.readByte() == 1 ? reader.readString() : null,
      createdAt: DateTime.fromMicrosecondsSinceEpoch(reader.readInteger()),
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.email);
    writer.writeString(obj.firebaseUid);
    if (obj.deviceToken != null) {
      writer.writeByte(1);
      writer.writeString(obj.deviceToken!);
    } else {
      writer.writeByte(0);
    }
    writer.writeInteger(obj.createdAt.toMicrosecondsSinceEpoch());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool equals(UserEntity e) => typeId == e.hashCode;
}