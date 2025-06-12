import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/location_buttons_widget.dart';
import './widgets/location_content_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/location_icon_widget.dart';
import './widgets/location_map_widget.dart';
import './widgets/manual_address_widget.dart';

class LocationPermissionSetup extends StatefulWidget {
  const LocationPermissionSetup({super.key});

  @override
  State<LocationPermissionSetup> createState() =>
      _LocationPermissionSetupState();
}

class _LocationPermissionSetupState extends State<LocationPermissionSetup>
    with TickerProviderStateMixin {
  bool _isManualEntry = false;
  bool _isLoading = false;
  bool _showMap = false;
  String _selectedAddress = '';
  String _errorMessage = '';
  late AnimationController _radarController;
  late AnimationController _pulseController;
  final TextEditingController _addressController = TextEditingController();

  // Mock address suggestions
  final List<Map<String, dynamic>> _addressSuggestions = [
    {
      "id": 1,
      "address": "123 Main Street, Downtown, New York, NY 10001",
      "shortAddress": "123 Main Street",
      "latitude": 40.7128,
      "longitude": -74.0060,
    },
    {
      "id": 2,
      "address": "456 Oak Avenue, Midtown, New York, NY 10018",
      "shortAddress": "456 Oak Avenue",
      "latitude": 40.7589,
      "longitude": -73.9851,
    },
    {
      "id": 3,
      "address": "789 Pine Road, Upper East Side, New York, NY 10021",
      "shortAddress": "789 Pine Road",
      "latitude": 40.7736,
      "longitude": -73.9566,
    },
  ];

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSkip() {
    Navigator.pushReplacementNamed(context, '/restaurant-browse-discovery');
  }

  void _handleEnableLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate GPS acquisition
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Simulate successful location acquisition
      HapticFeedback.lightImpact();
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/restaurant-browse-discovery');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to get your location. Please try again or enter manually.';
      });
    }
  }

  void _handleManualEntry() {
    setState(() {
      _isManualEntry = true;
      _errorMessage = '';
    });
  }

  void _handleAddressSelection(Map<String, dynamic> address) {
    setState(() {
      _selectedAddress = address["address"] as String;
      _addressController.text = address["shortAddress"] as String;
      _showMap = true;
    });
  }

  void _handleConfirmLocation() {
    if (_selectedAddress.isNotEmpty) {
      HapticFeedback.lightImpact();
      Navigator.pushReplacementNamed(context, '/restaurant-browse-discovery');
    }
  }

  void _handleBackNavigation() {
    if (_isManualEntry) {
      setState(() {
        _isManualEntry = false;
        _showMap = false;
        _selectedAddress = '';
        _addressController.clear();
      });
    } else {
      Navigator.pushReplacementNamed(context, '/splash-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    LocationHeaderWidget(
                      onSkip: _handleSkip,
                      onBack: _isManualEntry ? _handleBackNavigation : null,
                    ),
                    const SizedBox(height: 40),
                    if (!_isManualEntry) ...[
                      LocationIconWidget(
                        radarController: _radarController,
                        pulseController: _pulseController,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 32),
                      LocationContentWidget(
                        isLoading: _isLoading,
                        errorMessage: _errorMessage,
                      ),
                      const SizedBox(height: 40),
                      LocationButtonsWidget(
                        isLoading: _isLoading,
                        onEnableLocation: _handleEnableLocation,
                        onManualEntry: _handleManualEntry,
                      ),
                    ] else ...[
                      ManualAddressWidget(
                        controller: _addressController,
                        suggestions: _addressSuggestions,
                        onAddressSelected: _handleAddressSelection,
                      ),
                      if (_showMap) ...[
                        const SizedBox(height: 24),
                        LocationMapWidget(
                          selectedAddress: _selectedAddress,
                        ),
                      ],
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            if (_showMap && _selectedAddress.isNotEmpty)
              Positioned(
                bottom: 24,
                right: 24,
                child: FloatingActionButton.extended(
                  onPressed: _handleConfirmLocation,
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  icon: CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text(
                    'Confirm Location',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
