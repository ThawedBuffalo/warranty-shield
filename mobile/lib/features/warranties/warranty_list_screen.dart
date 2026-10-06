/// Warranty List Screen
///
/// Sprint 1: SCRUM-865 (Manual Warranty Entry Form)
/// Displays all warranties with status-based filtering and sorting.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod';

import 'warranty_provider.dart';
import '../auth/auth_provider.dart';

class WarrantyListScreen extends ConsumerWidget {
  const WarrantyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final warrantyState = ref.watch(warrantyProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      authenticated: (user) => _buildContent(context, ref, user, warrantyState),
      unauthenticated: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, dynamic user, WarrantyState warrantyState) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Warranties'), actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(warrantyProvider.notifier).loadWarranties(user.id)),
      ]),
      body: warrantyState.warranties.when(
        data: (warranties) {
          if (warranties == null || warranties.isEmpty) return _buildEmptyState(context);
          return _buildWarrantyList(context, warranties);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/warranty-entry'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No warranties yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tap + to add your first warranty', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildWarrantyList(BuildContext context, List<dynamic> warranties) {
    final sorted = List<dynamic>.from(warranties)..sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    return RefreshIndicator(
      onRefresh: () => ref.read(warrantyProvider.notifier).loadWarranties(ref.read(authProvider).when(authenticated: (u) => u.id, loading: () => '', unauthenticated: () => '', error: (_, __) => '')),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sorted.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildWarrantyCard(context, sorted[index]),
      ),
    );
  }

  Widget _buildWarrantyCard(BuildContext context, dynamic warranty) {
    final statusColor = _getStatusColor(warranty.status);
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: statusColor.withOpacity(0.1), child: Icon(_getStatusIcon(warranty.status), color: statusColor)),
        title: Text(warranty.productName),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(warranty.retailer, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: warranty.progressPercent / 100, minHeight: 4, borderRadius: BorderRadius.circular(2), backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(statusColor)),
          const SizedBox(height: 4),
          Text(warranty.remainingDays < 0 ? 'Expired ${warranty.remainingDays.abs()} days ago' : '${warranty.remainingDays} days remaining', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.w500)),
        ]),
        trailing: Text('\$${warranty.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleSmall),
        onTap: () => Navigator.pushNamed(context, '/warranty-detail', arguments: warranty.id),
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    switch (status) {
      case 'expired': return Colors.red;
      case 'critical': return Colors.orange;
      case 'expiring': return Colors.amber;
      case 'active': default: return Colors.green;
    }
  }

  IconData _getStatusIcon(dynamic status) {
    switch (status) {
      case 'expired': return Icons.cancel_outlined;
      case 'critical': return Icons.warning_amber_rounded;
      case 'expiring': return Icons.schedule;
      case 'active': default: return Icons.check_circle_outline;
    }
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text('Failed to load warranties: \$error'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => ref.read(warrantyProvider.notifier).loadWarranties(ref.read(authProvider).when(authenticated: (u) => u.id, loading: () => '', unauthenticated: () => '', error: (_, __) => '')), child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}