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
  final bool isCheckout;

  const WebViewState({
    this.currentTab = 0,
    this.cartCount = 0,
    this.isPageLoading = true,
    this.progress = 0.15,
    this.isOffline = false,
    this.showScrollToTop = false,
    this.isArabic = true,
    this.isModalOpen = false,
    this.isCheckout = false,
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
    bool? isCheckout,
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
      isCheckout: isCheckout ?? this.isCheckout,
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
    isCheckout,
  ];
}
