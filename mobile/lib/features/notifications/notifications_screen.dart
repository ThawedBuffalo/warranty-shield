/// Notifications Screen (Sprint 1 Placeholder)
///
/// Sprint 1: SCRUM-867 (Firebase Auth & Session Management)
/// Displays notification settings and pending alerts.

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_outlined, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Notification Center', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Expiring warranty alerts will appear here', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}