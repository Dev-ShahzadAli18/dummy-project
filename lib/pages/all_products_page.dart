import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/product_detail_page.dart';
import 'package:dummy_project/services/login_service.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class Allproduct extends StatefulWidget {
  final Map product;
  Allproduct({super.key, required this.product});

  @override
  State<Allproduct> createState() => _AllproductState();
}

class _AllproductState extends State<Allproduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveLayout.builder(
          breakpoints: ResponsiveBreakpoints(tablet: 600, desktop: 1024),
          builder: (context, size, constraints) {
            final isWide = size != ResponsiveSize.mobile;
            final isDesktop = size == ResponsiveSize.desktop;

            return Column(
              children: [
                ResponsiveContent(
                  maxWidth: 1200,
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 28 : 15,
                    15,
                    isWide ? 28 : 15,
                    8,
                  ),
                  child: Row(
                    children: [
                      customIconButton(
                        height: 40,
                        width: 40,
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'All Products',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isWide ? 23 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Firebase Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final products = snapshot.data?.docs ?? [];
                      if (products.isEmpty) {
                        return Center(child: Text('No products found'));
                      }

                      return ResponsiveContent(
                        maxWidth: 1200,
                        child: isWide
                            ? GridView.builder(
                                padding: EdgeInsets.all(isDesktop ? 24 : 16),
                                itemCount: products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isDesktop ? 4 : 2,
                                      crossAxisSpacing: 18,
                                      mainAxisSpacing: 18,
                                      mainAxisExtent: 310,
                                    ),
                                itemBuilder: (context, index) {
                                  final productData =
                                      products[index].data()
                                        ..['id'] = products[index].id;
                                  return _productCard(
                                    context,
                                    productData,
                                    isGrid: true,
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(15),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final productData =
                                      products[index].data()
                                        ..['id'] = products[index].id;
                                  return _productCard(
                                    context,
                                    productData,
                                    isGrid: false,
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _productCard(
    BuildContext context,
    Map<String, dynamic> productData, {
    required bool isGrid,
  }) {
    final imageUrl = productData['image']?.toString() ?? '';

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.only(bottom: isGrid ? 0 : 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetail(product: productData, role: userRole),
            ),
          );
        },
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: productImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 180,
                      emptyIcon: Icons.image_not_supported,
                      errorIcon: Icons.broken_image,
                      iconSize: 40,
                      placeholderColor: Colors.grey.shade200,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: _productDetails(productData, compact: true),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: productImage(
                      imageUrl: imageUrl,
                      width: 120,
                      height: 120,
                      emptyIcon: Icons.image_not_supported,
                      errorIcon: Icons.broken_image,
                      iconSize: 40,
                      placeholderColor: Colors.grey.shade200,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: _productDetails(productData, compact: false),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _productDetails(
    Map<String, dynamic> productData, {
    required bool compact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          productData['name']?.toString() ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 15 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Price: ${productData['price'] ?? 'Not available'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 14 : 15,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'View Details  →',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
