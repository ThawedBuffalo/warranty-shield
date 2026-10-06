/// Auth Screen - Login/Logout UI
///
/// Sprint 1: SCRUM-867 (Firebase Auth & Session Management)
/// Handles user authentication with email/password and Google OAuth.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod';

import 'auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        authenticated: (user) => const SizedBox.shrink(),
        unauthenticated: () => _buildLoginView(),
        error: (error, _) => _buildErrorView(error),
      ),
    );
  }

  Widget _buildLoginView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.shield_outlined, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Warranty Shield', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Track and manage your warranties', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 48),
              TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), hintText: 'your@email.com'), validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                return null;
              }),
              const SizedBox(height: 16),
              TextFormField(controller: _passwordController, obscureText: _obscurePassword, textInputAction: TextInputAction.done, onFieldSubmitted: (_) => _handleLogin(), decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), hintText: 'Enter your password', suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))), validator: (value) {
                if (value == null || value.isEmpty) return 'Password is required';
                if (value.length < 6) return 'Password must be at least 6 characters';
                return null;
              }),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _handleLogin, child: const Text('Sign In')),
              const SizedBox(height: 16),
              OutlinedButton.icon(onPressed: _handleGoogleSignIn, icon: const Icon(Icons.login), label: const Text('Sign in with Google')),
              const SizedBox(height: 24),
              TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset coming in Sprint 2'))), child: const Text('Forgot Password?')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String? error) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(error ?? 'An error occurred', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(authProvider.notifier).logout(), child: const Text('Try Again')),
            ],
          ),
        ),
      ),
    );
  }
}