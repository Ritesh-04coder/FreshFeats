import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  String _selectedCuisine = 'All';
  RangeValues _deliveryTimeRange = const RangeValues(15, 60);
  double _minOrder = 0;
  double _minRating = 0;
  bool _freeDeliveryOnly = false;
  bool _promosOnly = false;

  final List<String> _cuisineTypes = [
    'All',
    'Italian',
    'Chinese',
    'Japanese',
    'Mexican',
    'Indian',
    'Thai',
    'American',
    'Healthy'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCuisineTypeSection(),
                  const SizedBox(height: 24),
                  _buildDeliveryTimeSection(),
                  const SizedBox(height: 24),
                  _buildMinimumOrderSection(),
                  const SizedBox(height: 24),
                  _buildRatingSection(),
                  const SizedBox(height: 24),
                  _buildToggleSection(),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Filter Restaurants',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCuisineTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuisine Type',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _cuisineTypes.map((cuisine) {
            final isSelected = _selectedCuisine == cuisine;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCuisine = cuisine;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Text(
                  cuisine,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDeliveryTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Time',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_deliveryTimeRange.start.round()} - ${_deliveryTimeRange.end.round()} minutes',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        RangeSlider(
          values: _deliveryTimeRange,
          min: 10,
          max: 90,
          divisions: 16,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          inactiveColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          onChanged: (values) {
            setState(() {
              _deliveryTimeRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMinimumOrderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Order',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${_minOrder.round()}',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          value: _minOrder,
          min: 0,
          max: 50,
          divisions: 10,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
          inactiveColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          onChanged: (value) {
            setState(() {
              _minOrder = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [1, 2, 3, 4, 5].map((rating) {
            final isSelected = _minRating >= rating;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _minRating = rating.toDouble();
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CustomIconWidget(
                  iconName: isSelected ? 'star' : 'star_border',
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.outline,
                  size: 32,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Free Delivery Only',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            Switch(
              value: _freeDeliveryOnly,
              onChanged: (value) {
                setState(() {
                  _freeDeliveryOnly = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Promotions Only',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            Switch(
              value: _promosOnly,
              onChanged: (value) {
                setState(() {
                  _promosOnly = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedCuisine = 'All';
      _deliveryTimeRange = const RangeValues(15, 60);
      _minOrder = 0;
      _minRating = 0;
      _freeDeliveryOnly = false;
      _promosOnly = false;
    });
  }

  void _applyFilters() {
    final filters = {
      'cuisine': _selectedCuisine,
      'deliveryTimeMin': _deliveryTimeRange.start,
      'deliveryTimeMax': _deliveryTimeRange.end,
      'minOrder': _minOrder,
      'minRating': _minRating,
      'freeDeliveryOnly': _freeDeliveryOnly,
      'promosOnly': _promosOnly,
    };

    widget.onFiltersApplied(filters);
  }
}
