/// Warranty Entry Screen - Manual Form UI
///
/// Sprint 1: SCRUM-865 (Manual Warranty Entry Form)
/// 30-second entry target: 5 input fields, validation, keyboard navigation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod';

import 'warranty_provider.dart';
import '../auth/auth_provider.dart';

class WarrantyEntryScreen extends ConsumerStatefulWidget {
  const WarrantyEntryScreen({super.key});

  @override
  ConsumerState<WarrantyEntryScreen> createState() => _WarrantyEntryScreenState();
}

class _WarrantyEntryScreenState extends ConsumerState<WarrantyEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _retailerController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _purchaseDate;
  int _warrantyMonths = 12;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _productController.dispose();
    _retailerController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _purchaseDate == null) return;
    setState(() => _isSubmitting = true);
    try {
      final userId = ref.read(authProvider).when(
            authenticated: (u) => u.id,
            loading: () => '',
            unauthenticated: () => '',
            error: (_, __) => '',
          );
      await ref.read(warrantyProvider.notifier).addWarranty(
            productName: _productController.text,
            purchaseDate: _purchaseDate!,
            warrantyDurationMonths: _warrantyMonths,
            retailer: _retailerController.text,
            price: double.parse(_priceController.text),
            userId: userId,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Warranty added successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: \$e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Warranty')),
      body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(16), children: [
        TextFormField(controller: _productController, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Product Name', hintText: 'e.g., MacBook Pro 14"', prefixIcon: Icon(Icons.devices)), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
        const SizedBox(height: 16),
        TextFormField(controller: _retailerController, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Retailer', hintText: 'e.g., Apple Store', prefixIcon: Icon(Icons.store)), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
        const SizedBox(height: 16),
        InkWell(onTap: _selectDate, child: InputDecorator(decoration: const InputDecoration(labelText: 'Purchase Date', prefixIcon: Icon(Icons.calendar_today), suffixIcon: Icon(Icons.arrow_drop_down)), child: Text(_purchaseDate == null ? 'Select date' : '\${_purchaseDate!.toLocal().toString().split(" ")[0]}', style: Theme.of(context).textTheme.bodyLarge))),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(value: _warrantyMonths, decoration: const InputDecoration(labelText: 'Warranty Duration (months)', prefixIcon: Icon(Icons.timer)), items: [6, 12, 18, 24, 36, 48, 60, 72, 96, 120].map((m) => DropdownMenuItem(value: m, child: Text('\$m months'))).toList(), onChanged: (v) => setState(() => _warrantyMonths = v!)),
        const SizedBox(height: 16),
        TextFormField(controller: _priceController, textInputAction: TextInputAction.done, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Price (\$)', hintText: '0.00', prefixIcon: Icon(Icons.attach_money)), validator: (v) { if (v == null || v.isEmpty) return 'Required'; if (double.tryParse(v) == null) return 'Invalid'; if (double.parse(v) <= 0) return 'Must be positive'; return null; }),
        const SizedBox(height: 32),
        if (_purchaseDate != null)
          Card(color: Theme.of(context).colorScheme.primaryContainer, child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text('Estimated Expiration:', style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 4), Text(_purchaseDate!.add(Duration(days: _warrantyMonths * 30.44)).toString().split(' ')[0], style: Theme.of(context).textTheme.titleMedium)]))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _isSubmitting ? null : _submitForm, child: _isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save Warranty'))),
      ])),
    );
  }
}