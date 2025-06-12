import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/splash_loading_widget.dart';
import './widgets/splash_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _screenFadeAnimation;

  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  Timer? _timeoutTimer;
  Timer? _navigationTimer;

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    "isAuthenticated": false,
    "hasLocationPermission": false,
    "hasSavedAddresses": false,
    "userId": null,
    "lastKnownLocation": null,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _screenFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
  }

  void _startSplashSequence() {
    // Set timeout for initialization
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (_isInitializing) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Connection timeout. Please check your internet connection.';
          _isInitializing = false;
        });
      }
    });

    // Simulate initialization tasks
    _performInitializationTasks();
  }

  Future<void> _performInitializationTasks() async {
    try {
      // Simulate checking authentication status
      await Future.delayed(const Duration(milliseconds: 800));
      await _checkAuthenticationStatus();

      // Simulate loading location permissions
      await Future.delayed(const Duration(milliseconds: 600));
      await _checkLocationPermissions();

      // Simulate fetching restaurant data cache
      await Future.delayed(const Duration(milliseconds: 700));
      await _loadRestaurantCache();

      // Simulate preparing map services
      await Future.delayed(const Duration(milliseconds: 500));
      await _prepareMapServices();

      // All initialization complete
      setState(() {
        _isInitializing = false;
      });

      // Navigate after a brief delay
      _navigationTimer = Timer(const Duration(milliseconds: 800), () {
        _navigateToNextScreen();
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize app. Please try again.';
        _isInitializing = false;
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    // In real app, this would check stored tokens, user session, etc.
    _mockUserData['isAuthenticated'] = false; // Mock: user not authenticated
  }

  Future<void> _checkLocationPermissions() async {
    // Simulate location permission check
    // In real app, this would check actual device permissions
    _mockUserData['hasLocationPermission'] = false; // Mock: no permission
  }

  Future<void> _loadRestaurantCache() async {
    // Simulate loading cached restaurant data
    // In real app, this would load from local storage or fetch from API
  }

  Future<void> _prepareMapServices() async {
    // Simulate map service initialization
    // In real app, this would initialize Google Maps or Apple Maps
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    _fadeAnimationController.forward().then((_) {
      if (!mounted) return;

      // Navigation logic based on user state
      String nextRoute;

      if (_mockUserData['isAuthenticated'] == true &&
          _mockUserData['hasSavedAddresses'] == true) {
        // Authenticated users with saved addresses go to restaurant browse
        nextRoute = '/restaurant-browse-discovery';
      } else if (_mockUserData['hasLocationPermission'] == false) {
        // New users or users without location permission see onboarding
        nextRoute = '/location-permission-setup';
      } else {
        // Default to restaurant browse for other cases
        nextRoute = '/restaurant-browse-discovery';
      }

      Navigator.pushReplacementNamed(context, nextRoute);
    });
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _isInitializing = true;
    });

    _timeoutTimer?.cancel();
    _navigationTimer?.cancel();

    _startSplashSequence();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    _timeoutTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: FadeTransition(
          opacity: _screenFadeAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.primaryColor,
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                  AppTheme.primaryVariantLight,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo Section
                  AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: SplashLogoWidget(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  // App Name
                  FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Text(
                      'FoodTracker',
                      style:
                          AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Text(
                      'Delicious food, delivered fast',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Loading or Error Section
                  _hasError ? _buildErrorSection() : _buildLoadingSection(),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        SplashLoadingWidget(isLoading: _isInitializing),
        const SizedBox(height: 16),
        AnimatedOpacity(
          opacity: _isInitializing ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            'Preparing your food experience...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorSection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: Colors.white,
          size: 48,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.lightTheme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            'Retry',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
