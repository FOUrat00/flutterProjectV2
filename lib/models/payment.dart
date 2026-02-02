import 'package:flutter/material.dart';

class Payment {
  final String id;
  final String title;
  final String amount;
  final String status;
  final Color statusColor;
  final DateTime date;

  Payment({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.date,
  });

  Payment copyWith({
    String? id,
    String? title,
    String? amount,
    String? status,
    Color? statusColor,
    DateTime? date,
  }) {
    return Payment(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      date: date ?? this.date,
    );
  }
}
