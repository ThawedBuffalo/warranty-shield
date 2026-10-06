/// Warranty Provider - Riverpod State Management
///
/// Sprint 1: SCRUM-865 (Manual Warranty Entry Form)
/// Sprint 1: SCRUM-866 (Warranty Data Model & Storage)
/// Manages warranty data state using Riverpod.

import 'package:flutter_riverpod/flutter_riverpod';
import 'package:warranty_shield/domain/entities/warranty_entity.dart';
import 'package:warranty_shield/domain/repositories/warranty_repository.dart';
import 'package:warranty_shield/domain/use_cases/create_warranty_use_case.dart';
import 'package:warranty_shield/domain/use_cases/get_warranties_use_case.dart';
import 'package:warranty_shield/data/api_client.dart';
import 'package:warranty_shield/data/warranty_repository_impl.dart';
import 'package:warranty_shield/features/auth/auth_provider.dart';

/// Warranty state for the application
class WarrantyState {
  final AsyncValue<List<WarrantyEntity>> warranties;
  final AsyncValue<WarrantyEntity?> selectedWarranty;

  const WarrantyState({
    required this.warranties,
    required this.selectedWarranty,
  });

  factory WarrantyState.initial() => const WarrantyState(
        warranties: AsyncValue.nullValue,
        selectedWarranty: AsyncValue.nullValue,
      );

  factory WarrantyState.loading() => const WarrantyState(
        warranties: AsyncValue.loading(),
        selectedWarranty: AsyncValue.loading(),
      );
}

/// Repository Provider
final warrantyRepositoryProvider = Provider<WarrantyRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WarrantyRepositoryImpl(apiClient);
});

/// Use Case Providers
final createWarrantyUseCaseProvider = Provider<CreateWarrantyUseCase>((ref) {
  final repository = ref.watch(warrantyRepositoryProvider);
  return CreateWarrantyUseCase(repository);
});

final getWarrantiesUseCaseProvider = Provider<GetWarrantiesUseCase>((ref) {
  final repository = ref.watch(warrantyRepositoryProvider);
  return GetWarrantiesUseCase(repository);
});

/// Main Warranty Provider
final warrantyProvider = StateNotifierProvider<WarrantyNotifier, WarrantyState>((ref) {
  final repository = ref.watch(warrantyRepositoryProvider);
  return WarrantyNotifier(repository);
});

/// Warranty StateNotifier
class WarrantyNotifier extends StateNotifier<WarrantyState> {
  final WarrantyRepository _repository;

  WarrantyNotifier(this._repository) : super(WarrantyState.initial()) {
    // Auto-load warranties when user is authenticated
    ref.listen<String?>(authProvider, (previous, next) {
      next.when(
        loading: () {},
        authenticated: (user) => loadWarranties(user.id),
        unauthenticated: () {},
        error: (_, __) {},
      );
    });
  }

  Future<void> loadWarranties(String userId) async {
    state = WarrantyState.loading();
    try {
      final warranties = await _repository.getWarranties(userId);
      state = WarrantyState(
        warranties: AsyncValue.data(warranties),
        selectedWarranty: AsyncValue.data(null),
      );
    } catch (e, stack) {
      state = WarrantyState(
        warranties: AsyncValue.error(e, stack),
        selectedWarranty: AsyncValue.data(null),
      );
    }
  }

  Future<void> loadWarrantyDetail(String userId, String id) async {
    try {
      final warranty = await _repository.getWarranty(userId, id);
      state = WarrantyState(
        warranties: state.warranties,
        selectedWarranty: AsyncValue.data(warranty),
      );
    } catch (e, stack) {
      state = WarrantyState(
        warranties: state.warranties,
        selectedWarranty: AsyncValue.error(e, stack),
      );
    }
  }

  Future<void> addWarranty({
    required String productName,
    required DateTime purchaseDate,
    required int warrantyDurationMonths,
    required String retailer,
    required double price,
    required String userId,
  }) async {
    try {
      final expirationDate = purchaseDate.add(Duration(days: warrantyDurationMonths * 30.44));
      final warranty = WarrantyEntity(
        id: '',
        userId: userId,
        productName: productName.trim(),
        purchaseDate: purchaseDate,
        warrantyDurationMonths: warrantyDurationMonths,
        retailer: retailer.trim(),
        price: price,
        expirationDate: expirationDate,
        createdAt: DateTime.now(),
        status: WarrantyEntity.calculateStatus(expirationDate),
      );
      final created = await _repository.createWarranty(warranty);

      // Refresh the list
      final updatedList = [...?state.warranties.value]..add(created);
      state = WarrantyState(
        warranties: AsyncValue.data(updatedList),
        selectedWarranty: state.selectedWarranty,
      );
    } catch (e, stack) {
      state = WarrantyState(
        warranties: state.warranties,
        selectedWarranty: AsyncValue.error(e, stack),
      );
    }
  }

  Future<void> deleteWarranty(String userId, String id) async {
    try {
      await _repository.deleteWarranty(userId, id);
      final updatedList = [...?state.warranties.value]..removeWhere((w) => w.id == id);
      state = WarrantyState(
        warranties: AsyncValue.data(updatedList),
        selectedWarranty: state.selectedWarranty,
      );
    } catch (e, stack) {
      state = WarrantyState(
        warranties: state.warranties,
        selectedWarranty: AsyncValue.error(e, stack),
      );
    }
  }

  void clearSelected() {
    state = WarrantyState(
      warranties: state.warranties,
      selectedWarranty: AsyncValue.data(null),
    );
  }
}