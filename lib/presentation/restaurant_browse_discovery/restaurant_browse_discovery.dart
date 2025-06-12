import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/restaurant_card_widget.dart';

// lib/presentation/restaurant_browse_discovery/restaurant_browse_discovery.dart

class RestaurantBrowseDiscovery extends StatefulWidget {
  const RestaurantBrowseDiscovery({super.key});

  @override
  State<RestaurantBrowseDiscovery> createState() =>
      _RestaurantBrowseDiscoveryState();
}

class _RestaurantBrowseDiscoveryState extends State<RestaurantBrowseDiscovery>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final RestaurantService _restaurantService = RestaurantService();

  int _currentTabIndex = 0;
  String _selectedCategory = 'All';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _hasMoreData = true;

  final List<String> _categories = [
    'All',
    'Italian',
    'Chinese',
    'Healthy',
    'American',
    'Japanese',
    'Mexican',
    'Indian',
    'Thai'
  ];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadRestaurants() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final restaurants = await _restaurantService.getRestaurantsWithFavorites(
        cuisineType: _selectedCategory == 'All' ? null : _selectedCategory,
        searchQuery:
            _searchController.text.isEmpty ? null : _searchController.text,
        limit: _itemsPerPage,
        offset: 0,
      );

      if (mounted) {
        setState(() {
          _restaurants = restaurants;
          _filteredRestaurants = List.from(_restaurants);
          _currentPage = 0;
          _hasMoreData = restaurants.length == _itemsPerPage;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load restaurants: $error');
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreRestaurants();
    }
  }

  void _loadMoreRestaurants() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final moreRestaurants =
          await _restaurantService.getRestaurantsWithFavorites(
        cuisineType: _selectedCategory == 'All' ? null : _selectedCategory,
        searchQuery:
            _searchController.text.isEmpty ? null : _searchController.text,
        limit: _itemsPerPage,
        offset: nextPage * _itemsPerPage,
      );

      if (mounted) {
        setState(() {
          _restaurants.addAll(moreRestaurants);
          _filteredRestaurants = List.from(_restaurants);
          _currentPage = nextPage;
          _hasMoreData = moreRestaurants.length == _itemsPerPage;
          _isLoadingMore = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        _showErrorSnackBar('Failed to load more restaurants: $error');
      }
    }
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    _loadRestaurants();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadRestaurants();
  }

  void _onSearchChanged(String query) {
    // Debounce search to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        _loadRestaurants();
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onFiltersApplied: (filters) {
          // Apply filters logic here
          Navigator.pop(context);
          _loadRestaurants();
        },
      ),
    );
  }

  void _onRestaurantTap(Restaurant restaurant) {
    Navigator.pushNamed(context, '/restaurant-detail-menu',
        arguments: restaurant);
  }

  void _onRestaurantLongPress(Restaurant restaurant) {
    HapticFeedback.mediumImpact();
    _showQuickActions(restaurant);
  }

  void _showQuickActions(Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              restaurant.name,
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: CustomIconWidget(
                iconName:
                    restaurant.isFavorite ? 'favorite' : 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(restaurant.isFavorite
                  ? 'Remove from Favorites'
                  : 'Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                _toggleFavorite(restaurant);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'restaurant_menu',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('View Menu'),
              onTap: () {
                Navigator.pop(context);
                _onRestaurantTap(restaurant);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(Restaurant restaurant) async {
    try {
      if (restaurant.isFavorite) {
        await _restaurantService.removeFromFavorites(restaurant.id);
      } else {
        await _restaurantService.addToFavorites(restaurant.id);
      }

      // Update local state
      setState(() {
        final index = _restaurants.indexWhere((r) => r.id == restaurant.id);
        if (index != -1) {
          _restaurants[index] =
              restaurant.copyWith(isFavorite: !restaurant.isFavorite);
          _filteredRestaurants = List.from(_restaurants);
        }
      });
    } catch (error) {
      _showErrorSnackBar('Failed to update favorites: $error');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryChips(),
            Expanded(
              child: _buildRestaurantList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingSearchButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search restaurants or cuisines',
                      prefixIcon: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showFilterBottomSheet,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Delivering to Downtown',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CategoryChipWidget(
              label: category,
              isSelected: _selectedCategory == category,
              onTap: () => _onCategorySelected(category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantList() {
    if (_isLoading && _restaurants.isEmpty) {
      return _buildLoadingState();
    }

    if (_filteredRestaurants.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _filteredRestaurants.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredRestaurants.length) {
            return _buildLoadingMoreIndicator();
          }

          final restaurant = _filteredRestaurants[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RestaurantCardWidget(
              restaurant: _convertToMap(restaurant),
              onTap: () => _onRestaurantTap(restaurant),
              onLongPress: () => _onRestaurantLongPress(restaurant),
              onFavoriteToggle: () => _toggleFavorite(restaurant),
            ),
          );
        },
      ),
    );
  }

  // Convert Restaurant model to Map for widget compatibility
  Map<String, dynamic> _convertToMap(Restaurant restaurant) {
    return {
      "id": restaurant.id,
      "name": restaurant.name,
      "cuisine": restaurant.cuisineType,
      "rating": restaurant.rating,
      "deliveryTime": restaurant.deliveryTimeRange,
      "deliveryFee": restaurant.deliveryFeeFormatted,
      "image": restaurant.imageUrl ??
          "https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": restaurant.isFavorite,
      "hasPromo": restaurant.hasPromo,
      "promoText": restaurant.promoText,
      "minOrder": restaurant.minOrderFormatted,
      "distance": restaurant.distance != null
          ? "${restaurant.distance!.toStringAsFixed(1)} km"
          : "N/A"
    };
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'restaurant',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No restaurants nearby',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your location or search criteria',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/location-permission-setup');
            },
            child: const Text('Change Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });

        switch (index) {
          case 0:
            // Already on Browse tab
            break;
          case 1:
            Navigator.pushNamed(context, '/order-tracking-status');
            break;
          case 2:
            // Navigate to profile (not implemented)
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'explore',
            color: _currentTabIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'receipt_long',
            color: _currentTabIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentTabIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingSearchButton() {
    return FloatingActionButton(
      onPressed: () {
        // Focus on search field
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: CustomIconWidget(
        iconName: 'search',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
    );
  }
}
