import 'package:astronacci_fe/app/constant/app_color.dart';
import 'package:astronacci_fe/app/constant/app_size.dart';
import 'package:astronacci_fe/app/constant/app_spacing.dart';
import 'package:astronacci_fe/app/constant/app_text_style.dart';
import 'package:astronacci_fe/app/data/models/user_model.dart';
import 'package:astronacci_fe/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:astronacci_fe/app/modules/authentication/widgets/validation_row.dart';
import 'package:astronacci_fe/app/widgets/custom_elevated_button.dart';
import 'package:astronacci_fe/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<AuthenticationController> {
  final formKey = GlobalKey<FormState>();
  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initData();
    return Scaffold(
      appBar: AppBar(title: Text("Register Account")),
      body: Padding(
        padding: AppSize.paddingLarge,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                    hintText: "Name*",
                    hintStyle: AppTextStyles.hintText,
                    controller: controller.displayNameController,
                  ),

                  AppSpace.h20,
                  CustomTextField(
                    hintText: "Email",
                    hintStyle: AppTextStyles.hintText,
                    controller: controller.emailController,
                    validatorMessage:
                        (value) =>
                            !controller.isEmail(value!)
                                ? "Please enter a valid email!"
                                : null,
                    onChanged: (value) {
                      formKey.currentState!.validate();
                    },
                  ),
                  AppSpace.h20,
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: 'Password*',
                          controller: controller.passwordController,
                          hintStyle: AppTextStyles.hintText,
                          obsecure: controller.passwordVisible.value,
                          focusNode: controller.passwordFocus,
                          // ikon eye

                          // validator untuk Form (jika dibutuhkan)
                          validatorMessage: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot empty!';
                            }
                            // tambahkan syarat lain jika perlu
                            return null;
                          },
                          onChanged: (value) {
                            formKey.currentState!.validate();
                          },
                        ),
                        AppSpace.h10,
                        Obx(
                          () =>
                              controller.isTypingPassword.value
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppSpace.h10,
                                      buildValidationRow(
                                        "Contain Uppercase",
                                        controller.hasUppercase,
                                      ),
                                      buildValidationRow(
                                        "Contain Lower Case",
                                        controller.hasLowercase,
                                      ),
                                      buildValidationRow(
                                        "Contain Number(s)",
                                        controller.hasDigit,
                                      ),
                                    ],
                                  )
                                  : SizedBox.shrink(),
                        ),
                        AppSpace.h10,
                        Obx(() {
                          return CustomTextField(
                            hintText: "Confirm Password*",
                            controller: controller.confirmPasswordController,
                            hintStyle: AppTextStyles.hintText,
                            obsecure: controller.passwordVisible.value,
                            iconSuffix: InkWell(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              splashColor: AppColor.info,
                              child:
                                  controller.passwordVisible.value
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                              onTap: () {
                                controller.unHide();
                              },
                            ),
                            validatorMessage: (value) {
                              if (value!.isEmpty) {
                                return "Please fill the confirm password";
                              }

                              if (value != controller.password.value) {
                                return "Password do not match!";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              formKey.currentState!.validate();
                            },
                          );
                        }),
                        AppSpace.h20,
                        CustomElevatedButton(
                          icon: Icon(
                            Icons.cloud_upload_outlined,
                            color: AppColor.iconWhite,
                          ),
                          width: AppSize.infinity,
                          backgroundColor: AppColor.darkBlueGrey,
                          text: "Daftar",
                          onPressed: () async {
                            UserModel user = UserModel(
                              email: controller.emailController.text,
                              displayName:
                                  controller.displayNameController.text,
                              password: controller.passwordController.text,
                            );

                            try {
                              await controller.registerService(user);
                            } catch (_) {
                              // sudah ditangani dialog di dalam
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
