/// Unit Tests for Warranty Entity
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)

import 'package:flutter_test/flutter_test.dart';
import 'package:warranty_shield/domain/entities/warranty_entity.dart';

void main() {
  group('WarrantyEntity', () {
    test('calculateStatus returns correct status for active warranty', () {
      final futureDate = DateTime.now().add(const Duration(days: 365));
      expect(WarrantyEntity.calculateStatus(futureDate), WarrantyStatus.active);
    });

    test('calculateStatus returns correct status for expiring warranty', () {
      final soonDate = DateTime.now().add(const Duration(days: 45));
      expect(WarrantyEntity.calculateStatus(soonDate), WarrantyStatus.expiring);
    });

    test('calculateStatus returns correct status for critical warranty', () {
      final criticalDate = DateTime.now().add(const Duration(days: 15));
      expect(WarrantyEntity.calculateStatus(criticalDate), WarrantyStatus.critical);
    });

    test('calculateStatus returns correct status for expired warranty', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 30));
      expect(WarrantyEntity.calculateStatus(pastDate), WarrantyStatus.expired);
    });

    test('remainingDays calculates correctly', () {
      final warranty = WarrantyEntity(
        id: 'test',
        userId: 'user',
        productName: 'Test Product',
        purchaseDate: DateTime.now().subtract(const Duration(days: 300)),
        warrantyDurationMonths: 12,
        retailer: 'Test Store',
        price: 100.0,
        expirationDate: DateTime.now().add(const Duration(days: 65)),
        createdAt: DateTime.now(),
        status: WarrantyStatus.active,
      );
      expect(warranty.remainingDays, greaterThan(60));
    });

    test('progressPercent calculates correctly', () {
      final warranty = WarrantyEntity(
        id: 'test',
        userId: 'user',
        productName: 'Test Product',
        purchaseDate: DateTime.now().subtract(const Duration(days: 182)),
        warrantyDurationMonths: 12,
        retailer: 'Test Store',
        price: 100.0,
        expirationDate: DateTime.now().add(const Duration(days: 65)),
        createdAt: DateTime.now(),
        status: WarrantyStatus.active,
      );
      expect(warranty.progressPercent, inInclusiveRange(45, 55));
    });

    test('toJson and fromJson are inverse operations', () {
      final original = WarrantyEntity(
        id: 'test-123',
        userId: 'user-456',
        productName: 'iPhone 15',
        purchaseDate: DateTime(2024, 6, 1),
        warrantyDurationMonths: 12,
        retailer: 'Best Buy',
        price: 999.0,
        expirationDate: DateTime(2025, 6, 1),
        createdAt: DateTime(2024, 6, 1),
        status: WarrantyStatus.active,
      );

      final json = original.toJson();
      final restored = WarrantyEntity.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.productName, original.productName);
      expect(restored.purchaseDate, original.purchaseDate);
      expect(restored.warrantyDurationMonths, original.warrantyDurationMonths);
      expect(restored.retailer, original.retailer);
      expect(restored.price, original.price);
      expect(restored.expirationDate, original.expirationDate);
      expect(restored.status, original.status);
    });
  });
}