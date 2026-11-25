import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webview_state.dart';

/// Cubit managing state, navigation, modal sync, and auto-hide for Velina WebView.
class WebViewCubit extends Cubit<WebViewState> {
  StreamSubscription<List<ConnectivityResult>>? _connSub; Timer? _safetyTimer; WebUri? _lastKnownUri; int _lastScrollY = 0;

  WebViewCubit() : super(const WebViewState()) {
    _connSub = Connectivity().onConnectivityChanged.listen((res) {
      final off = res.isEmpty || res.every((r) => r == ConnectivityResult.none);
      if (off != state.isOffline) emit(state.copyWith(isOffline: off));
    });
    _armColdStartSafetyTimer();
  }

  WebUri? get lastKnownUri => _lastKnownUri;

  void _armColdStartSafetyTimer() {
    _safetyTimer?.cancel();
    _safetyTimer = Timer(const Duration(milliseconds: 4000), () {
      if (!isClosed) emit(state.copyWith(hasCompletedInitialLoad: true, showInitialLoader: false, isPageLoading: false, progress: 1.0));
    });
  }
  void triggerTransitionLoader() {
    emit(state.copyWith(isPageLoading: true, progress: 0.25));
    _safetyTimer?.cancel();
    _safetyTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!isClosed && state.isPageLoading) emit(state.copyWith(isPageLoading: false, progress: 1.0));
    });
  }

  void onPageCommitVisible(WebUri? uri) =>
      !state.hasCompletedInitialLoad ? emit(state.copyWith(hasCompletedInitialLoad: true, showInitialLoader: false)) : null;

  void _syncNavigation(WebUri? uri, {required bool loading, double? progress}) {
    if (uri != null) _lastKnownUri = uri;
    final path = uri?.path.toLowerCase() ?? '';
    emit(state.copyWith(
      isPageLoading: loading, progress: progress ?? (loading ? 0.25 : 1.0),
      isModalOpen: false, isDrawerOpen: false,
      currentTab: path.contains('/cart') ? 1 : 0, isCheckout: path.contains('/checkout'),
      isArabic: uri != null ? !path.contains('/en') : state.isArabic,
    ));
  }

  void syncTabWithUrl(WebUri? uri) => _syncNavigation(uri, loading: state.isPageLoading, progress: state.progress);
  void setDrawerOpen(bool open) => open != state.isDrawerOpen ? emit(state.copyWith(isDrawerOpen: open)) : null;
  void updateCartCount(int count) => count != state.cartCount ? emit(state.copyWith(cartCount: count)) : null;

  void setModalOpen(bool open) {
    int tab = state.currentTab;
    if (!open) {
      final p = _lastKnownUri?.path.toLowerCase() ?? '';
      tab = p.contains('/cart') ? 1 : 0;
    }
    if (open != state.isModalOpen || tab != state.currentTab) emit(state.copyWith(isModalOpen: open, currentTab: tab));
  }

  void onPageStarted(WebUri? uri) {
    if (!state.hasCompletedInitialLoad) _armColdStartSafetyTimer();
    _syncNavigation(uri, loading: true);
  }

  void onProgressChanged(int p) {
    final norm = (p / 100.0).clamp(0.15, 1.0);
    final initialDone = state.hasCompletedInitialLoad || p >= 60;
    if (p >= 75) {
      _safetyTimer?.cancel();
      emit(state.copyWith(progress: 1.0, isPageLoading: false, hasCompletedInitialLoad: true, showInitialLoader: false));
    } else {
      emit(state.copyWith(progress: norm, isPageLoading: true, hasCompletedInitialLoad: initialDone, showInitialLoader: !initialDone));
    }
  }

  void onPageLoaded(WebUri? uri) {
    _safetyTimer?.cancel(); emit(state.copyWith(hasCompletedInitialLoad: true, showInitialLoader: false, isPageLoading: false, progress: 1.0));
    _syncNavigation(uri, loading: false);
  }

  void selectTab(int index) {
    if (index == 0 || index == 1) { triggerTransitionLoader(); emit(state.copyWith(currentTab: index)); }
    else if (index == 2 || index == 3) { emit(state.copyWith(currentTab: index, isModalOpen: true)); }
  }

  void updateScroll(int y) {
    final showTop = y > 350; final delta = y - _lastScrollY; bool? newNavVisible;
    if (y < 60) { newNavVisible = true; _lastScrollY = y; }
    else if (delta > 25 && state.isNavBarVisible) { newNavVisible = false; _lastScrollY = y; }
    else if (delta < -25 && !state.isNavBarVisible) { newNavVisible = true; _lastScrollY = y; }
    if (showTop != state.showScrollToTop || (newNavVisible != null && newNavVisible != state.isNavBarVisible)) {
      emit(state.copyWith(showScrollToTop: showTop, isNavBarVisible: newNavVisible ?? state.isNavBarVisible));
    }
  }

  void updateStoreMeta({int? cartCount, bool? isArabic}) {
    final newCart = (cartCount != null && cartCount != state.cartCount) ? cartCount : null;
    final newAr = (isArabic != null && isArabic != state.isArabic) ? isArabic : null;
    if (newCart != null || newAr != null) emit(state.copyWith(cartCount: newCart, isArabic: newAr));
  }

  @override
  Future<void> close() {
    _connSub?.cancel(); _safetyTimer?.cancel(); return super.close();
  }
}
