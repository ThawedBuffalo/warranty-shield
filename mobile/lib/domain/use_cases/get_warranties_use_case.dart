/// Use Case: Get Warranties
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)

import 'package:warranty_shield/domain/entities/warranty_entity.dart';
import 'package:warranty_shield/domain/repositories/warranty_repository.dart';

class GetWarrantiesUseCase {
  final WarrantyRepository repository;

  GetWarrantiesUseCase(this.repository);

  Future<List<WarrantyEntity>> call(String userId) {
    return repository.getWarranties(userId);
  }
}

/// Use Case: Get Expiring Warranties
class GetExpiringWarrantiesUseCase {
  final WarrantyRepository repository;

  GetExpiringWarrantiesUseCase(this.repository);

  Future<List<WarrantyEntity>> call(String userId, {int days = 90}) {
    return repository.getExpiringWarranties(userId, days: days);
  }
}