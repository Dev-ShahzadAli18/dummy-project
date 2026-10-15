import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/allproduct.dart';
import 'package:dummy_project/pages/prodcutdetail.dart';
import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/widgets/category.dart';
import 'package:dummy_project/widgets/drawer.dart';
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
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  customIconButton(
                    height: 40,
                    width: 40,
                    onTap: () {
                      _key.currentState?.openDrawer();
                    },
                    icon: Icons.menu,
                  ),
                  Spacer(),
                  Text(
                    'JONSTORE',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  customIconButton(onTap: () {}, icon: Icons.notifications),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          height: 190,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1445205170230-053b83016050?w=900',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 190,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NEW COLLECTION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Style that\nspeaks for you.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Discover our latest collection',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '20% OFF',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 15,
                          child: customButton(
                            text: 'Shop Now',
                            width: 110,
                            height: 38,
                            color: Colors.white,
                            textColor: Colors.black,
                            borderRadius: 10,
                            fontSize: 13,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Allproduct(product: {}),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    category(
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          'Popular Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        customButton(
                          text: 'See All',
                          width: 75,
                          height: 35,
                          color: Colors.black,
                          textColor: Colors.white,
                          borderRadius: 10,
                          fontSize: 12,
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
                    SizedBox(height: 15),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
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
                              padding: EdgeInsets.all(20),
                              child: Text('No products available'),
                            ),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.72,
                              ),
                          itemBuilder: (context, index) {
                            final doc = products[index];
                            final Map<String, dynamic> product = {
                              ...doc.data(),
                              'id': doc.id,
                            };
                            return GestureDetector(
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
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(18),
                                        ),
                                        child: Image.network(
                                          product['image']?.toString() ?? '',
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name']?.toString() ??
                                                'No name',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'Rs. ${product['price'] ?? 0}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
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
                      },
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
