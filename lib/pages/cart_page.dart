import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:dummy_project/services/cart_service.dart' as cart_functions;

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Cart',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: cart_functions.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 252, 190, 2),
              ),
            );
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
                    SizedBox(height: 20),
                    Text(
                      'Your Cart Is Empty',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your favourite products to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: 220,
                      child: customButton(
                        text: 'Continue Shopping',
                        borderRadius: 12,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
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

          return ResponsiveLayout.builder(
            breakpoints: ResponsiveBreakpoints(tablet: 600, desktop: 800),
            builder: (context, size, constraints) {
              final isDesktop = size == ResponsiveSize.desktop;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: ResponsiveContent(
                      maxWidth: 1000,
                      child: cartPageTitle(
                        title: 'Shopping Cart',
                        subtitle: '$totalItems items',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ResponsiveContent(
                      maxWidth: 1000,
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          isDesktop ? 24 : 16,
                          8,
                          isDesktop ? 24 : 16,
                          20,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final data = item.data();

                          final name = data['name']?.toString() ?? 'Product';
                          final image = data['image']?.toString() ?? '';
                          final category = data['category']?.toString() ?? '';

                          final rawPrice = data['price'];
                          final rawQuantity = data['quantity'];

                          final price = rawPrice is num
                              ? rawPrice.toDouble()
                              : double.tryParse(rawPrice?.toString() ?? '') ??
                                    0.0;

                          final quantity = rawQuantity is num
                              ? rawQuantity.toInt()
                              : int.tryParse(rawQuantity?.toString() ?? '') ??
                                    1;

                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.only(right: 25),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onDismissed: (direction) async {
                              try {
                                await cart_functions.removeFromCart(
                                  productId: item.id,
                                );
                              } catch (e) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Could not remove item: $e'),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(isDesktop ? 18 : 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.035,
                                    ),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: isDesktop ? 145 : 105,
                                      height: isDesktop ? 155 : 125,
                                      child: cartProductImage(image: image),
                                    ),
                                  ),
                                  SizedBox(width: isDesktop ? 22 : 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 19 : 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
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
                                                  await cart_functions
                                                      .removeFromCart(
                                                        productId: item.id,
                                                      );
                                                } catch (e) {
                                                  if (!context.mounted) {
                                                    return;
                                                  }

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        e.toString(),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        if (category.isNotEmpty) ...[
                                          SizedBox(height: 6),
                                          Text(
                                            category,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 10),
                                        Text(
                                          'Rs. ${(price * quantity).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: isDesktop ? 19 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFB18100),
                                          ),
                                        ),
                                        SizedBox(height: 12),
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
                                                  if (!context.mounted) {
                                                    return;
                                                  }

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        e.toString(),
                                                      ),
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
                                                  if (!context.mounted) {
                                                    return;
                                                  }

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        e.toString(),
                                                      ),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: ResponsiveContent(
                        maxWidth: 950,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            cartPriceSummary(
                              title: 'Total Items',
                              value: '$totalItems',
                            ),
                            SizedBox(height: 10),
                            cartPriceSummary(
                              title: 'Total Price',
                              value: 'Rs. ${totalPrice.toStringAsFixed(2)}',
                              isTotal: true,
                            ),
                            SizedBox(height: 18),
                            customButton(
                              text: 'Proceed to Checkout',
                              borderRadius: 12,
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
