import 'package:astronacci_fe/app/data/services/deep_links_services.dart';
import 'package:astronacci_fe/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kbqaxsltidorteskyavs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImticWF4c2x0aWRvcnRlc2t5YXZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIxNTQyOTcsImV4cCI6MjA2NzczMDI5N30.zMcvfVdue9YLPENK6sISSxkxOrI3FSXzFIfRMKH4GgY',
  );
  // Init deep link service
  final deepLinkService = DeepLinkService();
  deepLinkService.init();

  Get.log('✅ DeepLinkService initialized & listening');
  Get.put(AuthenticationController());

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );

  Get.log('🏁 App running with initial route: ${AppPages.INITIAL}');
}
