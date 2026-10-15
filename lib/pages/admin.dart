import 'package:dummy_project/pages/addproduct.dart';
import 'package:dummy_project/pages/adminorderspages.dart';
import 'package:dummy_project/pages/adminproduct.dart';
import 'package:dummy_project/pages/allproduct.dart';
import 'package:dummy_project/pages/favourite.dart';
import 'package:dummy_project/pages/login.dart';
import 'package:dummy_project/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  List<Map> adminItems = [
    {
      'title': 'Profile',
      'icon': Icons.person,
      'color': Colors.teal,
      "iconcolor": const Color.fromARGB(255, 207, 227, 238),
    },
    {
      'title': 'Products',
      'icon': Icons.shopping_bag_outlined,
      'color': Colors.blue,
      "iconcolor": const Color.fromARGB(255, 212, 225, 231),
    },
    {
      'title': 'My Products',
      'icon': Icons.inventory_2_outlined,
      'color': Colors.indigo,
      'iconcolor': Colors.white,
    },
    {
      'title': 'Users',
      'icon': Icons.people_outline,
      'color': Colors.green,
      "iconcolor": const Color.fromARGB(255, 214, 228, 236),
    },
    {
      'title': 'Add Product',
      'icon': Icons.add_box_outlined,
      'color': Colors.orange,
      "iconcolor": const Color.fromARGB(255, 130, 138, 142),
    },
    {
      'title': 'Orders',
      'icon': Icons.receipt_long_outlined,
      'color': Colors.purple,
      "iconcolor": const Color.fromARGB(255, 207, 227, 238),
    },
    {
      'title': 'Favorites',
      'icon': Icons.favorite_border,
      'color': Colors.pink,
      "iconcolor": Colors.white,
    },
    {
      'title': 'Logout',
      'icon': Icons.logout,
      'color': Colors.red,
      "iconcolor": const Color.fromARGB(255, 62, 2, 2),
    },
  ];

  void openAdminItem(BuildContext context, String title) async {
    if (title == 'Logout') {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } else if (title == 'Products') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Allproduct(product: {})),
      );
    } else if (title == 'Add Product') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddProductPage()),
      );
    } else if (title == 'Profile') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (title == 'My Products') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyProductPage()),
      );
    } else if (title == 'Favorites') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavouritePage()),
      );
    } else if (title == 'Orders') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminOrdersPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Manage your online store',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 22),
            Expanded(
              child: GridView.builder(
                itemCount: adminItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final item = adminItems[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      openAdminItem(context, item['title']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: item['color'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item['icon'],
                              size: 30,
                              color: item['iconcolor'],
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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
