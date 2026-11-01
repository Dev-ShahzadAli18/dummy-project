import 'package:dummy_project/pages/home_page.dart';
import 'package:dummy_project/pages/search_page.dart';
import 'package:dummy_project/pages/cart_page.dart';
import 'package:dummy_project/pages/favourites_page.dart';
import 'package:dummy_project/pages/login_page.dart';
import 'package:dummy_project/pages/my_orders_page.dart';
import 'package:dummy_project/pages/profile_page.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final PageController pageController = PageController();

  final List<String> pageNames = [
    'Home',
    'Search',
    'Cart',
    'Favorites',
    'My Orders',
    'Profile',
  ];

  final List<IconData> pageIcons = [
    Icons.home_outlined,
    Icons.search_rounded,
    Icons.shopping_cart_checkout,
    Icons.favorite_border_rounded,
    Icons.shopify_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout.builder(
      breakpoints: ResponsiveBreakpoints(tablet: 600, desktop: 800),
      builder: (context, size, constraints) {
        final isWeb = size == ResponsiveSize.desktop;

        return Scaffold(
          backgroundColor: Color(0xFFFAFAFA),
          body: Row(
            children: [
              if (isWeb) _buildSidebar(),

              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  children: [
                    Home(),
                    SearchPage(),
                    CartPage(),
                    FavouritePage(),
                    MyOrdersPage(),
                    ProfilePage(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWeb ? null : _buildMobileNavbar(),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 225,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 15, 32),
              child: InkWell(
                onTap: () => changePage(0),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shopping_bag_rounded,
                        color: Color.fromARGB(255, 255, 193, 7),
                        size: 23,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'JONSTORE',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'YOUR STYLE, YOUR STORE',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 7,
                              letterSpacing: 0.7,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 22, bottom: 14),
              child: Text(
                'MENU',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: Colors.grey.shade500,
                ),
              ),
            ),

            ...List.generate(
              pageNames.length,
              (index) => _buildSidebarItem(index),
            ),

            Spacer(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Divider(color: Colors.grey.shade200),
                  InkWell(
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

                                await FirebaseAuth.instance.signOut();

                                if (!context.mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
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
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                            size: 21,
                          ),
                          SizedBox(width: 13),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: Colors.red.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(int index) {
    final bool isSelected = selectedIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: () => changePage(index),
          borderRadius: BorderRadius.circular(11),
          hoverColor: Color(0xFFFFF8E1),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 46),
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Row(
              children: [
                Icon(
                  pageIcons[index],
                  size: 21,
                  color: isSelected ? Color(0xFFFFC107) : Colors.grey.shade600,
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Text(
                    pageNames[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC107),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
