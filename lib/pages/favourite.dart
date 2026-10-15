import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/pages/prodcutdetail.dart';
import 'package:dummy_project/services/favouriteservice.dart'
    as favorite_functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
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
                Expanded(
                  child: Center(
                    child: Text(
                      'Favourites',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: favorite_functions.getFavorites(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading favourites',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final favorites = snapshot.data?.docs ?? [];
                  if (favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_outline,
                            size: 70,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No Favourites',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Add products to your favourites',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final doc = favorites[index];
                      final Map<String, dynamic> product = {
                        ...doc.data(),
                        'id': doc.id,
                      };
                      final name = product['name']?.toString() ?? 'No Name';
                      final image = product['image']?.toString() ?? '';
                      final price = product['price'] ?? 0;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetail(product: product, role: 'User'),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  image,
                                  height: 100,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 100,
                                      width: 90,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Rs. $price',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'View product details',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  try {
                                    await favorite_functions.removeFavorite(
                                      productId: doc.id,
                                    );
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Removed from favourites',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                                icon: Icon(Icons.favorite, color: Colors.red),
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
