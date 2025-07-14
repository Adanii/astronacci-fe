import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  void init() {
    Get.log('📲 DeepLinkService initialized');

    _appLinks.uriLinkStream.listen(
      (uri) {
        Get.log('🔗 Deep link: $uri');
        _handleUri(uri);
      },
      onError: (err) {
        Get.log(' Error in uriLinkStream: $err');
      },
    );
  }

  void _handleUri(Uri uri) {
    Get.log('🧩 Handling URI: $uri');

    final code = uri.queryParameters['code'];
    Get.log('🔍 code: $code');
    Get.log('🔍 FULL URI: $uri');
    Get.log('🔍 queryParameters: ${uri.queryParameters}');

    if (code == null || code.isEmpty) {
      Get.log(' Missing code!');
      return;
    }

    Get.log('➡️ Navigating to /reset-password with code: $code');
    Get.toNamed('/reset-password', arguments: {'code': code});
  }
}
