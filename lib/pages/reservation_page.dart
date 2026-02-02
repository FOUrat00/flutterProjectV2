import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/property.dart';
import '../services/invoice_service.dart';
import '../services/payment_manager.dart';
import '../models/payment.dart';
import '../services/notification_manager.dart';
import '../models/notification_item.dart';

class ReservationPage extends StatefulWidget {
  final Property property;

  const ReservationPage({Key? key, required this.property}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _guestsController =
      TextEditingController(text: '1');
  DateTimeRange? _selectedRange;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: UrbinoColors.darkBlue),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      setState(() => _selectedRange = result);
    }
  }

  void _submitReservation() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRange == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner les dates')),
        );
        return;
      }

      final int nights = _selectedRange!.duration.inDays;
      // Assuming price is monthly, calculating pro-rated amount
      final double totalPrice = (widget.property.price / 30) * nights;

      // Add payment to global state
      PaymentManager().addPayment(Payment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Booking: ${widget.property.title}',
        amount: '€${totalPrice.toStringAsFixed(2)}',
        status: 'Pending',
        statusColor: UrbinoColors.warning,
        date: DateTime.now(),
      ));

      // Trigger Notification
      NotificationManager().addNotification(NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Reservation Confirmed',
        body:
            'Please complete your payment of €${totalPrice.toStringAsFixed(2)} for ${widget.property.title}.',
        timestamp: DateTime.now(),
        type: NotificationType.payment,
      ));

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: UrbinoColors.success),
              const SizedBox(width: 10),
              const Text('Réservation confirmée'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Merci ${_nameController.text}!',
                  style: UrbinoTextStyles.bodyTextBold(context)),
              const SizedBox(height: 8),
              Text(
                'Votre séjour est réservé du ${_selectedRange!.start.day}/${_selectedRange!.start.month} au ${_selectedRange!.end.day}/${_selectedRange!.end.month}.',
                style: UrbinoTextStyles.bodyText(context),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total estimé:',
                        style: UrbinoTextStyles.smallText(context)),
                    Text('€${totalPrice.toStringAsFixed(2)}',
                        style: UrbinoTextStyles.heading2(context)
                            .copyWith(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('Imprimer Facture'),
              onPressed: () {
                InvoiceService.generateAndPrintInvoice(
                  property: widget.property,
                  guestName: _nameController.text,
                  guestEmail: _emailController.text,
                  numberOfGuests: int.parse(_guestsController.text),
                  startDate: _selectedRange!.start,
                  endDate: _selectedRange!.end,
                  totalPrice: totalPrice,
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: UrbinoColors.darkBlue),
              child: const Text('Terminer'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.dark
                  ? UrbinoColors.gold
                  : UrbinoColors.darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Réservation',
            style: UrbinoTextStyles.heading2(context).copyWith(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: UrbinoColors.gold.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(widget.property.images.first,
                        height: 70, width: 100, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.property.title,
                            style: UrbinoTextStyles.bodyTextBold(context)),
                        const SizedBox(height: 6),
                        Text(widget.property.location,
                            style: UrbinoTextStyles.smallText(context)),
                        const SizedBox(height: 6),
                        Text('€${widget.property.price}',
                            style: UrbinoTextStyles.heading2(context).copyWith(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? UrbinoColors.gold
                                    : UrbinoColors.darkBlue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vos informations',
                      style: UrbinoTextStyles.heading2(context)
                          .copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nom complet'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Entrez votre nom'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'Entrez un email valide'
                        : null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _guestsController,
                          decoration: const InputDecoration(
                              labelText: 'Nombre de personnes'),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null ||
                                  int.tryParse(v) == null ||
                                  int.parse(v) < 1)
                              ? 'Entrez un nombre valide'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: _pickDateRange,
                          child: InputDecorator(
                            decoration:
                                const InputDecoration(labelText: 'Dates'),
                            child: Text(
                              _selectedRange == null
                                  ? 'Sélectionner'
                                  : '${_selectedRange!.start.day}/${_selectedRange!.start.month}/${_selectedRange!.start.year} - ${_selectedRange!.end.day}/${_selectedRange!.end.month}/${_selectedRange!.end.year}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Demandes spéciales (optionnel)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitReservation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UrbinoColors.darkBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Confirmer la réservation'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
