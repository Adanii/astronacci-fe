import 'package:astronacci_fe/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:astronacci_fe/app/modules/home/controllers/home_controller.dart';
import 'package:astronacci_fe/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailView extends GetView<AuthenticationController> {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    final user = controller.userModel;

    final userId = user?.id ?? '-';

    // Isi value ke controller yang sudah ada
    controller.emailController.text = user?.email ?? '';
    controller.displayNameController.text = user?.displayName ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('User Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Center(
              child: GestureDetector(
                onTap: () => homeController.showProfilePhoto(context),
                child: Obx(() {
                  if (homeController.pickedImage.value != null) {
                    // Yang baru di‑pick
                    return CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(
                        homeController.pickedImage.value!,
                      ),
                    );
                  } else if (homeController.profilePhotoUrl.value.isNotEmpty) {
                    // Dari storage
                    return CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        homeController.profilePhotoUrl.value,
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
            ),

            const SizedBox(height: 32),

            const Text(
              'User ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'User ID',
              controller: TextEditingController(text: userId),
              readOnly: true,
            ),

            const SizedBox(height: 16),

            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Email',
              controller: controller.emailController,
              readOnly: true,
            ),

            const SizedBox(height: 16),

            const Text(
              'Display Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: 'Display Name',
              controller: controller.displayNameController,
              readOnly: false,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateUserService();
                },
                child: const Text('Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
