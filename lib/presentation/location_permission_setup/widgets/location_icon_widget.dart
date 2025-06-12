import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LocationIconWidget extends StatelessWidget {
  final AnimationController radarController;
  final AnimationController pulseController;
  final bool isLoading;

  const LocationIconWidget({
    super.key,
    required this.radarController,
    required this.pulseController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated radar rings
            if (!isLoading) ...[
              AnimatedBuilder(
                animation: radarController,
                builder: (context, child) {
                  return Container(
                    width: 200 * radarController.value,
                    height: 200 * radarController.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor.withValues(
                            alpha: 0.3 * (1 - radarController.value)),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: radarController,
                builder: (context, child) {
                  final delayedValue =
                      (radarController.value - 0.3).clamp(0.0, 1.0);
                  return Container(
                    width: 200 * delayedValue,
                    height: 200 * delayedValue,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.2 * (1 - delayedValue)),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            ],
            // Pulsing background circle
            AnimatedBuilder(
              animation: pulseController,
              builder: (context, child) {
                return Container(
                  width: 120 + (20 * pulseController.value),
                  height: 120 + (20 * pulseController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  ),
                );
              },
            ),
            // Main location icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lightTheme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    )
                  : CustomIconWidget(
                      iconName: 'location_on',
                      color: Colors.white,
                      size: 48,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
