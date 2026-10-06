/// Warranty Repository Interface - Domain Layer
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)
/// Defines the contract for warranty data operations.
/// Implementation agnostic (works with remote API or local Hive).

import 'package:warranty_shield/domain/entities/warranty_entity.dart';

abstract class WarrantyRepository {
  /// Create a new warranty
  Future<WarrantyEntity> createWarranty(WarrantyEntity warranty);

  /// Get all warranties for a user
  Future<List<WarrantyEntity>> getWarranties(String userId);

  /// Get a single warranty by ID
  Future<WarrantyEntity> getWarranty(String userId, String id);

  /// Update an existing warranty
  Future<WarrantyEntity> updateWarranty(String userId, WarrantyEntity warranty);

  /// Delete a warranty
  Future<void> deleteWarranty(String userId, String id);

  /// Get warranties expiring within the given number of days
  Future<List<WarrantyEntity>> getExpiringWarranties(String userId, {int days});
}