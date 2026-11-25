import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webview_scripts.dart';

/// Preconfigured high-performance settings and tab endpoints for Salla WebView.
class VelinaWebViewSettings {
  const VelinaWebViewSettings._();

  static final InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    cacheEnabled: true,
    incognito: false,
    sharedCookiesEnabled: true,
    allowsBackForwardNavigationGestures: true,
    disableHorizontalScroll: false,
    disableVerticalScroll: false,
    decelerationRate: ScrollViewDecelerationRate.NORMAL,
    allowsInlineMediaPlayback: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    useHybridComposition: true,
    mediaPlaybackRequiresUserGesture: false,
    transparentBackground: true,
    supportZoom: false,
    thirdPartyCookiesEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    isInspectable: kDebugMode,
  );

  static Future<void> handleTabAction(
    InAppWebViewController? controller,
    int index, {
    bool isArabic = true,
  }) async {
    if (controller == null) return;
    final lang = isArabic ? 'ar' : 'en';
    if (index == 0 || index == 1) {
      final target = index == 0 ? 'https://velinaboutiquesa.com/$lang' : 'https://velinaboutiquesa.com/$lang/cart';
      final cur = (await controller.getUrl())?.toString().toLowerCase().replaceAll(RegExp(r'/+$'), '') ?? '';
      final tgt = target.toLowerCase().replaceAll(RegExp(r'/+$'), '');
      if (cur == tgt || (index == 0 && (cur == 'https://velinaboutiquesa.com' || cur == 'https://velinaboutiquesa.com/$lang'))) {
        await controller.evaluateJavascript(source: "window.scrollTo({ top: 0, behavior: 'smooth' });");
      } else {
        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri(target), cachePolicy: URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY),
        );
      }
    } else if (index == 2) {
      await controller.evaluateJavascript(source: WebviewScripts.loginTriggerJs);
    } else if (index == 3) {
      await controller.evaluateJavascript(source: WebviewScripts.searchTriggerJs);
    }
  }

  static Future<void> syncStoreMeta(
    InAppWebViewController? controller,
    void Function({int? cartCount, bool? isArabic}) onUpdate,
  ) async {
    if (controller == null) return;
    try {
      final lang = await controller.evaluateJavascript(source: 'document.documentElement.lang || ""');
      final isAr = lang == null || lang.toString().isEmpty || !lang.toString().startsWith('en');
      final cartRes = await controller.evaluateJavascript(
        source: 'document.querySelector(".cart-badge, .badge--count, [data-cart-count]")?.textContent || "0"',
      );
      final digits = cartRes?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
      onUpdate(cartCount: int.tryParse(digits) ?? 0, isArabic: isAr);
    } catch (_) {}
  }
}
