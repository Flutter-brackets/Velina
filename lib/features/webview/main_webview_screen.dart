import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/notification_service.dart';
import 'cubit/webview_cubit.dart';
import 'cubit/webview_state.dart';
import 'services/webview_settings.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/luxury_page_loader.dart';
import 'widgets/offline_screen.dart';
import 'widgets/webview_progress_bar.dart';
import 'widgets/webview_viewport.dart';

class MainWebViewScreen extends StatelessWidget {
  const MainWebViewScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => WebViewCubit(), child: const _MainWebViewContent());
}

class _MainWebViewContent extends StatefulWidget {
  const _MainWebViewContent();
  @override
  State<_MainWebViewContent> createState() => _MainWebViewContentState();
}

class _MainWebViewContentState extends State<_MainWebViewContent> {
  InAppWebViewController? _c;

  @override
  void initState() { super.initState(); NotificationService.pendingUrl.addListener(_onPendingUrl); }

  @override
  void dispose() { NotificationService.pendingUrl.removeListener(_onPendingUrl); super.dispose(); }

  void _onPendingUrl() {
    final u = NotificationService.pendingUrl.value;
    if (u != null && _c != null) {
      _c?.loadUrl(urlRequest: URLRequest(url: WebUri(u), cachePolicy: URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY));
      NotificationService.clearPendingUrl();
    }
  }

  Future<void> _handleBack(bool didPop, dynamic _) async =>
      didPop ? null : ((await _c?.canGoBack() ?? false) ? await _c?.goBack() : await SystemNavigator.pop());

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WebViewCubit>();
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleBack,
      child: Scaffold(
        backgroundColor: AppColors.creamBackground,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              RepaintBoundary(
                child: WebViewViewport(key: const ValueKey('velina_stable_vp'), cubit: cubit, onCreated: (c) { _c = c; _onPendingUrl(); }),
              ),
              const WebviewProgressBar(),
              BlocBuilder<WebViewCubit, WebViewState>(
                buildWhen: (p, c) => p.showInitialLoader != c.showInitialLoader || p.hasCompletedInitialLoad != c.hasCompletedInitialLoad,
                builder: (_, s) => LuxuryPageLoader(isLoading: !s.hasCompletedInitialLoad && s.showInitialLoader, progress: s.progress),
              ),
              BlocBuilder<WebViewCubit, WebViewState>(
                buildWhen: (p, c) => p.isOffline != c.isOffline,
                builder: (_, s) => s.isOffline ? OfflineScreen(onRetry: () => _c?.reload()) : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<WebViewCubit, WebViewState>(
          buildWhen: (p, c) => p.isDrawerOpen != c.isDrawerOpen || p.isNavBarVisible != c.isNavBarVisible || p.currentTab != c.currentTab || p.isModalOpen != c.isModalOpen || p.cartCount != c.cartCount || p.isArabic != c.isArabic,
          builder: (_, s) {
            final hide = isKeyboard || s.isModalOpen || s.isDrawerOpen || !s.isNavBarVisible;
            return RepaintBoundary(
              child: AnimatedSlide(
                offset: hide ? const Offset(0, 1.5) : Offset.zero,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: hide ? 0.0 : 1.0, duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: hide,
                    child: CustomBottomNav(
                      selectedIndex: s.currentTab,
                      onTabSelected: (i) { cubit.selectTab(i); VelinaWebViewSettings.handleTabAction(_c, i, isArabic: s.isArabic); },
                      isArabic: s.isArabic, cartCount: s.cartCount,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
