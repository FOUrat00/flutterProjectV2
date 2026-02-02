import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../services/payment_manager.dart';
import 'package:quickalert/quickalert.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final PaymentManager _paymentManager = PaymentManager();

  @override
  void initState() {
    super.initState();
    _paymentManager.addListener(_onPaymentsChanged);
  }

  @override
  void dispose() {
    _paymentManager.removeListener(_onPaymentsChanged);
    super.dispose();
  }

  void _onPaymentsChanged() {
    if (mounted) setState(() {});
  }

  void _handlePayment() {
    final balance = _paymentManager.getTotalBalance();
    if (balance <= 0) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        text: "You have no outstanding balance.",
        confirmBtnColor: UrbinoColors.darkBlue,
      );
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Confirm Payment",
      text: "Total Amount: €${balance.toStringAsFixed(2)}",
      confirmBtnText: "Pay",
      cancelBtnText: "Cancel",
      confirmBtnColor: UrbinoColors.darkBlue,
      onConfirmBtnTap: () {
        Navigator.pop(context); // Close confirm dialog
        _paymentManager.payAllPending();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Success",
          text: "Payment completed successfully!",
          confirmBtnColor: UrbinoColors.success,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💳 Payments & Factures'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: UrbinoGradients.primaryButton(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(context),
            const SizedBox(height: 32),
            Text('Recent Factures', style: UrbinoTextStyles.heading2(context)),
            const SizedBox(height: 16),
            ..._paymentManager.payments.map((payment) => _factureItem(
                  context,
                  payment.title,
                  payment.amount,
                  payment.status,
                  payment.statusColor,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: UrbinoGradients.primaryButton(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [UrbinoShadows.blueGlow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Outstanding',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text('€${_paymentManager.getTotalBalance().toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UrbinoColors.gold,
                    foregroundColor: UrbinoColors.darkBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('PAY NOW'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _factureItem(BuildContext context, String title, String amount,
      String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [UrbinoShadows.soft],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: UrbinoColors.paleBlue, shape: BoxShape.circle),
            child: const Icon(Icons.description_outlined,
                color: UrbinoColors.darkBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: UrbinoTextStyles.bodyTextBold(context)),
                Text(status,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: UrbinoTextStyles.bodyTextBold(context)),
              const Icon(Icons.download, size: 16, color: UrbinoColors.gold),
            ],
          ),
        ],
      ),
    );
  }
}
