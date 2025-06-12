import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ManualAddressWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<Map<String, dynamic>> suggestions;
  final Function(Map<String, dynamic>) onAddressSelected;

  const ManualAddressWidget({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.onAddressSelected,
  });

  @override
  State<ManualAddressWidget> createState() => _ManualAddressWidgetState();
}

class _ManualAddressWidgetState extends State<ManualAddressWidget> {
  bool _showSuggestions = false;
  List<Map<String, dynamic>> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = widget.suggestions;
  }

  void _filterSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = widget.suggestions;
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _filteredSuggestions = widget.suggestions
          .where((suggestion) =>
              (suggestion["address"] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (suggestion["shortAddress"] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
      _showSuggestions = _filteredSuggestions.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Your Address',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Type your delivery address to find nearby restaurants',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: widget.controller,
          onChanged: _filterSuggestions,
          decoration: InputDecoration(
            hintText: 'Search for your address...',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      _filterSuggestions('');
                    },
                    icon: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
        if (_showSuggestions) ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSuggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.dividerColor,
              ),
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  onTap: () {
                    widget.onAddressSelected(suggestion);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    suggestion["shortAddress"] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    suggestion["address"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
