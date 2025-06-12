import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/location_permission_setup/location_permission_setup.dart';
import '../presentation/restaurant_browse_discovery/restaurant_browse_discovery.dart';
import '../presentation/restaurant_detail_menu/restaurant_detail_menu.dart';
import '../presentation/order_tracking_status/order_tracking_status.dart';
import '../presentation/shopping_cart_checkout/shopping_cart_checkout.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String locationPermissionSetup = '/location-permission-setup';
  static const String restaurantBrowseDiscovery =
      '/restaurant-browse-discovery';
  static const String restaurantDetailMenu = '/restaurant-detail-menu';
  static const String shoppingCartCheckout = '/shopping-cart-checkout';
  static const String orderTrackingStatus = '/order-tracking-status';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    locationPermissionSetup: (context) => const LocationPermissionSetup(),
    restaurantBrowseDiscovery: (context) => const RestaurantBrowseDiscovery(),
    restaurantDetailMenu: (context) => const RestaurantDetailMenu(),
    shoppingCartCheckout: (context) => const ShoppingCartCheckout(),
    orderTrackingStatus: (context) => const OrderTrackingStatus(),
  };
}
