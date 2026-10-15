import 'dart:io' show File;

import 'package:dummy_project/services/profileservices/productimageservice.dart';
import 'package:dummy_project/services/updatedata.dart';
import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/widgets/customOrderSwitch.dart';
import 'package:dummy_project/widgets/textfield.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  final Map<String, dynamic>? product;

  AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProductImageServices productImageServices = ProductImageServices();

  File? selectedImage;
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool orderAvailable = true;
  bool isLoading = false;
  String selectedCategory = 'Women';
  final List<String> categories = ['Men', 'Women', 'Beauty', 'Accessories'];
  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      productNameController.text = product['name']?.toString() ?? '';
      priceController.text = product['price']?.toString() ?? '';
      imageUrlController.text = product['image']?.toString() ?? '';
      descriptionController.text = product['description']?.toString() ?? '';
      selectedCategory = product['category']?.toString() ?? 'Women';
      orderAvailable = product['orderAvailable'] ?? true;
    }
  }

  Future<void> selectProductImage() async {
    try {
      final image = await productImageServices.pickProductImage();

      if (image != null && mounted) {
        setState(() {
          selectedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image selection failed: $e')));
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    customIconButton(
                      height: 40,
                      width: 40,
                      icon: Icons.arrow_back,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    Text(
                      isEditing ? 'Edit Product' : 'Add Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Product Name',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              customTextField(
                controller: productNameController,
                hint: 'Enter product name',
                prefixicon: Icon(Icons.shopping_bag_outlined),
              ),
              SizedBox(height: 10),
              Text(
                'Price',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              customTextField(
                controller: priceController,
                hint: 'Enter price',
                prefixicon: Icon(Icons.currency_exchange),
              ),
              SizedBox(height: 10),

              Text(
                'Product Image',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: isLoading ? null : selectProductImage,

                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : imageUrlController.text.isNotEmpty
                        ? Image.network(
                            imageUrlController.text,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 45,
                                ),
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 45,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text('Select Product Image'),
                              Text(
                                'Tap to choose from gallery',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tap the image to select or change it.',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                'Paste a direct image URL from Google or another image hosting website.',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'Category',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              customTextField(
                controller: descriptionController,
                hint: 'Enter product description',
                prefixicon: Icon(Icons.description_outlined),
                maxLines: 4,
              ),
              SizedBox(height: 15),
              Text(
                'Order Available',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              orderAvailableWidget(
                orderAvailable: orderAvailable,
                onChanged: (value) {
                  setState(() {
                    orderAvailable = value;
                  });
                },
              ),
              SizedBox(height: 25),
              customButton(
                text: isLoading
                    ? 'Please wait...'
                    : isEditing
                    ? 'Update Product'
                    : 'Add Product',
                onTap: isLoading
                    ? null
                    : () async {
                        if (productNameController.text.trim().isEmpty ||
                            priceController.text.trim().isEmpty ||
                            (selectedImage == null &&
                                imageUrlController.text.trim().isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all required fields'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          String imageUrl = imageUrlController.text.trim();
                          if (selectedImage != null) {
                            imageUrl = await productImageServices
                                .uploadProductImage(selectedImage!);
                          }

                          if (!mounted) return;

                          final success = await submitProduct(
                            context: context,
                            productId: widget.product?['id']?.toString(),
                            name: productNameController.text.trim(),
                            price: priceController.text.trim(),
                            image: imageUrl,
                            category: selectedCategory,
                            description: descriptionController.text.trim(),
                            orderAvailable: orderAvailable,
                          );
                          if (!mounted) return;
                          if (success) {
                            Navigator.pop(context, true);
                          }
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        } finally {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                borderRadius: 12,
                textColor: Colors.white,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
