import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velina/features/webview/cubit/webview_cubit.dart';
import 'package:velina/features/webview/cubit/webview_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WebViewState', () {
    test('default values are correct', () {
      const state = WebViewState();
      expect(state.currentTab, 0);
      expect(state.cartCount, 0);
      expect(state.isPageLoading, true);
      expect(state.progress, 0.15);
      expect(state.isOffline, false);
      expect(state.showScrollToTop, false);
      expect(state.isArabic, true);
      expect(state.isModalOpen, false);
      expect(state.isCheckout, false);
    });

    test('copyWith works correctly', () {
      const state = WebViewState();
      final updated = state.copyWith(
        currentTab: 2,
        cartCount: 5,
        isPageLoading: false,
        progress: 0.8,
        isOffline: true,
        showScrollToTop: true,
        isArabic: false,
        isModalOpen: true,
        isCheckout: true,
      );
      expect(updated.currentTab, 2);
      expect(updated.cartCount, 5);
      expect(updated.isPageLoading, false);
      expect(updated.progress, 0.8);
      expect(updated.isOffline, true);
      expect(updated.showScrollToTop, true);
      expect(updated.isArabic, false);
      expect(updated.isModalOpen, true);
      expect(updated.isCheckout, true);
    });
  });

  group('WebViewCubit', () {
    late WebViewCubit cubit;

    setUp(() {
      cubit = WebViewCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('triggerTransitionLoader sets isPageLoading to true and progress to 0.2', () {
      cubit.onProgressChanged(85);
      expect(cubit.state.isPageLoading, false);

      cubit.triggerTransitionLoader();
      expect(cubit.state.isPageLoading, true);
      expect(cubit.state.progress, 0.2);
    });

    test('onPageStarted detects language and syncs tab', () {
      cubit.onPageStarted(WebUri('https://velinaboutiquesa.com/en/cart'));
      expect(cubit.state.isArabic, false);
      expect(cubit.state.currentTab, 1);
      expect(cubit.state.isPageLoading, true);

      cubit.onPageStarted(WebUri('https://velinaboutiquesa.com/ar'));
      expect(cubit.state.isArabic, true);
      expect(cubit.state.currentTab, 0);
    });

    test('setModalOpen toggles state and restores underlying tab on close', () {
      cubit.syncTabWithUrl(WebUri('https://velinaboutiquesa.com/ar/cart'));
      expect(cubit.state.currentTab, 1);

      cubit.selectTab(2); // open login
      expect(cubit.state.currentTab, 2);

      cubit.setModalOpen(true);
      expect(cubit.state.isModalOpen, true);

      cubit.setModalOpen(false);
      expect(cubit.state.isModalOpen, false);
      expect(cubit.state.currentTab, 1); // restored to cart
    });

    test('syncTabWithUrl detects checkout path', () {
      cubit.syncTabWithUrl(WebUri('https://velinaboutiquesa.com/ar/checkout'));
      expect(cubit.state.isCheckout, true);
    });

    test('onProgressChanged handles thresholds properly', () {
      cubit.onProgressChanged(50);
      expect(cubit.state.progress, 0.5);
      expect(cubit.state.isPageLoading, true);

      cubit.onProgressChanged(85);
      expect(cubit.state.progress, 1.0);
      expect(cubit.state.isPageLoading, false);
    });

    test('onPageLoaded completes loading', () {
      cubit.onPageLoaded(WebUri('https://velinaboutiquesa.com/en'));
      expect(cubit.state.isPageLoading, false);
      expect(cubit.state.progress, 1.0);
      expect(cubit.state.isArabic, false);
    });

    test('selectTab triggers loader for 0 and 1 but not 2 and 3', () {
      cubit.onProgressChanged(90);
      cubit.selectTab(2);
      expect(cubit.state.currentTab, 2);
      expect(cubit.state.isPageLoading, false);

      cubit.selectTab(1);
      expect(cubit.state.currentTab, 1);
      expect(cubit.state.isPageLoading, true);
      expect(cubit.state.progress, 0.2);
    });

    test('updateScroll updates showScrollToTop when y > 350', () {
      cubit.updateScroll(200);
      expect(cubit.state.showScrollToTop, false);

      cubit.updateScroll(400);
      expect(cubit.state.showScrollToTop, true);

      cubit.updateScroll(100);
      expect(cubit.state.showScrollToTop, false);
    });

    test('updateStoreMeta updates cartCount and isArabic', () {
      cubit.updateStoreMeta(cartCount: 3, isArabic: false);
      expect(cubit.state.cartCount, 3);
      expect(cubit.state.isArabic, false);
    });
  });
}
