import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/widgets/cartwidget.dart';
import 'package:flutter/material.dart';
import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/services/cartservice.dart' as cart_functions;

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Cart',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cart_functions.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong. Please try again.'),
            );
          }

          final items = snapshot.data?.docs ?? [];

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cartEmptyIcon(),
                    SizedBox(height: 24),
                    Text(
                      'Your Cart Is Empty',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    customButton(
                      text: 'Continue Shopping',
                      borderRadius: 12,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          double totalPrice = 0;
          int totalItems = 0;
          for (final item in items) {
            final data = item.data();
            final rawPrice = data['price'];
            final rawQuantity = data['quantity'];

            final price = rawPrice is num
                ? rawPrice.toDouble()
                : double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;
            final quantity = rawQuantity is num
                ? rawQuantity.toInt()
                : int.tryParse(rawQuantity?.toString() ?? '') ?? 1;

            totalPrice += price * quantity;
            totalItems += quantity;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: cartPageTitle(
                  title: 'Shopping Cart',
                  subtitle: '$totalItems items',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final data = item.data();
                    final String name = data['name']?.toString() ?? 'Product';
                    final String image = data['image']?.toString() ?? '';
                    final String category = data['category']?.toString() ?? '';
                    final rawPrice = data['price'];
                    final rawQuantity = data['quantity'];

                    final double price = rawPrice is num
                        ? rawPrice.toDouble()
                        : double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;
                    final int quantity = rawQuantity is num
                        ? rawQuantity.toInt()
                        : int.tryParse(rawQuantity?.toString() ?? '') ?? 1;

                    return Container(
                      margin: EdgeInsets.only(bottom: 14),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cartProductImage(image: image),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    customIconButton(
                                      icon: Icons.delete_outline,
                                      iconColor: Colors.red,
                                      color: Colors.red.shade50,
                                      width: 34,
                                      height: 34,
                                      borderRadius: 9,
                                      onTap: () async {
                                        try {
                                          await cart_functions.removeFromCart(
                                            productId: item.id,
                                          );
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                if (category.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    " Category : ${category}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                                SizedBox(height: 8),
                                Text(
                                  'Rs: ${(price * quantity).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    cartQuantityButton(
                                      icon: Icons.remove,
                                      onTap: () async {
                                        try {
                                          await cart_functions
                                              .updateCartQuantity(
                                                productId: item.id,
                                                quantity: quantity - 1,
                                              );
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Text(
                                        '$quantity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    cartQuantityButton(
                                      icon: Icons.add,
                                      isAdd: true,
                                      onTap: () async {
                                        try {
                                          await cart_functions
                                              .updateCartQuantity(
                                                productId: item.id,
                                                quantity: quantity + 1,
                                              );
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      cartPriceSummary(
                        title: 'Total Items',
                        value: '$totalItems',
                      ),
                      SizedBox(height: 12),
                      cartPriceSummary(
                        title: 'Total Price',
                        value: totalPrice.toStringAsFixed(2),
                        isTotal: true,
                      ),
                      SizedBox(height: 18),
                      customButton(
                        text: 'Proceed to Checkout',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Checkout feature will be added next.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
