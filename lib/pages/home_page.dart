import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/all_products_page.dart';
import 'package:dummy_project/pages/product_detail_page.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/category_selector.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';
import 'package:dummy_project/widgets/app_drawer.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String userRole = 'User';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCategory = 'All';

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: customDrawer(context),
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      body: SafeArea(
        child: ResponsiveLayout.builder(
          breakpoints: ResponsiveBreakpoints(
            tablet: 750,
            tabletInclusive: false,
          ),
          builder: (context, size, constraints) {
            final isWeb = size != ResponsiveSize.mobile;

            return Column(
              children: [
                _buildHeader(isWeb),
                Expanded(
                  child: SingleChildScrollView(
                    child: ResponsiveContent(
                      maxWidth: isWeb ? 1450 : double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 35 : 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: isWeb ? 25 : 12),
                          _buildBanner(isWeb),
                          SizedBox(height: 25),
                          category(
                            selectedCategory: selectedCategory,
                            onCategorySelected: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                          SizedBox(height: 35),
                          _buildSectionHeader(isWeb),
                          SizedBox(height: 20),
                          _buildProducts(isWeb),
                          SizedBox(height: 35),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWeb) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 35 : 16,
        vertical: isWeb ? 18 : 10,
      ),
      child: ResponsiveContent(
        maxWidth: isWeb ? 1450 : double.infinity,
        child: Row(
          children: [
            customIconButton(
              height: 42,
              width: 42,
              onTap: () {
                _key.currentState?.openDrawer();
              },
              icon: Icons.menu_rounded,
            ),
            SizedBox(width: isWeb ? 22 : 0),
            if (isWeb)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JONSTORE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'YOUR STYLE, YOUR STORE',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    'JONSTORE',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            if (isWeb)
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  'Discover your style',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
            customIconButton(
              height: 42,
              width: 42,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifications coming soon')),
                );
              },
              icon: Icons.notifications_none_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(bool isWeb) {
    return Container(
      height: isWeb ? 340 : 210,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isWeb ? 24 : 18),
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1445205170230-053b83016050?w=1600',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isWeb ? 24 : 18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.38)),
            ),
            Padding(
              padding: EdgeInsets.all(isWeb ? 40 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NEW COLLECTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWeb ? 13 : 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Style that\nspeaks for you.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWeb ? 44 : 27,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Discover your next favourite look.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isWeb ? 15 : 11,
                    ),
                  ),
                  SizedBox(height: 13),
                  customButton(
                    text: 'Shop Collection',
                    width: isWeb ? 165 : 135,
                    height: isWeb ? 46 : 38,
                    color: Colors.white,
                    textColor: Colors.black,
                    borderRadius: 8,
                    fontSize: isWeb ? 14 : 12,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Allproduct(product: {}),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '20% OFF',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isWeb) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Products',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isWeb ? 25 : 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Explore our latest styles and picks',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isWeb ? 14 : 12,
                ),
              ),
            ],
          ),
        ),
        customButton(
          text: 'See All',
          width: isWeb ? 100 : 78,
          height: 38,
          color: Colors.black,
          textColor: Colors.white,
          borderRadius: 9,
          fontSize: 12,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Allproduct(product: {})),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProducts(bool isWeb) {
    return ResponsiveLayout.builder(
      breakpoints: ResponsiveBreakpoints(
        tablet: 750,
        desktop: 1100,
        tabletInclusive: false,
        desktopInclusive: false,
      ),
      builder: (context, size, constraints) {
        final count = switch (size) {
          ResponsiveSize.mobile => 2,
          ResponsiveSize.tablet => 3,
          ResponsiveSize.desktop => 4,
        };

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text('Unable to load products'),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: EdgeInsets.all(50),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              );
            }

            final allProducts = snapshot.data!.docs;

            final products = selectedCategory == 'All'
                ? allProducts
                : allProducts.where((doc) {
                    final product = doc.data();

                    return (product['category'] ?? '')
                            .toString()
                            .trim()
                            .toLowerCase() ==
                        selectedCategory.trim().toLowerCase();
                  }).toList();

            if (products.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(35),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No products available',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                crossAxisSpacing: isWeb ? 22 : 12,
                mainAxisSpacing: isWeb ? 24 : 14,
                childAspectRatio: isWeb ? 0.86 : 0.68,
              ),
              itemBuilder: (context, index) {
                final doc = products[index];

                final Map<String, dynamic> product = {
                  ...doc.data(),
                  'id': doc.id,
                };

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          product: product,
                          role: widget.userRole,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: Color(0xFFF3F3F3),
                            child: productImage(
                              imageUrl: product['image']?.toString() ?? '',
                              fit: BoxFit.cover,
                              iconSize: 35,
                              iconColor: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(isWeb ? 15 : 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name']?.toString() ?? 'No name',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isWeb ? 16 : 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Rs. ${product['price'] ?? 0}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: isWeb ? 16 : 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_outward_rounded,
                                    size: isWeb ? 19 : 16,
                                    color: Colors.black54,
                                  ),
                                ],
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
          },
        );
      },
    );
  }
}
