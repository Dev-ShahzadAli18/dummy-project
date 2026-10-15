import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/services/adminorderservice.dart'
    as admin_order_service;
import 'package:dummy_project/widgets/detailrow.dart';
import 'package:flutter/material.dart';

class AdminOrdersPage extends StatelessWidget {
  AdminOrdersPage({super.key});

  String valueOf(dynamic value, [String fallback = 'Not provided']) {
    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }
    return value.toString();
  }

  double numberOf(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 248, 250),
      appBar: AppBar(
        title: Text(
          'Manage Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: admin_order_service.getAdminOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Unable to load orders: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 65,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Orders for your products will appear here.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          final sortedDocs = [...docs];
          sortedDocs.sort((a, b) {
            final aTime = a.data()['createdAt'] as Timestamp?;
            final bTime = b.data()['createdAt'] as Timestamp?;

            return (bTime?.millisecondsSinceEpoch ?? 0).compareTo(
              aTime?.millisecondsSinceEpoch ?? 0,
            );
          });

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: sortedDocs.length,
            itemBuilder: (context, index) {
              final doc = sortedDocs[index];
              final order = doc.data();
              final product = Map<String, dynamic>.from(order['product'] ?? {});
              final productName = valueOf(
                order['productName'] ?? product['name'],
                'Product',
              );

              final image = valueOf(
                order['productImage'] ?? product['image'],
                '',
              );
              final customerName = valueOf(order['customerName']);
              final phone = valueOf(order['customerPhone'] ?? order['phone']);
              final email = valueOf(order['customerEmail']);
              final address = valueOf(order['address']);
              final customerId = valueOf(order['userId'], '');
              final quantity = numberOf(order['quantity']).toInt();
              final total = numberOf(order['totalPrice']);
              final status = valueOf(order['status'], 'Pending');
              final statuses = [
                'Pending',
                'Processing',
                'Shipped',
                'Delivered',
                'Cancelled',
              ];
              final selectedStatus = statuses.contains(status)
                  ? status
                  : 'Pending';
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 1,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: image.isEmpty
                                ? Container(
                                    width: 82,
                                    height: 82,
                                    color: Colors.grey.shade200,
                                    child: Icon(Icons.image_outlined),
                                  )
                                : Image.network(
                                    image,
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 82,
                                      height: 82,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.broken_image),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text('Quantity: $quantity'),
                                Text(
                                  'Total: Rs. ${total.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 28),
                      Text(
                        'CUSTOMER DETAILS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 9),
                      detailRow(
                        icon: Icons.person_outline,
                        value: customerName,
                      ),
                      detailRow(icon: Icons.email_outlined, value: email),
                      detailRow(icon: Icons.phone_outlined, value: phone),
                      detailRow(
                        icon: Icons.location_on_outlined,
                        value: address,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'ORDER STATUS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: statuses.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (newStatus) async {
                          if (newStatus == null ||
                              newStatus == selectedStatus) {
                            return;
                          }

                          if (customerId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Customer ID is missing')),
                            );
                            return;
                          }

                          try {
                            await admin_order_service.updateAdminOrderStatus(
                              orderId: doc.id,
                              customerId: customerId,
                              newStatus: newStatus,
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Order status updated to $newStatus',
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Status update failed: $e'),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Order ID: ${doc.id}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
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
    );
  }
}
