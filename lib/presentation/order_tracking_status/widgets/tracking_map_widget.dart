import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrackingMapWidget extends StatelessWidget {
  final String restaurantName;
  final String deliveryAddress;
  final Map<String, double> driverLocation;
  final bool isLoading;

  const TrackingMapWidget({
    super.key,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.driverLocation,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Map Placeholder (In real app, this would be Google Maps or MapKit)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: CustomImageWidget(
                imageUrl:
                    "https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&h=600&fit=crop",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Map Markers Overlay
            _buildMapMarkers(),

            // Loading Overlay
            if (isLoading)
              Container(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Updating location...',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

            // Map Controls
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  _buildMapControlButton(
                    icon: 'my_location',
                    onTap: _centerOnDriver,
                  ),
                  SizedBox(height: 1.h),
                  _buildMapControlButton(
                    icon: 'zoom_in',
                    onTap: _zoomIn,
                  ),
                  SizedBox(height: 1.h),
                  _buildMapControlButton(
                    icon: 'zoom_out',
                    onTap: _zoomOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarkers() {
    return Stack(
      children: [
        // Restaurant Marker
        Positioned(
          top: 15.h,
          left: 20.w,
          child: _buildMarker(
            icon: 'restaurant',
            color: AppTheme.lightTheme.colorScheme.secondary,
            label: 'Restaurant',
          ),
        ),

        // Driver Marker
        Positioned(
          top: 25.h,
          left: 50.w,
          child: _buildMarker(
            icon: 'directions_car',
            color: AppTheme.lightTheme.colorScheme.primary,
            label: 'Driver',
            isAnimated: true,
          ),
        ),

        // Delivery Address Marker
        Positioned(
          top: 35.h,
          left: 75.w,
          child: _buildMarker(
            icon: 'home',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            label: 'Your Location',
          ),
        ),
      ],
    );
  }

  Widget _buildMarker({
    required String icon,
    required Color color,
    required String label,
    bool isAnimated = false,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: isAnimated ? 48 : 40,
          height: isAnimated ? 48 : 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: isAnimated ? 4 : 2,
              ),
            ],
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: isAnimated ? 24 : 20,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControlButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }

  void _centerOnDriver() {
    // In real implementation, this would center the map on driver location
  }

  void _zoomIn() {
    // In real implementation, this would zoom in the map
  }

  void _zoomOut() {
    // In real implementation, this would zoom out the map
  }
}
