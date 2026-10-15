import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/prodcutdetail.dart';
import 'package:dummy_project/services/loginservice.dart';
import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/widgets/textfield.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(
              children: [
                customIconButton(
                  height: 40,
                  width: 40,
                  icon: Icons.arrow_back,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(width: 100),
                Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            customTextField(
              controller: searchController,
              hint: 'Search here...',
              prefixicon: Icon(Icons.search, color: Colors.black),
              suffixicon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: Icon(Icons.close),
                    )
                  : null,
              ontap: () {},
            ),
            SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading products'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final products = snapshot.data?.docs ?? [];
                  final query = searchController.text.trim().toLowerCase();

                  if (query.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 70,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Search for something',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Find what you are looking for',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  final results = products.where((doc) {
                    final data = doc.data();
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    return name.contains(query);
                  }).toList();
                  if (results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('No products found'),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final productData = results[index].data();
                      productData['id'] = results[index].id;

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
                          margin: EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  productData['image'] != null &&
                                      productData['image'].toString().isNotEmpty
                                  ? Image.network(
                                      productData['image'].toString(),
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: 60,
                                              width: 60,
                                              color: Colors.grey.shade200,
                                              child: Icon(Icons.image),
                                            );
                                          },
                                    )
                                  : Container(
                                      height: 60,
                                      width: 60,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.image),
                                    ),
                            ),
                            title: Text(
                              productData['name']?.toString() ??
                                  'Unnamed Product',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Price: ${productData['price'] ?? 'N/A'}',
                            ),
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
