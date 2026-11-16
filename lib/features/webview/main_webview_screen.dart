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
import 'widgets/webview_viewport.dart';

/// Ultra-performance Salla WebView host with floating oval glass capsule navbar.
class MainWebViewScreen extends StatelessWidget {
  const MainWebViewScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => WebViewCubit(), child: const _MainWebViewContent());
}

class _MainWebViewContent extends StatefulWidget {
  const _MainWebViewContent();

  @override
  State<_MainWebViewContent> createState() => _MainWebViewContentState();
}

class _MainWebViewContentState extends State<_MainWebViewContent> {
  InAppWebViewController? _controller;

  @override
  void initState() {
    super.initState();
    NotificationService.pendingUrl.addListener(_onPendingUrl);
  }

  @override
  void dispose() {
    NotificationService.pendingUrl.removeListener(_onPendingUrl);
    super.dispose();
  }

  void _onPendingUrl() {
    final url = NotificationService.pendingUrl.value;
    if (url != null && _controller != null) {
      _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
      NotificationService.clearPendingUrl();
    }
  }

  Future<void> _handleBack(bool didPop, dynamic _) async =>
      didPop ? null : ((await _controller?.canGoBack() ?? false) ? await _controller?.goBack() : await SystemNavigator.pop());

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WebViewCubit>();
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocBuilder<WebViewCubit, WebViewState>(
      builder: (context, state) {
        final hideNav = isKeyboard || state.isModalOpen;
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
                  WebViewViewport(cubit: cubit, onCreated: (c) { _controller = c; _onPendingUrl(); }),
                  LuxuryPageLoader(isLoading: state.isPageLoading, progress: state.progress),
                  if (state.isOffline) OfflineScreen(onRetry: () => _controller?.reload()),
                ],
              ),
            ),
            bottomNavigationBar: AnimatedSlide(
              offset: hideNav ? const Offset(0, 1.5) : Offset.zero,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: hideNav ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: hideNav,
                  child: CustomBottomNav(
                    selectedIndex: state.currentTab,
                    onTabSelected: (i) {
                      cubit.selectTab(i);
                      VelinaWebViewSettings.handleTabAction(_controller, i, isArabic: state.isArabic);
                    },
                    isArabic: state.isArabic,
                    cartCount: state.cartCount,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
