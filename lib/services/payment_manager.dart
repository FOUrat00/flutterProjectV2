import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../constants/app_theme.dart';

class PaymentManager extends ChangeNotifier {
  static final PaymentManager _instance = PaymentManager._internal();
  factory PaymentManager() => _instance;
  PaymentManager._internal() {
    // Initial mock data
    _payments.addAll([
      Payment(
        id: '1',
        title: 'Rent - February 2026',
        amount: '€350.00',
        status: 'Paid',
        statusColor: UrbinoColors.success,
        date: DateTime(2026, 2, 1),
      ),
      Payment(
        id: '2',
        title: 'Utilities - Jan 2026',
        amount: '€45.20',
        status: 'Paid',
        statusColor: UrbinoColors.success,
        date: DateTime(2026, 1, 15),
      ),
      Payment(
        id: '3',
        title: 'Rent - January 2026',
        amount: '€350.00',
        status: 'Paid',
        statusColor: UrbinoColors.success,
        date: DateTime(2026, 1, 1),
      ),
      Payment(
        id: '4',
        title: 'Deposit Installment',
        amount: '€100.00',
        status: 'Pending',
        statusColor: UrbinoColors.warning,
        date: DateTime(2026, 1, 15),
      ),
    ]);
  }

  final List<Payment> _payments = [];

  List<Payment> get payments => List.unmodifiable(_payments);

  void addPayment(Payment payment) {
    _payments.insert(0, payment); // Add to the top
    notifyListeners();
  }

  double getTotalBalance() {
    double total = 0;
    for (var payment in _payments) {
      if (payment.status == 'Pending') {
        // Strip the € symbol and parse
        final amountStr = payment.amount.replaceAll('€', '').trim();
        total += double.tryParse(amountStr) ?? 0.0;
      }
    }
    return total;
  }

  void payAllPending() {
    for (int i = 0; i < _payments.length; i++) {
      if (_payments[i].status == 'Pending') {
        _payments[i] = _payments[i].copyWith(
          status: 'Paid',
          statusColor: UrbinoColors.success,
        );
      }
    }
    notifyListeners();
  }
}
