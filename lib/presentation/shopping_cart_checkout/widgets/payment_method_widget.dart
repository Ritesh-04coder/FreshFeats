import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final String selectedMethodId;
  final Function(String) onMethodSelected;

  const PaymentMethodWidget({
    super.key,
    required this.paymentMethods,
    required this.selectedMethodId,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: () => _showAddPaymentMethod(context),
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.primaryLight,
                  size: 16,
                ),
                label: Text('Add New'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Payment Methods List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentMethods.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final method = paymentMethods[index];
              final isSelected = selectedMethodId == method['id'];

              return InkWell(
                onTap: () => onMethodSelected(method['id'] as String),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.dividerLight,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? AppTheme.primaryLight.withValues(alpha: 0.05)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: method['icon'] as String,
                          color: AppTheme.primaryLight,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          method['title'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.primaryLight,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddPaymentMethod(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Payment Method',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // Credit/Debit Card Option
            ListTile(
              leading: CustomIconWidget(
                iconName: 'credit_card',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Credit/Debit Card'),
              subtitle: Text('Add a new card'),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.textSecondaryLight,
                size: 16,
              ),
              onTap: () {
                Navigator.pop(context);
                _showAddCardForm(context);
              },
            ),

            // Digital Wallet Options
            ListTile(
              leading: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Digital Wallet'),
              subtitle: Text('PayPal, Apple Pay, Google Pay'),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.textSecondaryLight,
                size: 16,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle digital wallet setup
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardForm(BuildContext context) {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Card',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle card addition
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Card added successfully'),
                          backgroundColor: AppTheme.successLight,
                        ),
                      );
                    },
                    child: Text('Add Card'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
