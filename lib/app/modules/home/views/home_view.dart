import 'package:astronacci_fe/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:astronacci_fe/app/modules/home/views/user_account_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final authController = Get.find<AuthenticationController>();

  @override
  @override
  Widget build(BuildContext context) {
    controller.fetchAndPrintUsers();
    controller.loadProfilePhoto();

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => const UserAccountView());
            },
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Obx(() {
                final photoUrl = controller.profilePhotoUrl.value;
                if (photoUrl.isNotEmpty) {
                  // Kalau sudah ada foto
                  return CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(photoUrl),
                  );
                } else {
                  // Belum ada foto
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue.shade200,
                    child: const Icon(Icons.person, color: Colors.white),
                  );
                }
              }),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search user by name or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: controller.searchUsers,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.users.isEmpty) {
                return const Center(child: Text('No users found.'));
              }

              final totalPages =
                  (controller.users.length / controller.usersPerPage).ceil();
              final startIndex =
                  (controller.currentPage.value - 1) * controller.usersPerPage;
              final endIndex = (startIndex + controller.usersPerPage).clamp(
                0,
                controller.users.length,
              );

              final usersOnPage = controller.users.sublist(
                startIndex,
                endIndex,
              );

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: usersOnPage.length,
                      itemBuilder: (context, index) {
                        final user = usersOnPage[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Text(user.displayName),
                            subtitle: Text(user.email),
                            trailing: IconButton(
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('User Details'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailRow('Email', user.email),
                                        _buildDetailRow(
                                          'Display Name',
                                          user.displayName,
                                        ),
                                        _buildDetailRow(
                                          'Created At',
                                          user.createdAt?.toString() ?? '-',
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed:
                            controller.currentPage.value > 1
                                ? () => controller.currentPage.value--
                                : null,
                      ),
                      ...List.generate(totalPages, (index) {
                        final page = index + 1;
                        return TextButton(
                          onPressed: () => controller.currentPage.value = page,
                          child: Text(
                            '$page',
                            style: TextStyle(
                              fontWeight:
                                  controller.currentPage.value == page
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed:
                            controller.currentPage.value < totalPages
                                ? () => controller.currentPage.value++
                                : null,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
