import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MenuItemBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>, int, List<String>) onAddToCart;

  const MenuItemBottomSheetWidget({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  State<MenuItemBottomSheetWidget> createState() =>
      _MenuItemBottomSheetWidgetState();
}

class _MenuItemBottomSheetWidgetState extends State<MenuItemBottomSheetWidget> {
  int _quantity = 1;
  String _selectedSize = 'Regular';
  String _selectedSpiceLevel = 'Mild';
  final List<String> _selectedAddOns = [];

  final List<String> _sizes = ['Small', 'Regular', 'Large'];
  final List<String> _spiceLevels = ['Mild', 'Medium', 'Hot'];

  @override
  Widget build(BuildContext context) {
    final double basePrice = (widget.item['price'] as num).toDouble();
    final double sizeMultiplier = _selectedSize == 'Small'
        ? 0.8
        : _selectedSize == 'Large'
            ? 1.3
            : 1.0;
    final double addOnPrice = _selectedAddOns.length * 2.0;
    final double totalPrice =
        (basePrice * sizeMultiplier + addOnPrice) * _quantity;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Item Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: widget.item['image'] as String,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Item Name and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item['name'] as String,
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${basePrice.toStringAsFixed(2)}',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Description
                  Text(
                    widget.item['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Size Selection
                  if (widget.item['customizable'] as bool) ...[
                    Text(
                      'Size',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: _sizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                right: size != _sizes.last ? 8 : 0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedSize = size;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.1)
                                      : AppTheme.lightTheme.colorScheme.surface,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  size,
                                  textAlign: TextAlign.center,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),

                    // Spice Level
                    if (widget.item['spiceLevel'] != 'none') ...[
                      Text(
                        'Spice Level',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: _spiceLevels.map((level) {
                          final isSelected = _selectedSpiceLevel == level;
                          return Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: level != _spiceLevels.last ? 8 : 0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedSpiceLevel = level;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                            .withValues(alpha: 0.1)
                                        : AppTheme
                                            .lightTheme.colorScheme.surface,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme
                                              .lightTheme.colorScheme.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'local_fire_department',
                                        color: level == 'Hot'
                                            ? AppTheme
                                                .lightTheme.colorScheme.error
                                            : level == 'Medium'
                                                ? AppTheme.lightTheme
                                                    .colorScheme.tertiary
                                                : AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        level,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: isSelected
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : AppTheme.lightTheme.colorScheme
                                                  .onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24),
                    ],

                    // Add-ons
                    if ((widget.item['addOns'] as List).isNotEmpty) ...[
                      Text(
                        'Add-ons (\$2.00 each)',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      ...(widget.item['addOns'] as List).map((addOn) {
                        final isSelected = _selectedAddOns.contains(addOn);
                        return CheckboxListTile(
                          title: Text(
                            addOn as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            '+\$2.00',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedAddOns.add(addOn);
                              } else {
                                _selectedAddOns.remove(addOn);
                              }
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        );
                      }),
                      SizedBox(height: 24),
                    ],
                  ],

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _quantity > 1
                                ? () {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                : null,
                            icon: CustomIconWidget(
                              iconName: 'remove',
                              color: _quantity > 1
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_quantity',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'add',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onAddToCart(
                            widget.item, _quantity, _selectedAddOns);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add to Cart',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
