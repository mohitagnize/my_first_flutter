import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --------------------------------------------------
  // SEARCH CONTROLLER
  // --------------------------------------------------

  final TextEditingController searchController = TextEditingController();

  // --------------------------------------------------
  // PRODUCTS
  // --------------------------------------------------

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Wireless Headphones',
      'price': 1499,
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
    },
    {
      'name': 'Smart Watch',
      'price': 2499,
      'rating': 4.4,
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
    },
    {
      'name': 'Running Shoes',
      'price': 1999,
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    },
    {
      'name': 'Backpack',
      'price': 999,
      'rating': 4.3,
      'image':
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
    },
    {
      'name': 'Sunglasses',
      'price': 799,
      'rating': 4.2,
      'image':
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800',
    },
    {
      'name': 'Sneakers',
      'price': 2299,
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    },
  ];

  // --------------------------------------------------
  // FILTERED PRODUCTS
  // --------------------------------------------------

  List<Map<String, dynamic>> get filteredProducts {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return products;
    }

    return products.where((product) {
      final name = product['name'].toString().toLowerCase();

      return name.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------

      appBar: AppBar(
        title: const Text(
          'Agnize',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
        ],
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------

      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------
          // SEARCH BAR
          // ------------------------------------------------

          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(
              controller: searchController,
              onClear: () {
                searchController.clear();
              },
            ),
          ),

          // ------------------------------------------------
          // CONTENT
          // ------------------------------------------------

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              24,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // ------------------------------------------
                  // CATEGORIES
                  // ------------------------------------------

                  const Text(
                    'Categories',
                    style: AppTextStyles.heading,
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _category(
                          'All',
                          Icons.grid_view,
                        ),
                        _category(
                          'Electronics',
                          Icons.devices,
                        ),
                        _category(
                          'Fashion',
                          Icons.checkroom,
                        ),
                        _category(
                          'Shoes',
                          Icons.directions_run,
                        ),
                        _category(
                          'Beauty',
                          Icons.spa,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ------------------------------------------
                  // POPULAR PRODUCTS
                  // ------------------------------------------

                  Text(
                    searchController.text.trim().isEmpty
                        ? 'Popular Products'
                        : 'Search Results',
                    style: AppTextStyles.heading,
                  ),

                  const SizedBox(height: 16),

                  // ------------------------------------------
                  // NO RESULT MESSAGE
                  // ------------------------------------------

                  if (visibleProducts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 50,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try searching for another product.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ------------------------------------------------
          // PRODUCT GRID
          // ------------------------------------------------

          if (visibleProducts.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = visibleProducts[index];

                    return _ProductCard(
                      name: product['name'],
                      price: product['price'],
                      rating: product['rating'],
                      image: product['image'],
                    );
                  },
                  childCount: visibleProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
              ),
            ),

          // ------------------------------------------------
          // BOTTOM SPACE
          // ------------------------------------------------

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // CATEGORY
  // ==================================================

  static Widget _category(
    String title,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}

// ==================================================
// SEARCH BAR DELEGATE
// ==================================================

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;
  final VoidCallback onClear;

  _SearchBarDelegate({
    required this.controller,
    required this.onClear,
  });

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8,
      ),
      child: SizedBox(
        height: 56,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: const Icon(
              Icons.search,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: onClear,
                    icon: const Icon(
                      Icons.clear,
                    ),
                  )
                : const Icon(
                    Icons.tune,
                  ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(
    covariant _SearchBarDelegate oldDelegate,
  ) {
    return oldDelegate.controller.text != controller.text ||
        oldDelegate.controller != controller;
  }
}

// ==================================================
// PRODUCT CARD
// ==================================================

class _ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final double rating;
  final String image;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        // ----------------------------------------------
        // PRODUCT CLICK
        // ----------------------------------------------

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                name: name,
                price: price,
                rating: rating,
                image: image,
              ),
            ),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------
              // IMAGE
              // ------------------------------------------

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ------------------------------------------
              // NAME
              // ------------------------------------------

              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 6),

              // ------------------------------------------
              // RATING
              // ------------------------------------------

              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 17,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // ------------------------------------------
              // PRICE
              // ------------------------------------------

              Text(
                '₹$price',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
