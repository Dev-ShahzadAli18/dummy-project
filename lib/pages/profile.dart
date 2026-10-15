import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_project/pages/profieupdate.dart';
import 'package:dummy_project/services/profileservices/productimageservice.dart';
import 'package:dummy_project/widgets/button.dart';
import 'package:dummy_project/widgets/profileimage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dummy_project/services/profileservices/profile_servcices.dart';

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
      return Scaffold(body: Center(child: Text('Please login first')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: profileServices.getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error loading profile'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Profile data not found'));
            }

            final data = snapshot.data!.data();

            if (data == null) {
              return Center(child: Text('Profile data is empty'));
            }

            final name = data['UserName']?.toString() ?? 'Not added';
            final email =
                data['Email']?.toString() ?? user.email ?? 'Not added';
            final phone = data['Phone']?.toString() ?? 'Not added';
            final role = data['role']?.toString() ?? 'User';
            final profileImage = data['profileImage']?.toString() ?? '';

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
                'title': 'Role',
                'value': role,
                'field': 'role',
                'icon': Icons.verified_user,
              },
            ];

            return Column(
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
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Spacer(),
                      Text(
                        'Profile',
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

                SizedBox(height: 15),

                GestureDetector(
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

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Profile picture saved',
                                              ),
                                            ),
                                          );
                                        } catch (e) {
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

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Profile picture saved',
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          if (!mounted) return;

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Upload failed: $e',
                                              ),
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
                          radius: 55,
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
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      if (isUploading)
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.black54,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      if (!isUploading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  name,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 25),

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemCount: profileData.length,
                    itemBuilder: (context, index) {
                      final item = profileData[index];

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
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
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
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
