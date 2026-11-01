import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/product_detail_page.dart';
import 'package:dummy_project/services/login_service.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  customIconButton(
                    height: 40,
                    width: 40,
                    icon: Icons.arrow_back,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Text(
                    'All Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Firebase Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products found'));
                  }
                  final products = snapshot.data!.docs;
                  return ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final productData =
                          products[index].data() as Map<String, dynamic>;
                      productData['id'] = products[index].id;
                      final imageUrl = productData['image']?.toString() ?? '';
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                product: productData,
                                role: userRole,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Row(
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productData['name']?.toString() ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Price: ${productData['price'] ?? 'Not available'}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'View Details  →',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
