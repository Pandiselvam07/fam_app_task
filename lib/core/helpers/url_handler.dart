import 'package:url_launcher/url_launcher.dart';

class UrlHandler {
  static Future<void> handleTap(String? url) async {
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }
}
