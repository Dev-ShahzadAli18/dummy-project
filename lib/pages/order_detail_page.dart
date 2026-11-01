import 'package:dummy_project/services/place_order_service.dart';
import 'package:dummy_project/widgets/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:dummy_project/widgets/custom_text_field.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';

class OrderDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Map<String, dynamic>? orderData;

  OrderDetailPage({super.key, required this.product, this.orderData});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  int quantity = 1;
  String selectedColor = 'Black';
  bool isPlacingOrder = false;

  bool get isViewingOrder => widget.orderData != null;

  double get productPrice {
    final price = widget.orderData?['price'] ?? widget.product['price'];

    if (price is num) {
      return price.toDouble();
    }

    return double.tryParse(
          price.toString().replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0.0;
  }

  double get totalPrice {
    if (isViewingOrder) {
      final savedTotal = widget.orderData?['totalPrice'];

      if (savedTotal is num) {
        return savedTotal.toDouble();
      }

      return double.tryParse(savedTotal.toString()) ?? productPrice * quantity;
    }

    return productPrice * quantity;
  }

  @override
  void initState() {
    super.initState();

    nameController.text = widget.orderData?['customerName']?.toString() ?? '';
    phoneController.text = widget.orderData?['phone']?.toString() ?? '';
    addressController.text = widget.orderData?['address']?.toString() ?? '';

    quantity = (widget.orderData?['quantity'] as num?)?.toInt() ?? 1;
    selectedColor = widget.orderData?['selectedColor']?.toString() ?? 'Black';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productName = widget.product['name']?.toString() ?? 'Product';

    final imageUrl =
        widget.product['image']?.toString() ??
        widget.product['imageUrl']?.toString() ??
        '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(isViewingOrder ? 'Order Details' : 'Place Order'),
        centerTitle: true,
      ),
      body: ResponsiveLayout.builder(
        breakpoints: ResponsiveBreakpoints(tablet: 600, tabletInclusive: false),
        builder: (context, size, constraints) {
          final isWide = size != ResponsiveSize.mobile;

          final contentWidth = isWide ? 800.0 : constraints.maxWidth;
          final horizontalPadding = isWide ? 30.0 : 16.0;
          final imageSize = isWide ? 130.0 : 100.0;

          return ResponsiveContent(
            maxWidth: contentWidth,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isWide ? 18 : 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: productImage(
                              imageUrl: imageUrl,
                              width: imageSize,
                              height: imageSize,
                              emptyIcon: Icons.shopping_bag,
                              errorIcon: Icons.image_not_supported,
                              iconSize: 24,
                              emptyIconColor: Colors.black,
                              errorIconColor: Colors.grey,
                              placeholderColor: Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(width: isWide ? 20 : 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: TextStyle(
                                    fontSize: isWide ? 22 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Price: Rs. ${productPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: isWide ? 18 : 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: isWide ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 16),

                    customTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: nameController,
                      readOnly: isViewingOrder,
                      prefixicon: Icon(Icons.person_outline),
                      validator: nameValidation,
                    ),

                    SizedBox(height: 16),

                    customTextField(
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      controller: phoneController,
                      readOnly: isViewingOrder,
                      keyboardType: TextInputType.phone,
                      prefixicon: Icon(Icons.phone_outlined),
                      validator: phoneValidation,
                    ),

                    SizedBox(height: 16),

                    customTextField(
                      label: 'Delivery Address',
                      hint: 'Enter your complete address',
                      controller: addressController,
                      readOnly: isViewingOrder,
                      maxLines: 3,
                      prefixicon: Icon(Icons.location_on_outlined),
                      validator: addressValidation,
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Select Color',
                      style: TextStyle(
                        fontSize: isWide ? 21 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text('Black'),
                          selected: selectedColor == 'Black',
                          onSelected: isViewingOrder
                              ? null
                              : (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedColor = 'Black';
                                    });
                                  }
                                },
                          selectedColor: Colors.amber.shade200,
                        ),
                        ChoiceChip(
                          label: Text('White'),
                          selected: selectedColor == 'White',
                          onSelected: isViewingOrder
                              ? null
                              : (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedColor = 'White';
                                    });
                                  }
                                },
                          selectedColor: Colors.amber.shade200,
                        ),
                        ChoiceChip(
                          label: Text('Blue'),
                          selected: selectedColor == 'Blue',
                          onSelected: isViewingOrder
                              ? null
                              : (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedColor = 'Blue';
                                    });
                                  }
                                },
                          selectedColor: Colors.amber.shade200,
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: isWide ? 21 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      children: [
                        IconButton(
                          onPressed: isViewingOrder || quantity <= 1
                              ? null
                              : () {
                                  setState(() {
                                    quantity--;
                                  });
                                },
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: isViewingOrder
                              ? null
                              : () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                          icon: Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isWide ? 20 : 16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: isWide ? 21 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Rs. ${totalPrice.toStringAsFixed(2)}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: isWide ? 21 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    if (isViewingOrder)
                      Text(
                        'Order Status: ${widget.orderData?['status'] ?? 'Pending'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: customButton(
                          text: isPlacingOrder
                              ? 'Please wait...'
                              : 'Place Order',
                          onTap: isPlacingOrder
                              ? null
                              : () => placeOrder(
                                  context: context,
                                  formKey: formKey,
                                  isPlacingOrder: isPlacingOrder,
                                  setLoading: () {
                                    setState(() {
                                      isPlacingOrder = true;
                                    });
                                  },
                                  resetLoading: () {
                                    setState(() {
                                      isPlacingOrder = false;
                                    });
                                  },
                                  product: widget.product,
                                  nameController: nameController,
                                  phoneController: phoneController,
                                  addressController: addressController,
                                  quantity: quantity,
                                  selectedColor: selectedColor,
                                  productPrice: productPrice,
                                  totalPrice: totalPrice,
                                ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
