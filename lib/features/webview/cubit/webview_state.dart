import 'package:equatable/equatable.dart';

class WebViewState extends Equatable {
  final int currentTab;
  final int cartCount;
  final bool isPageLoading;
  final double progress;
  final bool isOffline;
  final bool showScrollToTop;
  final bool isArabic;
  final bool isModalOpen;
  final bool isDrawerOpen;
  final bool isCheckout;
  final bool isNavBarVisible;
  final bool hasCompletedInitialLoad;
  final bool showInitialLoader;

  const WebViewState({
    this.currentTab = 0,
    this.cartCount = 0,
    this.isPageLoading = true,
    this.progress = 0.15,
    this.isOffline = false,
    this.showScrollToTop = false,
    this.isArabic = true,
    this.isModalOpen = false,
    this.isDrawerOpen = false,
    this.isCheckout = false,
    this.isNavBarVisible = true,
    this.hasCompletedInitialLoad = false,
    this.showInitialLoader = true,
  });

  WebViewState copyWith({
    int? currentTab,
    int? cartCount,
    bool? isPageLoading,
    double? progress,
    bool? isOffline,
    bool? showScrollToTop,
    bool? isArabic,
    bool? isModalOpen,
    bool? isDrawerOpen,
    bool? isCheckout,
    bool? isNavBarVisible,
    bool? hasCompletedInitialLoad,
    bool? showInitialLoader,
  }) {
    return WebViewState(
      currentTab: currentTab ?? this.currentTab,
      cartCount: cartCount ?? this.cartCount,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      progress: progress ?? this.progress,
      isOffline: isOffline ?? this.isOffline,
      showScrollToTop: showScrollToTop ?? this.showScrollToTop,
      isArabic: isArabic ?? this.isArabic,
      isModalOpen: isModalOpen ?? this.isModalOpen,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      isCheckout: isCheckout ?? this.isCheckout,
      isNavBarVisible: isNavBarVisible ?? this.isNavBarVisible,
      hasCompletedInitialLoad: hasCompletedInitialLoad ?? this.hasCompletedInitialLoad,
      showInitialLoader: showInitialLoader ?? this.showInitialLoader,
    );
  }

  @override
  List<Object?> get props => [
    currentTab,
    cartCount,
    isPageLoading,
    progress,
    isOffline,
    showScrollToTop,
    isArabic,
    isModalOpen,
    isDrawerOpen,
    isCheckout,
    isNavBarVisible,
    hasCompletedInitialLoad,
    showInitialLoader,
  ];
}
