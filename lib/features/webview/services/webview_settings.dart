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
    cacheMode: CacheMode.LOAD_DEFAULT,
    domStorageEnabled: true,
    databaseEnabled: true,
    sharedCookiesEnabled: true,
    thirdPartyCookiesEnabled: true,
    hardwareAcceleration: true,
    offscreenPreRaster: true,
    rendererPriorityPolicy: RendererPriorityPolicy(
      rendererRequestedPriority: RendererPriority.RENDERER_PRIORITY_IMPORTANT,
      waivedWhenNotVisible: false,
    ),
    decelerationRate: ScrollViewDecelerationRate.NORMAL,
    allowsBackForwardNavigationGestures: true,
    disableHorizontalScroll: false,
    disableVerticalScroll: false,
    allowsInlineMediaPlayback: true,
    transparentBackground: true,
    supportZoom: false,
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
    if (index == 0) {
      final target = 'https://velinaboutiquesa.com/$lang';
      final cur = (await controller.getUrl())?.toString().toLowerCase().replaceAll(RegExp(r'/+$'), '') ?? '';
      final tgt = target.toLowerCase().replaceAll(RegExp(r'/+$'), '');
      if (cur == tgt || cur == 'https://velinaboutiquesa.com' || cur == 'https://velinaboutiquesa.com/$lang') {
        await controller.evaluateJavascript(source: "window.scrollTo({ top: 0, behavior: 'smooth' });");
        return;
      }
      final history = await controller.getCopyBackForwardList();
      final list = history?.list;
      final currentIdx = history?.currentIndex;
      if (list != null && currentIdx != null) {
        for (int i = currentIdx - 1; i >= 0; i--) {
          final u = list[i].url?.toString().toLowerCase().replaceAll(RegExp(r'/+$'), '') ?? '';
          if (u == 'https://velinaboutiquesa.com' || u == 'https://velinaboutiquesa.com/$lang' || u == tgt) {
            await controller.goBackOrForward(steps: i - currentIdx);
            return;
          }
        }
      }
      await controller.loadUrl(urlRequest: URLRequest(url: WebUri(target), cachePolicy: URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY));
    } else if (index == 1) {
      final cur = (await controller.getUrl())?.toString().toLowerCase() ?? '';
      if (cur.contains('/cart')) {
        await controller.evaluateJavascript(source: "window.scrollTo({ top: 0, behavior: 'smooth' });");
      } else {
        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri('https://velinaboutiquesa.com/$lang/cart'), cachePolicy: URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY),
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
