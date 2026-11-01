import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/product_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class MyProductPage extends StatelessWidget {
  MyProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('My Products')),
        body: Center(child: Text('Please login first')),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Products',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ResponsiveLayout.builder(
        breakpoints: ResponsiveBreakpoints(tablet: 600, desktop: 1024),
        builder: (context, size, constraints) {
          final isWide = size != ResponsiveSize.mobile;
          final isDesktop = size == ResponsiveSize.desktop;

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where('userId', isEqualTo: user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final products = snapshot.data?.docs ?? [];
              if (products.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'You have not added any products yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }

              return ResponsiveContent(
                maxWidth: 1200,
                child: isWide
                    ? GridView.builder(
                        padding: EdgeInsets.all(isDesktop ? 24 : 16),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          mainAxisExtent: 340,
                        ),
                        itemBuilder: (context, index) {
                          final document = products[index];
                          return _productCard(
                            context,
                            document.data(),
                            document.id,
                            isGrid: true,
                          );
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final document = products[index];
                          return _productCard(
                            context,
                            document.data(),
                            document.id,
                            isGrid: false,
                          );
                        },
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _productCard(
    BuildContext context,
    Map<String, dynamic> data,
    String productId, {
    required bool isGrid,
  }) {
    final name = data['name']?.toString() ?? 'No Name';
    final price = data['price']?.toString() ?? '0';
    final image = data['image']?.toString() ?? '';
    final description = data['description']?.toString() ?? '';
    final productData = {...data, 'id': productId};

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              product: productData,
              role: 'admin',
              fromMyProducts: true,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isGrid ? 0 : 18),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
        ),
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 155,
                      child: productImage(
                        imageUrl: image,
                        width: double.infinity,
                        height: 155,
                        emptyIcon: Icons.shopping_bag_outlined,
                        errorIcon: Icons.broken_image,
                        iconSize: 32,
                        placeholderColor: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _productInfo(name, price, description, compact: true),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: productImage(
                      imageUrl: image,
                      width: 100,
                      height: 100,
                      emptyIcon: Icons.shopping_bag_outlined,
                      errorIcon: Icons.broken_image,
                      iconSize: 24,
                      placeholderColor: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: _productInfo(name, price, description)),
                ],
              ),
      ),
    );
  }

  Widget _productInfo(
    String name,
    String price,
    String description, {
    bool compact = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 15 : 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Rs. $price',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Text(
          description,
          maxLines: compact ? 1 : 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade700),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.touch_app, size: 16, color: Colors.grey.shade600),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                'Tap to view details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
