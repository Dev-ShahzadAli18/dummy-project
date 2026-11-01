import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/profile_page.dart';
import 'package:dummy_project/services/login_service.dart';
import 'package:dummy_project/services/profileservices/profile_service.dart';
import 'package:dummy_project/widgets/profile_image_dialog.dart';
import 'package:dummy_project/pages/cart_page.dart';
import 'package:dummy_project/pages/my_orders_page.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileMenuPage extends StatelessWidget {
  ProfileMenuPage({super.key});

  final ProfileServices profileServices = ProfileServices();

  static const Color primaryColor = Color.fromARGB(255, 255, 193, 7);
  static const Color backgroundColor = Color.fromARGB(255, 248, 248, 248);

  void openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ResponsiveLayout.builder(
          breakpoints: ResponsiveBreakpoints(tablet: 600, desktop: 1024),
          builder: (context, size, constraints) {
            final isWide = size != ResponsiveSize.mobile;
            final isDesktop = size == ResponsiveSize.desktop;

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: profileServices.getProfileData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Unable to load profile.'));
                }

                final data = snapshot.data?.data();

                if (data == null) {
                  return Center(child: Text('Profile data not found.'));
                }

                final name = data['UserName']?.toString() ?? 'Not added';
                final email =
                    data['Email']?.toString() ??
                    FirebaseAuth.instance.currentUser?.email ??
                    'Not added';
                final image = data['profileImage']?.toString() ?? '';
                final accountTiles = [
                  menuTile(
                    icon: Icons.person_outline,
                    title: 'Account Details',
                    onTap: () => openPage(context, ProfilePage()),
                  ),
                  menuTile(
                    icon: Icons.shopping_cart_outlined,
                    title: 'My Cart',
                    onTap: () => openPage(context, CartPage()),
                  ),
                  menuTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'My Orders',
                    onTap: () => openPage(context, MyOrdersPage()),
                  ),
                ];

                return ResponsiveContent(
                  maxWidth: isDesktop
                      ? 1000
                      : isWide
                      ? 760
                      : double.infinity,
                  child: ListView(
                    padding: EdgeInsets.all(isWide ? 28 : 18),
                    children: [
                      Container(
                        padding: EdgeInsets.all(isWide ? 26 : 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showFullProfileImage(context, image);
                              },
                              child: CircleAvatar(
                                radius: isWide ? 44 : 37,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: image.isNotEmpty
                                    ? NetworkImage(image)
                                    : null,
                                child: image.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: isWide ? 46 : 40,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: isWide ? 20 : 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: isWide ? 20 : 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: isWide ? 14 : 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                openPage(context, ProfilePage());
                              },
                              icon: Icon(Icons.edit_outlined),
                              style: IconButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                  255,
                                  255,
                                  245,
                                  214,
                                ),
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isWide ? 32 : 25),

                      Text(
                        'MY ACCOUNT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          letterSpacing: 1,
                        ),
                      ),

                      SizedBox(height: isWide ? 16 : 12),

                      if (isDesktop)
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 0,
                          childAspectRatio: 5.2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: accountTiles,
                        )
                      else
                        ...accountTiles,

                      SizedBox(height: 18),

                      menuTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        isLogout: true,
                        onTap: () {
                          logout(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: isLogout
                ? Colors.red.shade50
                : Color.fromARGB(255, 255, 245, 214),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isLogout ? Colors.red : Colors.black),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
