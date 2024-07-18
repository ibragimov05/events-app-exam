import 'package:flutter/material.dart';

class PaymentSelectionWidget extends StatefulWidget {
  final void Function(String) paymentMethod;
  const PaymentSelectionWidget({super.key, required this.paymentMethod});

  @override
  State<PaymentSelectionWidget> createState() => _PaymentSelectionWidgetState();
}

class _PaymentSelectionWidgetState extends State<PaymentSelectionWidget> {
  String _selectedPaymentMethod = '';

  void _onPaymentMethodSelected(String method) {
    _selectedPaymentMethod = method;
    widget.paymentMethod(_selectedPaymentMethod);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'To\'lov turini tanlang',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildPaymentOption('Click', 'click'),
          _buildPaymentOption('Payme', 'payme'),
          _buildPaymentOption('Naqd', 'naqd'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, String value) {
    return InkWell(
      onTap: () => _onPaymentMethodSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                _onPaymentMethodSelected(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
