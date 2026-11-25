import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/constants/salla_injection.dart';
import '../cubit/webview_cubit.dart';
import '../services/url_handler_service.dart';
import '../services/webview_scripts.dart';
import '../services/webview_settings.dart';

/// Pre-configured InAppWebView viewport for Velina luxury boutique.
class WebViewViewport extends StatelessWidget {
  final WebViewCubit cubit;
  final ValueChanged<InAppWebViewController> onCreated;

  const WebViewViewport({
    super.key,
    required this.cubit,
    required this.onCreated,
  });

  void _inject(InAppWebViewController c) =>
      c.evaluateJavascript(source: SallaInjection.injectSallaFixes);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(AppUrls.baseUrl),
        cachePolicy: URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY,
      ),
      initialSettings: VelinaWebViewSettings.settings,
      initialUserScripts: WebviewScripts.initialUserScripts,
      onWebViewCreated: (c) {
        onCreated(c);
        c.addJavaScriptHandler(
          handlerName: 'onModalState',
          callback: (a) => cubit.setModalOpen(a.isNotEmpty && a[0] == true),
        );
        c.addJavaScriptHandler(
          handlerName: 'onDrawerStateChanged',
          callback: (a) => cubit.setDrawerOpen(a.isNotEmpty && a[0] == true),
        );
        c.addJavaScriptHandler(
          handlerName: 'onCartCount',
          callback: (a) => a.isNotEmpty && a[0] is num ? cubit.updateCartCount((a[0] as num).toInt()) : null,
        );
      },
      shouldOverrideUrlLoading: (_, act) async {
        final u = act.request.url;
        if (act.isForMainFrame && u != null && u.host.contains('velinaboutiquesa.com') && u.fragment.isEmpty) {
          cubit.triggerTransitionLoader();
        }
        return UrlHandlerService.handleUrl(act);
      },
      onLoadStart: (_, uri) => cubit.onPageStarted(uri),
      onProgressChanged: (c, p) => cubit.onProgressChanged(p),
      onPageCommitVisible: (c, uri) => cubit.onPageCommitVisible(uri),
      onLoadStop: (c, uri) {
        _inject(c);
        cubit.onPageLoaded(uri);
        VelinaWebViewSettings.syncStoreMeta(c, cubit.updateStoreMeta);
      },
      onUpdateVisitedHistory: (_, u, r) => (r != true) ? cubit.syncTabWithUrl(u) : null,
      onScrollChanged: (_, x, y) => cubit.updateScroll(y),
    );
  }
}
