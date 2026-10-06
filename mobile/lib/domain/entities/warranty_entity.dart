/// Warranty Entity - Core domain model for warranty tracking
///
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)

import 'package:equatable/equatable.dart';

enum WarrantyStatus { active, expiring, critical, expired }

class WarrantyEntity extends Equatable {
  final String id;
  final String userId;
  final String productName;
  final DateTime purchaseDate;
  final int warrantyDurationMonths;
  final String retailer;
  final double price;
  final DateTime expirationDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final WarrantyStatus status;

  const WarrantyEntity({
    required this.id,
    required this.userId,
    required this.productName,
    required this.purchaseDate,
    required this.warrantyDurationMonths,
    required this.retailer,
    required this.price,
    required this.expirationDate,
    required this.createdAt,
    this.updatedAt,
    required this.status,
  });

  /// Calculate warranty status based on current date
  static WarrantyStatus calculateStatus(DateTime expirationDate) {
    final now = DateTime.now();
    final daysUntil = expirationDate.difference(now).inDays;

    if (daysUntil < 0) return WarrantyStatus.expired;
    if (daysUntil <= 30) return WarrantyStatus.critical;
    if (daysUntil <= 60) return WarrantyStatus.expiring;
    return WarrantyStatus.active;
  }

  /// Calculate remaining days until expiration
  int get remainingDays =>
      expirationDate.difference(DateTime.now()).inDays;

  /// Calculate warranty progress percentage (0-100)
  double get progressPercent {
    final totalDuration = expirationDate.difference(purchaseDate).inDays;
    final elapsed = DateTime.now().difference(purchaseDate).inDays;
    if (totalDuration <= 0) return 0.0;
    return (elapsed / totalDuration * 100).clamp(0.0, 100.0);
  }

  /// Check if warranty is expiring within the given days
  bool isExpiringWithin(int days) {
    final daysUntil = expirationDate.difference(DateTime.now()).inDays;
    return daysUntil >= 0 && daysUntil <= days;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        productName,
        purchaseDate,
        warrantyDurationMonths,
        retailer,
        price,
        expirationDate,
        status,
      ];

  /// Convert to/from JSON for API communication
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productName': productName,
      'purchaseDate': purchaseDate.toIso8601String(),
      'warrantyDurationMonths': warrantyDurationMonths,
      'retailer': retailer,
      'price': price,
      'expirationDate': expirationDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status.name,
    };
  }

  factory WarrantyEntity.fromJson(Map<String, dynamic> json) {
    final statusString = json['status'] as String? ?? 'active';
    final status = WarrantyStatus.values.byName(statusString);

    return WarrantyEntity(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String,
      productName: json['productName'] as String,
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      warrantyDurationMonths: json['warrantyDurationMonths'] as int,
      retailer: json['retailer'] as String,
      price: (json['price'] as num).toDouble(),
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      status: status,
    );
  }

  /// Create a copy with updated fields
  WarrantyEntity copyWith({
    String? id,
    String? productName,
    DateTime? purchaseDate,
    int? warrantyDurationMonths,
    String? retailer,
    double? price,
    DateTime? expirationDate,
  }) {
    return WarrantyEntity(
      id: id ?? this.id,
      userId: userId,
      productName: productName ?? this.productName,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyDurationMonths: warrantyDurationMonths ?? this.warrantyDurationMonths,
      retailer: retailer ?? this.retailer,
      price: price ?? this.price,
      expirationDate: expirationDate ?? this.expirationDate,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      status: calculateStatus(expirationDate ?? this.expirationDate),
    );
  }

  @override
  String toString() =>
      'WarrantyEntity(id: $id, product: $productName, status: $status)';
}