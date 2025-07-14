import 'package:astronacci_fe/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:astronacci_fe/app/modules/home/controllers/home_controller.dart';
import 'package:astronacci_fe/app/modules/home/views/user_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAccountView extends GetView<HomeController> {
  const UserAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthenticationController>();
    final user = authController.userModel;
    controller.loadProfilePhoto();

    final Color headerColor = Colors.blueAccent.shade100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Account'),
        centerTitle: true,
        backgroundColor: headerColor,
      ),
      body: Stack(
        children: [
          // Background
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // Konten
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap:
                        () => controller.showProfilePhotoWithOutEdit(context),
                    child: Obx(() {
                      if (controller.pickedImage.value != null) {
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(
                            controller.pickedImage.value!,
                          ),
                        );
                      } else if (controller.profilePhotoUrl.value.isNotEmpty) {
                        // Dari storage
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            controller.profilePhotoUrl.value,
                          ),
                        );
                      } else {
                        // Default
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Username
                  Text(
                    user?.displayName ?? '-',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email
                  Text(
                    user?.email ?? '-',
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                  ),

                  const SizedBox(height: 32),

                  // ListTile: User Detail & Logout
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text("User Detail"),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Get.to(() => UserDetailView());
                          },
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text("Logout"),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await authController.logoutService();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
