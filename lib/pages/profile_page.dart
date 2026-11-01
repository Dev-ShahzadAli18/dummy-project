import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/profile_detail_page.dart';
import 'package:dummy_project/services/profileservices/product_image_service.dart';
import 'package:dummy_project/widgets/buttons.dart';
import 'package:dummy_project/widgets/profile_image_dialog.dart';
import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dummy_project/services/profileservices/profile_service.dart';

final ProfileServices profileServices = ProfileServices();
final ProfileImageServices profileImageServices = ProfileImageServices();

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveLayout.builder(
          breakpoints: ResponsiveBreakpoints(
            tablet: 700,
            tabletInclusive: false,
          ),
          builder: (context, size, constraints) {
            return _buildProfile(
              context,
              user,
              isWeb: size != ResponsiveSize.mobile,
              horizontalPadding: size != ResponsiveSize.mobile ? 35 : 15,
              profileRadius: size != ResponsiveSize.mobile ? 150 : 55,
              nameSize: size != ResponsiveSize.mobile ? 25 : 21,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    User user, {
    required bool isWeb,
    required double horizontalPadding,
    required double profileRadius,
    required double nameSize,
  }) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: profileServices.getProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading profile: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: Text('Profile data not found'));
        }

        final data = snapshot.data!.data();

        if (data == null) {
          return Center(child: Text('Profile data is empty'));
        }

        final name = data['UserName']?.toString() ?? 'Not added';
        final email = data['Email']?.toString() ?? user.email ?? 'Not added';
        final phone = data['Phone']?.toString() ?? 'Not added';
        final role = data['role']?.toString() ?? 'User';
        final profileImage = data['profileImage']?.toString() ?? '';
        final age = data['Age']?.toString() ?? 'Not added';

        final profileData = [
          {
            'title': 'Name',
            'value': name,
            'field': 'UserName',
            'icon': Icons.person,
          },
          {
            'title': 'Email',
            'value': email,
            'field': 'Email',
            'icon': Icons.email,
          },
          {
            'title': 'Phone',
            'value': phone,
            'field': 'Phone',
            'icon': Icons.phone,
          },
          {
            'title': 'Age',
            'value': age,
            'field': 'Age',
            'icon': Icons.cake_outlined,
          },
          {
            'title': 'Role',
            'value': role,
            'field': 'role',
            'icon': Icons.verified_user,
          },
        ];

        Widget profileImageWidget = GestureDetector(
          onTap: isUploading
              ? null
              : () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (sheetContext) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Take Photo'),
                              onTap: () async {
                                Navigator.pop(sheetContext);

                                setState(() {
                                  isUploading = true;
                                });

                                try {
                                  await profileServices
                                      .pickAndUploadProfileImage(
                                        ImageSource.camera,
                                      );

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Profile picture saved'),
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Upload failed: $e'),
                                    ),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isUploading = false;
                                    });
                                  }
                                }
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Choose from Gallery'),
                              onTap: () async {
                                Navigator.pop(sheetContext);

                                setState(() {
                                  isUploading = true;
                                });

                                try {
                                  await profileServices
                                      .pickAndUploadProfileImage(
                                        ImageSource.gallery,
                                      );

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Profile picture saved'),
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Upload failed: $e'),
                                    ),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isUploading = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showFullProfileImage(context, profileImage);
                },
                child: CircleAvatar(
                  radius: profileRadius,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  child: profileImage.isEmpty
                      ? Text(
                          name.isNotEmpty && name != 'Not added'
                              ? name[0].toUpperCase()
                              : '',
                          style: TextStyle(
                            fontSize: profileRadius * 0.55,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      : null,
                ),
              ),
              if (isUploading)
                CircleAvatar(
                  radius: profileRadius,
                  backgroundColor: Colors.black38,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        );

        Widget profileDetails = Column(
          children: profileData.map((item) {
            return InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetailPage(
                      title: item['title'] as String,
                      field: item['field'] as String,
                      value: item['value'].toString(),
                      uid: user.uid,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['value'].toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            );
          }).toList(),
        );

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 15,
              ),
              child: Row(
                children: [
                  customIconButton(
                    height: 40,
                    width: 40,
                    icon: Icons.arrow_back,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Spacer(),
                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: isWeb
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey.shade100,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    profileImageWidget,
                                    SizedBox(height: 18),
                                    Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: nameSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      email,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 35,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile Details',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'View and update your personal information.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 25),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: profileDetails,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            profileImageWidget,
                            SizedBox(height: 12),
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: nameSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              email,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Profile Details',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'View and update your personal information.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            profileDetails,
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
