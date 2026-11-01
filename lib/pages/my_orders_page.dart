import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/order_detail_page.dart';
import 'package:dummy_project/services/place_order_service.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Color.fromARGB(255, 22, 128, 61);
      case 'pending':
        return Color.fromARGB(255, 183, 121, 0);
      case 'processing':
        return Color.fromARGB(255, 37, 99, 235);
      case 'cancelled':
        return Color.fromARGB(255, 220, 38, 38);
      default:
        return Color.fromARGB(255, 119, 119, 119);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      body: SafeArea(
        child: ResponsiveLayout.builder(
          breakpoints: ResponsiveBreakpoints(tablet: 600, desktop: 800),
          builder: (context, size, constraints) {
            final isWeb = size == ResponsiveSize.desktop;

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 32 : 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 238, 238, 238),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      customIconButton(
                        icon: Icons.arrow_back_rounded,
                        width: 42,
                        height: 42,
                        iconSize: 21,
                        borderRadius: 11,
                        color: Color.fromARGB(255, 245, 245, 245),
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Orders',
                              style: TextStyle(
                                fontSize: isWeb ? 25 : 21,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Your style journey, all in one place.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isWeb)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF6D9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 17,
                                color: Color(0xFF9A7000),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'JONSTORE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: getMyOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Unable to load your orders.'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 255, 193, 7),
                          ),
                        );
                      }

                      final orders = snapshot.data?.docs ?? [];

                      final delivered = orders.where((order) {
                        return (order.data()['status'] ?? '')
                                .toString()
                                .toLowerCase() ==
                            'delivered';
                      }).length;

                      final inProgress = orders.where((order) {
                        final status = (order.data()['status'] ?? '')
                            .toString()
                            .toLowerCase();
                        return status == 'pending' || status == 'processing';
                      }).length;

                      if (orders.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 245, 214),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 44,
                                  color: Color.fromARGB(255, 177, 129, 0),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Your story starts here',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'You have not placed any orders yet.',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        );
                      }

                      return ResponsiveContent(
                        maxWidth: 1100,
                        child: ListView(
                          padding: EdgeInsets.all(isWeb ? 30 : 16),
                          children: [
                            if (isWeb) ...[
                              Text(
                                'ORDER OVERVIEW',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.8,
                                  color: Color.fromARGB(255, 154, 112, 0),
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                'Your purchases',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Everything you have ordered from JONSTORE.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 22),
                              Row(
                                children: [
                                  Expanded(
                                    child: _statCard(
                                      'Total Orders',
                                      '${orders.length}',
                                      Icons.receipt_long_outlined,
                                      Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: _statCard(
                                      'Delivered',
                                      '$delivered',
                                      Icons.check_circle_outline_rounded,
                                      Color.fromARGB(255, 22, 128, 61),
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: _statCard(
                                      'In Progress',
                                      '$inProgress',
                                      Icons.local_shipping_outlined,
                                      Color.fromARGB(255, 177, 129, 0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Text(
                                    'Order history',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${orders.length} orders',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                            ],
                            ...orders.map((document) {
                              final order = document.data();
                              final rawProduct = order['product'];

                              final Map<String, dynamic> product =
                                  rawProduct is Map
                                  ? Map<String, dynamic>.from(rawProduct)
                                  : <String, dynamic>{
                                      'name': 'Product',
                                      'image': '',
                                      'price': order['price'] ?? 0,
                                    };

                              final name =
                                  product['name']?.toString() ?? 'Product';
                              final image =
                                  product['image']?.toString() ??
                                  product['imageUrl']?.toString() ??
                                  '';
                              final quantity =
                                  (order['quantity'] as num?)?.toInt() ?? 1;
                              final total = order['totalPrice'] ?? 0;
                              final status =
                                  order['status']?.toString() ?? 'Pending';
                              final createdAt = order['createdAt'];

                              final date = createdAt is Timestamp
                                  ? '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}'
                                  : 'Date unavailable';

                              return Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: _orderCard(
                                  context: context,
                                  isWeb: isWeb,
                                  product: product,
                                  order: order,
                                  name: name,
                                  image: image,
                                  quantity: quantity,
                                  total: total,
                                  status: status,
                                  date: date,
                                ),
                              );
                            }),
                          ],
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

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard({
    required BuildContext context,
    required bool isWeb,
    required Map<String, dynamic> product,
    required Map<String, dynamic> order,
    required String name,
    required String image,
    required int quantity,
    required dynamic total,
    required String status,
    required String date,
  }) {
    final color = _statusColor(status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        hoverColor: Color(0xFFFFFDF5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailPage(product: product, orderData: order),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(isWeb ? 18 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFECECEC)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: productImage(
                  imageUrl: image,
                  width: isWeb ? 94 : 78,
                  height: isWeb ? 105 : 92,
                  emptyIcon: Icons.image_not_supported_outlined,
                  iconSize: 28,
                  iconColor: Colors.grey.shade400,
                  placeholderColor: Color(0xFFF1F1F1),
                ),
              ),
              SizedBox(width: isWeb ? 20 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isWeb ? 16 : 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Quantity: $quantity',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Rs. $total',
                      style: TextStyle(
                        fontSize: isWeb ? 15 : 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 9),
                    Wrap(
                      spacing: 9,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
