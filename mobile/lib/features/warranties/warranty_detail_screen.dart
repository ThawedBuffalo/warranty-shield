/// Warranty Detail Screen
///
/// Sprint 1: SCRUM-865 (Manual Warranty Entry Form)
/// Displays full warranty details with expiration countdown.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod';

import 'warranty_provider.dart';

class WarrantyDetailScreen extends ConsumerWidget {
  const WarrantyDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args == null) return const Scaffold(body: Center(child: Text('No warranty selected')));

    return Scaffold(
      appBar: AppBar(title: const Text('Warranty Details')),
      body: FutureBuilder(
        future: ref.read(warrantyProvider.notifier).loadWarrantyDetail(
              ref.read(authProvider).when(authenticated: (u) => u.id, loading: () => '', unauthenticated: () => '', error: (_, __) => ''),
              args,
            ),
        builder: (context, snapshot) {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))),
            const SizedBox(width: 16),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Edit')),
          ]),
        ),
      ),
    );
  }
}