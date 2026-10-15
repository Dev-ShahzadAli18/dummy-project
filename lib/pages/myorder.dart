import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/orderdetalpage.dart';
import 'package:dummy_project/services/placeorderservice.dart';
import 'package:dummy_project/widgets/button.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(height: 10),
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
                        'My Orders',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getMyOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final orders = snapshot.data?.docs ?? [];
                    if (orders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 75,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'No Orders Yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Your placed orders will appear here.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index].data();
                        final rawProduct = order['product'];
                        final Map<String, dynamic> product = rawProduct is Map
                            ? Map<String, dynamic>.from(rawProduct)
                            : <String, dynamic>{
                                'name': 'Product',
                                'image': '',
                                'price': order['price'] ?? 0,
                              };

                        final name = product['name']?.toString() ?? 'Product';
                        final image =
                            product['image']?.toString() ??
                            product['imageUrl']?.toString() ??
                            '';
                        final quantity =
                            (order['quantity'] as num?)?.toInt() ?? 1;
                        final total = order['totalPrice'] ?? 0;
                        final status = order['status']?.toString() ?? 'Pending';

                        final createdAt = order['createdAt'];
                        final date = createdAt is Timestamp
                            ? '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}'
                            : 'Date unavailable';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailPage(
                                  product: product,
                                  orderData: order,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: image.isNotEmpty
                                      ? Image.network(
                                          image,
                                          width: 90,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 90,
                                                  height: 100,
                                                  color: Colors.grey.shade300,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          width: 90,
                                          height: 100,
                                          color: Colors.grey.shade300,
                                          child: Icon(Icons.shopping_bag),
                                        ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text('Quantity: $quantity'),
                                      SizedBox(height: 5),
                                      Text(
                                        'Total: Rs. $total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Status: $status',
                                        style: TextStyle(
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
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
      ),
    );
  }
}
