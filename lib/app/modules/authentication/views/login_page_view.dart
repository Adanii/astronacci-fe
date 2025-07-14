import 'package:astronacci_fe/app/constant/app_color.dart';
import 'package:astronacci_fe/app/constant/app_size.dart';
import 'package:astronacci_fe/app/constant/app_spacing.dart';
import 'package:astronacci_fe/app/constant/app_text_style.dart';
import 'package:astronacci_fe/app/modules/authentication/views/forgot_passowrd_view.dart';
import 'package:astronacci_fe/app/modules/authentication/views/register_page_view.dart';
import 'package:astronacci_fe/app/widgets/custom_elevated_button.dart';
import 'package:astronacci_fe/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';

class LoginView extends GetView<AuthenticationController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: AppSize.infinity,
            width: AppSize.infinity,
            child: Padding(
              padding: AppSize.paddingMedium,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpace.h30,
                  Text(
                    "Mohon masukan Email & Password",
                    style: AppTextStyles.titleMedium,
                  ),
                  AppSpace.h10,
                  CustomTextField(
                    hintText: "Email",
                    controller: controller.emailController,
                    hintStyle: AppTextStyles.hintText,
                  ),
                  AppSpace.h10,
                  Obx(() {
                    return CustomTextField(
                      hintText: "Password",
                      controller: controller.passwordController,
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
                    );
                  }),
                  AppSpace.h10,
                  CustomElevatedButton(
                    icon: Icon(
                      Icons.logout_outlined,
                      color: AppColor.iconWhite,
                    ),
                    width: AppSize.infinity,
                    backgroundColor: AppColor.buttonPrimary,
                    text: "Login",
                    onPressed: () {
                      controller.loginService(
                        controller.emailController.text,
                        controller.passwordController.text,
                      );
                    },
                  ),
                  AppSpace.h10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Belum Punya Akun?"),
                      AppSpace.w5,
                      InkWell(
                        onTap: () {
                          Get.to(() => RegisterView());
                        },
                        child: Text(
                          "Daftar Sekarang!",
                          style: AppTextStyles.textButtonCustom,
                        ),
                      ),
                    ],
                  ),
                  AppSpace.h10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => ForgotPassowrdView());
                        },
                        child: Text(
                          "Forgot Password ?",
                          style: AppTextStyles.textButtonCustom,
                        ),
                      ),
                    ],
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
