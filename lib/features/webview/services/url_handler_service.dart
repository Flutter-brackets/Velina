import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHandlerService {
  const UrlHandlerService._();

  static const List<String> _externalSchemes = [
    'tel',
    'mailto',
    'sms',
    'whatsapp',
    'intent',
  ];

  static Future<NavigationActionPolicy> handleUrl(
    NavigationAction navigationAction,
  ) async {
    final uri = navigationAction.request.url;
    if (uri == null) return NavigationActionPolicy.ALLOW;

    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();

    final isWhatsAppWeb =
        host.contains('wa.me') || host.contains('whatsapp.com');
    final isCustomScheme =
        _externalSchemes.contains(scheme) ||
        (!['http', 'https', 'about'].contains(scheme));

    if (isCustomScheme || isWhatsAppWeb) {
      try {
        final launchableUri = Uri.parse(uri.toString());
        if (await canLaunchUrl(launchableUri)) {
          await launchUrl(launchableUri, mode: LaunchMode.externalApplication);
        }
      } catch (_) {
        // Prevent WebView crash on unhandled intent/scheme
      }
      return NavigationActionPolicy.CANCEL;
    }

    return NavigationActionPolicy.ALLOW;
  }
}
