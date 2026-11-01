import 'package:dummy_project/pages/add_product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dummy_project/services/cart_service.dart' as cart_functions;
import 'package:dummy_project/services/favourites_service.dart'
    as favorite_functions;
import 'package:dummy_project/services/data_update_service.dart' as product_functions;
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';

class ProductDetail extends StatefulWidget {
  final String role;
  final Map product;
  final bool fromMyProducts;

  ProductDetail({
    super.key,
    required this.product,
    required this.role,
    this.fromMyProducts = false,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool isFavorite = false;
  bool isFavoriteLoading = true;
  bool isLoading = false;

  String get productId =>
      (widget.product['id'] ??
              widget.product['productId'] ??
              widget.product['firestoreId'] ??
              '')
          .toString();

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  bool get canManageProduct =>
      widget.role.toLowerCase() == 'admin' &&
      widget.fromMyProducts &&
      currentUserId.isNotEmpty &&
      widget.product['userId'] == currentUserId;

  bool get isNormalUser => widget.role.toLowerCase() == 'user';

  @override
  void initState() {
    super.initState();

    favorite_functions
        .checkFavorite(productId: productId)
        .then((result) {
          if (!mounted) return;

          setState(() {
            isFavorite = result == true;
            isFavoriteLoading = false;
          });
        })
        .catchError((error) {
          if (!mounted) return;

          setState(() {
            isFavoriteLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.product['name']?.toString() ?? 'No Name';
    final description =
        widget.product['description']?.toString() ?? 'No description available';
    final imageUrl = widget.product['image']?.toString() ?? '';
    final category = widget.product['category']?.toString() ?? 'General';
    final price = widget.product['price']?.toString() ?? '0';
    final orderAvailable = widget.product['orderAvailable'] != false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: isFavoriteLoading
                ? null
                : () async {
                    try {
                      final result = await favorite_functions.toggleFavorite(
                        productId: productId,
                        product: Map<String, dynamic>.from(widget.product),
                      );

                      if (!mounted) return;

                      setState(() {
                        isFavorite = result == true;
                      });
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
      body: ResponsiveLayout.builder(
        breakpoints: ResponsiveBreakpoints(tablet: 700, tabletInclusive: false),
        builder: (context, size, constraints) {
          final isWide = size != ResponsiveSize.mobile;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey.shade100,
                    child: _buildProductImage(
                      imageUrl,
                      height: constraints.maxHeight,
                      fullHeight: true,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 35),
                    child: _buildProductInfo(
                      name: name,
                      description: description,
                      category: category,
                      price: price,
                      orderAvailable: orderAvailable,
                    ),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(imageUrl, height: 350),
                SizedBox(height: 20),
                _buildProductInfo(
                  name: name,
                  description: description,
                  category: category,
                  price: price,
                  orderAvailable: orderAvailable,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(
    String imageUrl, {
    double? height,
    bool fullHeight = false,
  }) {
    if (fullHeight) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: productImage(
          imageUrl: imageUrl,
          width: double.infinity,
          height: height,
          fit: BoxFit.contain,
          emptyIcon: Icons.image_not_supported,
          errorIcon: Icons.broken_image,
          iconSize: 70,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: productImage(
        imageUrl: imageUrl,
        height: height ?? 350,
        width: double.infinity,
        fit: BoxFit.contain,
        emptyIcon: Icons.image_not_supported,
        errorIcon: Icons.broken_image,
        iconSize: 70,
        iconColor: Colors.black,
        placeholderColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildProductInfo({
    required String name,
    required String description,
    required String category,
    required String price,
    required bool orderAvailable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Rs. $price',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 190, 140, 0),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Description',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Icon(
              orderAvailable ? Icons.check_circle : Icons.cancel,
              color: orderAvailable ? Colors.green : Colors.red,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                orderAvailable ? 'Order Available' : 'Currently Unavailable',
                style: TextStyle(
                  fontSize: 15,
                  color: orderAvailable ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 28),
        if (canManageProduct) ...[
          customButton(
            text: 'Edit Product',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductPage(
                    product: Map<String, dynamic>.from(widget.product),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 12),
          customButton(
            text: 'Delete Product',
            color: Colors.red,
            textColor: Colors.white,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Delete Product'),
                  content: Text(
                    'Are you sure you want to delete this product?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext, false);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext, true);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm != true || !context.mounted) return;

              try {
                await product_functions.deleteProduct(productId: productId);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product deleted successfully')),
                );

                Navigator.pop(context, true);
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
        ] else if (isNormalUser) ...[
          customButton(
            text: 'Add to Cart',
            onTap: !orderAvailable
                ? null
                : () async {
                    try {
                      await cart_functions.addToCart(
                        productId: productId,
                        product: Map<String, dynamic>.from(widget.product),
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product added to cart')),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
          ),
          SizedBox(height: 12),
          customButton(
            text: 'Order Now',
            onTap: orderAvailable
                ? () {
                    cart_functions.orderNow(
                      context: context,
                      product: Map<String, dynamic>.from(widget.product),
                    );
                  }
                : null,
          ),
        ],
      ],
    );
  }
}
