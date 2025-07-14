import 'dart:io';
import 'package:astronacci_fe/app/data/models/user_model.dart';
import 'package:astronacci_fe/app/data/services/user_services.dart';
import 'package:astronacci_fe/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final UserServices _userServices = UserServices();

  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> users = <UserModel>[].obs;
  RxInt currentPage = 1.obs;
  final int usersPerPage = 7;

  RxString searchQuery = ''.obs;

  Rxn<File> pickedImage = Rxn<File>();
  RxString profilePhotoUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchAndPrintUsers();
  }

  Future<void> pickAndCropPhoto(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: result.files.single.path!,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Photo'),
        ],
      );

      if (croppedFile != null) {
        final file = File(croppedFile.path);

        // update locally
        pickedImage.value = file;

        // upload to Supabase
        await uploadProfilePhoto(file);

        Get.snackbar("Success", "Profile photo updated and uploaded");
      }
    }
  }

  void setPickedImage(File? file) {
    pickedImage.value = file;
  }

  void showProfilePhoto(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (pickedImage.value != null) {
                      // Kalau baru saja pick gambar dari device
                      return Image.file(
                        pickedImage.value!,
                        height: 250,
                        fit: BoxFit.cover,
                      );
                    } else if (profilePhotoUrl.value.isNotEmpty) {
                      // Kalau sudah ada di Supabase
                      return Image.network(
                        profilePhotoUrl.value,
                        height: 250,
                        fit: BoxFit.cover,
                      );
                    } else {
                      // Default
                      return Container(
                        height: 250,
                        width: 250,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, size: 100),
                      );
                    }
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Get.back(closeOverlays: true);
                      await pickAndCropPhoto(context);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile Photo"),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void showProfilePhotoWithOutEdit(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (pickedImage.value != null) {
                      // Kalau baru saja pick gambar dari device
                      return Image.file(
                        pickedImage.value!,
                        height: 250,
                        fit: BoxFit.cover,
                      );
                    } else if (profilePhotoUrl.value.isNotEmpty) {
                      // Kalau sudah ada di Supabase
                      return Image.network(
                        profilePhotoUrl.value,
                        height: 250,
                        fit: BoxFit.cover,
                      );
                    } else {
                      // Default
                      return Container(
                        height: 250,
                        width: 250,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, size: 100),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> loadProfilePhoto() async {
    final userId = Get.find<AuthenticationController>().userModel?.id;
    if (userId == null) return;

    final storage = Supabase.instance.client.storage.from('profilephotos');
    final path = 'users/$userId.jpg';

    final publicUrl = storage.getPublicUrl(path);
    profilePhotoUrl.value = publicUrl;

    debugPrint("✅ Public URL: $publicUrl");
  }

  Future<void> uploadProfilePhoto(File file) async {
    final authController = Get.find<AuthenticationController>();
    final userId = authController.userModel?.id;

    if (userId == null) {
      Get.snackbar("Error", "User ID not found");
      return;
    }

    final path = 'users/$userId.jpg';

    try {
      await Supabase.instance.client.storage
          .from('profilephotos')
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      final publicUrl = Supabase.instance.client.storage
          .from('profilephotos')
          .getPublicUrl(path);

      profilePhotoUrl.value =
          '$publicUrl?${DateTime.now().millisecondsSinceEpoch}';

      Get.snackbar("Success", "Profile photo uploaded");
    } catch (e) {
      Get.snackbar("Error", "Failed to upload photo: $e");
    }
  }

  void fetchAndPrintUsers() async {
    try {
      final fetchedUsers = await _userServices.getAllUsers();

      if (fetchedUsers.isEmpty) {
      } else {
        allUsers.assignAll(fetchedUsers);
        users.assignAll(fetchedUsers);
      }
    } catch (e) {}
  }

  void searchUsers(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      users.assignAll(allUsers);
    } else {
      users.assignAll(
        allUsers.where((user) {
          final name = user.displayName.toLowerCase();
          final email = user.email.toLowerCase();
          final q = query.toLowerCase();
          return name.contains(q) || email.contains(q);
        }),
      );
    }

    currentPage.value = 1;
  }
}
