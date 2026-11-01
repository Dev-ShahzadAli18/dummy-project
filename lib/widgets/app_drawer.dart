import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/search_page.dart';
import 'package:dummy_project/pages/cart_page.dart';
import 'package:dummy_project/pages/favourites_page.dart';
import 'package:dummy_project/pages/login_page.dart';
import 'package:dummy_project/pages/my_orders_page.dart';
import 'package:dummy_project/pages/profile_page.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget customDrawer(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  final screenWidth = ResponsiveLayout.widthOf(context);
  final isWide =
      ResponsiveLayout.sizeOf(
        context,
        breakpoints: ResponsiveBreakpoints(tablet: 600, tabletInclusive: false),
      ) !=
      ResponsiveSize.mobile;

  final drawerWidth = isWide ? 320.0 : screenWidth * 0.80;

  return Drawer(
    width: drawerWidth,
    backgroundColor: Colors.white,
    child: SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isWide ? 24 : 20,
            ),
            child: user == null
                ? Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Guest User'),
                    ],
                  )
                : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data();

                      final name = data?['UserName']?.toString() ?? 'User Name';

                      final email =
                          data?['Email']?.toString() ??
                          user.email ??
                          'User email';

                      return Column(
                        children: [
                          CircleAvatar(
                            radius: isWide ? 35 : 38,
                            backgroundColor: Colors.grey.shade200,
                            child: Text(
                              name != 'User Name' && name.isNotEmpty
                                  ? name[0].toUpperCase()
                                  : 'J',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Search'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_checkout_rounded),
                  title: Text('My Cart'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text('Favourite'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavouritePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag_outlined),
                  title: Text('My Orders'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyOrdersPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color.fromARGB(255, 87, 206, 93),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);

                        await FirebaseAuth.instance.signOut();

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
