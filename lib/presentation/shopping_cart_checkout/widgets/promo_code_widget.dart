import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PromoCodeWidget extends StatefulWidget {
  final Function(String) onApplyPromoCode;
  final String appliedCode;

  const PromoCodeWidget({
    super.key,
    required this.onApplyPromoCode,
    required this.appliedCode,
  });

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _promoController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _promoController.text = widget.appliedCode;
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

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
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_offer',
                      color: AppTheme.primaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.appliedCode.isNotEmpty
                          ? 'Promo Code Applied'
                          : 'Have a Promo Code?',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: widget.appliedCode.isNotEmpty
                            ? AppTheme.successLight
                            : AppTheme.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ],
            ),
          ),
          if (widget.appliedCode.isNotEmpty && !_isExpanded) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.appliedCode.toUpperCase(),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (_isExpanded) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomIconWidget(
                          iconName: 'local_offer',
                          color: AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                      ),
                      suffixIcon: widget.appliedCode.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _promoController.clear();
                                widget.onApplyPromoCode('');
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme.textSecondaryLight,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _promoController.text.isNotEmpty
                      ? () =>
                          widget.onApplyPromoCode(_promoController.text.trim())
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  child: Text('Apply'),
                ),
              ],
            ),

            // Suggested Promo Codes
            const SizedBox(height: 16),
            Text(
              'Available Offers',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 8),
            _buildPromoSuggestion(
              'SAVE10',
              '10% off on orders above \$20',
              () => widget.onApplyPromoCode('SAVE10'),
            ),
            const SizedBox(height: 8),
            _buildPromoSuggestion(
              'FREESHIP',
              'Free delivery on orders above \$30',
              () => widget.onApplyPromoCode('FREESHIP'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPromoSuggestion(
      String code, String description, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dividerLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: AppTheme.primaryLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
