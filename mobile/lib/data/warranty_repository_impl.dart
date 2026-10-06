/// Warranty Repository Implementation
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)
/// Concrete implementation using the remote API.

import 'package:warranty_shield/domain/entities/warranty_entity.dart';
import 'package:warranty_shield/domain/repositories/warranty_repository.dart';
import 'package:warranty_shield/data/api_client.dart';

class WarrantyRepositoryImpl implements WarrantyRepository {
  final ApiClient apiClient;

  WarrantyRepositoryImpl(this.apiClient);

  @override
  Future<WarrantyEntity> createWarranty(WarrantyEntity warranty) async {
    final data = await apiClient.createWarranty(
      warranty.userId,
      productName: warranty.productName,
      purchaseDate: warranty.purchaseDate.toIso8601String(),
      warrantyDurationMonths: warranty.warrantyDurationMonths,
      retailer: warranty.retailer,
      price: warranty.price,
    );
    return WarrantyEntity.fromJson(data);
  }

  @override
  Future<List<WarrantyEntity>> getWarranties(String userId) async {
    final data = await apiClient.getWarranties(userId);
    return data.map((json) => WarrantyEntity.fromJson(json)).toList();
  }

  @override
  Future<WarrantyEntity> getWarranty(String userId, String id) async {
    final data = await apiClient.getWarranty(userId, id);
    return WarrantyEntity.fromJson(data);
  }

  @override
  Future<WarrantyEntity> updateWarranty(
    String userId,
    WarrantyEntity warranty,
  ) async {
    final data = await apiClient.updateWarranty(
      userId,
      id: warranty.id,
      productName: warranty.productName,
      purchaseDate: warranty.purchaseDate.toIso8601String(),
      warrantyDurationMonths: warranty.warrantyDurationMonths,
      retailer: warranty.retailer,
      price: warranty.price,
    );
    return WarrantyEntity.fromJson(data);
  }

  @override
  Future<void> deleteWarranty(String userId, String id) async {
    await apiClient.deleteWarranty(userId, id);
  }

  @override
  Future<List<WarrantyEntity>> getExpiringWarranties(
    String userId, {
    int? days,
  }) async {
    final data = await apiClient.getExpiringWarranties(userId);
    return data.map((json) => WarrantyEntity.fromJson(json)).toList();
  }
}