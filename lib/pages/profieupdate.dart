import 'package:dummy_project/services/updatedata.dart' as profileFunctions;
import 'package:dummy_project/widgets/button.dart';
import 'package:flutter/material.dart';

class ProfileDetailPage extends StatefulWidget {
  final String title;
  final String field;
  final String value;
  final String uid;

  ProfileDetailPage({
    super.key,
    required this.title,
    required this.field,
    required this.value,
    required this.uid,
  });

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  late TextEditingController controller;
  bool isUpdating = false;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRole = widget.field == 'role';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Edit ${widget.title}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: controller,
              readOnly: isRole,
              keyboardType: widget.field == 'Phone'
                  ? TextInputType.phone
                  : TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter ${widget.title}',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 25),
            customButton(
              onTap: isUpdating
                  ? null
                  : () async {
                      setState(() {
                        isUpdating = true;
                      });
                      final success = await profileFunctions.updateProfile(
                        uid: widget.uid,
                        field: widget.field,
                        value: controller.text,
                        onError: (message) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        },
                      );
                      if (!mounted) return;
                      if (success) {
                        Navigator.pop(context, true);
                      } else {
                        setState(() {
                          isUpdating = false;
                        });
                      }
                    },
              child: isUpdating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
