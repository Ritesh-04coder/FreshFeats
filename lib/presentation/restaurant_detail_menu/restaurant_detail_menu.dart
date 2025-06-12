import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/cart_summary_bar_widget.dart';
import './widgets/menu_item_bottom_sheet_widget.dart';
import './widgets/menu_item_card_widget.dart';
import './widgets/restaurant_header_widget.dart';

class RestaurantDetailMenu extends StatefulWidget {
  const RestaurantDetailMenu({super.key});

  @override
  State<RestaurantDetailMenu> createState() => _RestaurantDetailMenuState();
}

class _RestaurantDetailMenuState extends State<RestaurantDetailMenu>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isFavorite = false;
  bool _isHeaderCollapsed = false;
  final List<Map<String, dynamic>> _cartItems = [];
  double _cartTotal = 0.0;

  // Mock restaurant data
  final Map<String, dynamic> restaurantData = {
    "id": 1,
    "name": "Bella Vista Italian Kitchen",
    "image":
        "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "rating": 4.5,
    "reviewCount": 1250,
    "deliveryTime": "25-35 min",
    "minimumOrder": "\$15.00",
    "cuisine": "Italian, Mediterranean",
    "address": "123 Main Street, Downtown",
    "phone": "+1 (555) 123-4567",
    "hours": "11:00 AM - 10:00 PM",
    "description":
        "Authentic Italian cuisine with fresh ingredients and traditional recipes passed down through generations."
  };

  // Mock menu data
  final List<Map<String, dynamic>> menuCategories = [
    {
      "category": "Appetizers",
      "items": [
        {
          "id": 1,
          "name": "Bruschetta Classica",
          "description":
              "Toasted bread topped with fresh tomatoes, basil, garlic, and extra virgin olive oil",
          "price": 8.99,
          "image":
              "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "customizable": true,
          "spiceLevel": "mild",
          "addOns": ["Extra Cheese", "Olives", "Prosciutto"]
        },
        {
          "id": 2,
          "name": "Antipasto Platter",
          "description":
              "Selection of cured meats, cheeses, olives, and marinated vegetables",
          "price": 16.99,
          "image":
              "https://images.unsplash.com/photo-1544025162-d76694265947?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "customizable": true,
          "spiceLevel": "mild",
          "addOns": ["Extra Meat", "Extra Cheese", "Bread"]
        }
      ]
    },
    {
      "category": "Pasta",
      "items": [
        {
          "id": 3,
          "name": "Spaghetti Carbonara",
          "description":
              "Classic Roman pasta with eggs, cheese, pancetta, and black pepper",
          "price": 18.99,
          "image":
              "https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "customizable": true,
          "spiceLevel": "mild",
          "addOns": ["Extra Pancetta", "Parmesan", "Truffle Oil"]
        },
        {
          "id": 4,
          "name": "Penne Arrabbiata",
          "description":
              "Spicy tomato sauce with garlic, red chilies, and fresh herbs",
          "price": 16.99,
          "image":
              "https://images.unsplash.com/photo-1563379091339-03246963d51a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "customizable": true,
          "spiceLevel": "hot",
          "addOns": ["Extra Spice", "Chicken", "Vegetables"]
        }
      ]
    },
    {
      "category": "Pizza",
      "items": [
        {
          "id": 5,
          "name": "Margherita Pizza",
          "description":
              "Fresh mozzarella, tomato sauce, basil, and extra virgin olive oil",
          "price": 14.99,
          "image":
              "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "customizable": true,
          "spiceLevel": "mild",
          "addOns": ["Extra Cheese", "Pepperoni", "Mushrooms", "Olives"]
        },
        {
          "id": 6,
          "name": "Quattro Stagioni",
          "description":
              "Four seasons pizza with artichokes, ham, mushrooms, and olives",
          "price": 19.99,
          "image":
              "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "customizable": true,
          "spiceLevel": "mild",
          "addOns": ["Extra Toppings", "Cheese", "Prosciutto"]
        }
      ]
    },
    {
      "category": "Desserts",
      "items": [
        {
          "id": 7,
          "name": "Tiramisu",
          "description":
              "Classic Italian dessert with coffee-soaked ladyfingers and mascarpone",
          "price": 7.99,
          "image":
              "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "customizable": false,
          "spiceLevel": "none",
          "addOns": []
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool isCollapsed =
        _scrollController.hasClients && _scrollController.offset > 200;
    if (isCollapsed != _isHeaderCollapsed) {
      setState(() {
        _isHeaderCollapsed = isCollapsed;
      });
    }
  }

  void _addToCart(
      Map<String, dynamic> item, int quantity, List<String> selectedAddOns) {
    setState(() {
      double itemPrice = (item['price'] as num).toDouble();
      double addOnPrice = selectedAddOns.length * 2.0; // \$2 per add-on
      double totalItemPrice = (itemPrice + addOnPrice) * quantity;

      _cartItems.add({
        'item': item,
        'quantity': quantity,
        'addOns': selectedAddOns,
        'totalPrice': totalItemPrice,
      });

      _cartTotal += totalItemPrice;
    });
  }

  void _showMenuItemBottomSheet(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MenuItemBottomSheetWidget(
        item: item,
        onAddToCart: _addToCart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  leading: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: CustomIconWidget(
                          iconName:
                              _isFavorite ? 'favorite' : 'favorite_border',
                          color: _isFavorite
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: RestaurantHeaderWidget(
                      restaurant: restaurantData,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Menu'),
                        Tab(text: 'Reviews'),
                        Tab(text: 'Info'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildMenuTab(),
                _buildReviewsTab(),
                _buildInfoTab(),
              ],
            ),
          ),
          if (_cartItems.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CartSummaryBarWidget(
                itemCount: _cartItems.length,
                total: _cartTotal,
                onViewCart: () {
                  Navigator.pushNamed(context, '/shopping-cart-checkout');
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: _cartItems.isNotEmpty ? 100 : 16),
        itemCount: menuCategories.length,
        itemBuilder: (context, index) {
          final category = menuCategories[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: AppTheme.lightTheme.colorScheme.surface,
                child: Text(
                  category['category'] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: (category['items'] as List).length,
                itemBuilder: (context, itemIndex) {
                  final item = (category['items'] as List)[itemIndex];
                  return MenuItemCardWidget(
                    item: item,
                    onTap: () => _showMenuItemBottomSheet(item),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewsTab() {
    final List<Map<String, dynamic>> reviews = [
      {
        "id": 1,
        "userName": "Sarah Johnson",
        "rating": 5,
        "comment":
            "Amazing food and great service! The pasta was perfectly cooked and the atmosphere was wonderful.",
        "date": "2 days ago",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
      },
      {
        "id": 2,
        "userName": "Mike Chen",
        "rating": 4,
        "comment":
            "Good Italian food, though the wait time was a bit longer than expected. Overall satisfied with the experience.",
        "date": "1 week ago",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
      },
    ];

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '4.5',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < 4 ? 'star' : 'star_border',
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              size: 20,
                            );
                          }),
                        ),
                        Text(
                          '1,250 reviews',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        ...reviews.map((review) => Card(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(review['avatar'] as String),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['userName'] as String,
                                style:
                                    AppTheme.lightTheme.textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    return CustomIconWidget(
                                      iconName:
                                          index < (review['rating'] as int)
                                              ? 'star'
                                              : 'star_border',
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                      size: 16,
                                    );
                                  }),
                                  SizedBox(width: 8),
                                  Text(
                                    review['date'] as String,
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      review['comment'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Restaurant Information',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                _buildInfoRow('location_on', 'Address',
                    restaurantData['address'] as String),
                SizedBox(height: 12),
                _buildInfoRow(
                    'phone', 'Phone', restaurantData['phone'] as String),
                SizedBox(height: 12),
                _buildInfoRow(
                    'access_time', 'Hours', restaurantData['hours'] as String),
                SizedBox(height: 12),
                _buildInfoRow('restaurant', 'Cuisine',
                    restaurantData['cuisine'] as String),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                SizedBox(height: 12),
                Text(
                  restaurantData['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String iconName, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
