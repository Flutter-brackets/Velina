import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webview_state.dart';

/// Cubit managing state, navigation, modal sync, and auto-hide for Velina WebView.
class WebViewCubit extends Cubit<WebViewState> {
  StreamSubscription<List<ConnectivityResult>>? _connSub;
  Timer? _safetyTimer;
  WebUri? _lastKnownUri;

  WebViewCubit() : super(const WebViewState()) {
    _connSub = Connectivity().onConnectivityChanged.listen((res) {
      final off = res.isEmpty || res.every((r) => r == ConnectivityResult.none);
      if (off != state.isOffline) emit(state.copyWith(isOffline: off));
    });
    _armSafetyTimer(2200);
  }

  WebUri? get lastKnownUri => _lastKnownUri;

  void _armSafetyTimer([int ms = 2200]) {
    _safetyTimer?.cancel();
    _safetyTimer = Timer(Duration(milliseconds: ms), () {
      if (!isClosed && state.isPageLoading) emit(state.copyWith(isPageLoading: false, progress: 1.0));
    });
  }

  void triggerTransitionLoader() {
    emit(state.copyWith(isPageLoading: true, progress: 0.2));
    _armSafetyTimer(2200);
  }

  void _syncNavigation(WebUri? uri, {required bool loading, double? progress}) {
    if (uri != null) _lastKnownUri = uri;
    final path = uri?.path.toLowerCase() ?? '';
    emit(state.copyWith(
      isPageLoading: loading,
      progress: progress ?? (loading ? 0.25 : 1.0),
      isModalOpen: false,
      currentTab: path.contains('/cart') ? 1 : 0,
      isCheckout: path.contains('/checkout'),
      isArabic: uri != null ? !path.contains('/en') : state.isArabic,
    ));
  }

  void syncTabWithUrl(WebUri? uri) => _syncNavigation(uri, loading: state.isPageLoading, progress: state.progress);

  void setModalOpen(bool open) {
    int tab = state.currentTab;
    if (!open) {
      final p = _lastKnownUri?.path.toLowerCase() ?? '';
      tab = p.contains('/cart') ? 1 : 0;
    }
    if (open == state.isModalOpen && tab == state.currentTab) return;
    emit(state.copyWith(isModalOpen: open, currentTab: tab));
  }

  void onPageStarted(WebUri? uri) {
    _armSafetyTimer(4000);
    _syncNavigation(uri, loading: true);
  }

  void onProgressChanged(int p) {
    final norm = (p / 100.0).clamp(0.2, 1.0);
    if (p >= 75) {
      _safetyTimer?.cancel();
      emit(state.copyWith(progress: 1.0, isPageLoading: false));
    } else {
      emit(state.copyWith(progress: norm, isPageLoading: true));
    }
  }

  void onPageLoaded(WebUri? uri) {
    _safetyTimer?.cancel();
    _syncNavigation(uri, loading: false);
  }

  void selectTab(int index) {
    if (index == 0 || index == 1) {
      triggerTransitionLoader();
      emit(state.copyWith(currentTab: index, isPageLoading: true, progress: 0.2));
    } else if (index == 2 || index == 3) {
      emit(state.copyWith(currentTab: index, isModalOpen: true));
    }
  }

  void updateScroll(int y) {
    final show = y > 350;
    if (show != state.showScrollToTop) emit(state.copyWith(showScrollToTop: show));
  }

  void updateCartCount(int count) => count != state.cartCount ? emit(state.copyWith(cartCount: count)) : null;

  void updateStoreMeta({int? cartCount, bool? isArabic}) {
    final newCart = (cartCount != null && cartCount != state.cartCount) ? cartCount : null;
    final newAr = (isArabic != null && isArabic != state.isArabic) ? isArabic : null;
    if (newCart != null || newAr != null) emit(state.copyWith(cartCount: newCart, isArabic: newAr));
  }

  @override
  Future<void> close() {
    _connSub?.cancel();
    _safetyTimer?.cancel();
    return super.close();
  }
}
