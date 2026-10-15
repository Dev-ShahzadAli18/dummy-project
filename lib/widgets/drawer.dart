import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/Search.dart';
import 'package:dummy_project/pages/carpage.dart';
import 'package:dummy_project/pages/favourite.dart';
import 'package:dummy_project/pages/login.dart';
import 'package:dummy_project/pages/myorder.dart';
import 'package:dummy_project/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget customDrawer(BuildContext context) {
  final width = MediaQuery.widthOf(context);
  final user = FirebaseAuth.instance.currentUser;

  return Drawer(
    width: width * .67,
    backgroundColor: Colors.white,
    child: SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data();
                final name = data?['UserName']?.toString() ?? 'User Name';
                final email =
                    data?['Email']?.toString() ?? user.email ?? 'No email';
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        name != 'User Name' && name.isNotEmpty
                            ? name[0].toUpperCase()
                            : 'G',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
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
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
  );
}
