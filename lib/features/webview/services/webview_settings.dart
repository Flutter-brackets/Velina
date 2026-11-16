import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webview_scripts.dart';

/// Preconfigured high-performance settings and tab endpoints for Salla WebView.
class VelinaWebViewSettings {
  const VelinaWebViewSettings._();

  static final InAppWebViewSettings settings = InAppWebViewSettings(
    cacheEnabled: true,
    cacheMode: CacheMode.LOAD_DEFAULT,
    domStorageEnabled: true,
    databaseEnabled: true,
    hardwareAcceleration: true,
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    transparentBackground: true,
    allowsBackForwardNavigationGestures: true,
    supportZoom: false,
    thirdPartyCookiesEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
  );

  static void handleTabAction(
    InAppWebViewController? controller,
    int index, {
    bool isArabic = true,
  }) {
    final lang = isArabic ? 'ar' : 'en';
    switch (index) {
      case 0:
        controller?.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://velinaboutiquesa.com/$lang'),
          ),
        );
      case 1:
        controller?.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://velinaboutiquesa.com/$lang/cart'),
          ),
        );
      case 2:
        controller?.evaluateJavascript(source: WebviewScripts.loginTriggerJs);
      case 3:
        controller?.evaluateJavascript(source: WebviewScripts.searchTriggerJs);
    }
  }

  static Future<void> syncStoreMeta(
    InAppWebViewController? controller,
    void Function({int? cartCount, bool? isArabic}) onUpdate,
  ) async {
    if (controller == null) return;
    try {
      final lang = await controller.evaluateJavascript(
        source: 'document.documentElement.lang || ""',
      );
      final isAr =
          lang == null ||
          lang.toString().isEmpty ||
          !lang.toString().startsWith('en');
      final cartRes = await controller.evaluateJavascript(
        source:
            'document.querySelector(".cart-badge, .badge--count, [data-cart-count]")?.textContent || "0"',
      );
      final digits =
          cartRes?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
      onUpdate(cartCount: int.tryParse(digits) ?? 0, isArabic: isAr);
    } catch (_) {}
  }
}
