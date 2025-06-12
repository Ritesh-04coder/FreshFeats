import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LocationMapWidget extends StatelessWidget {
  final String selectedAddress;

  const LocationMapWidget({
    super.key,
    required this.selectedAddress,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final mapHeight = screenHeight * 0.25; // Quarter screen height

    return Container(
      height: mapHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Map placeholder with pattern
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: MapPatternPainter(),
              ),
            ),
            // Map overlay with streets pattern
            Positioned.fill(
              child: CustomPaint(
                painter: StreetsPatternPainter(),
              ),
            ),
            // Location marker
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'restaurant',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Delivery Location',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Address info overlay
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedAddress,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw grid pattern
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StreetsPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 2;

    // Draw some street-like lines
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.7),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.2),
      Offset(size.width, size.height * 0.8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
