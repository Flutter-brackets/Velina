/// Safe injected CSS styles for Salla WebView cleanup and floating buttons.
class DomCleanerCss {
  const DomCleanerCss._();

  static const String css = '''
    :root { --velina-cart-footer-h: 165px; }
    html, body, main, #app, .app-inner { padding-top: 0 !important; margin-top: 0 !important; }
    body, footer { padding-bottom: 92px !important; }
    #mobile-nav, .mobile-nav-inner, .mobile-nav-outer, .s-bottom-nav, salla-bottom-nav {
      display: none !important; height: 0 !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important;
    }
    .mm-ocd__close, .close-mobile-menu, .s-mobile-menu-close, .mobile-menu-close,
    .mm-btn_close, .mm-btn--close, button.close-btn, button.mm-btn_close,
    .mm-menu__close, [class*="close-mobile"], [class*="mobile-menu-close"],
    [class*="menu-close"], html.mm-wrapper_opened .mm-btn--close,
    html.mm-wrapper--opened .mm-btn--close, html.mm-wrapper_opened [class*="close-btn"],
    .mm-wrapper__blocker [class*="close"] {
      display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; width: 0 !important; height: 0 !important;
    }
    .mm-wrapper__blocker, .mm-ocd__backdrop { pointer-events: auto !important; }
    salla-chat-widget, .salla-chat-widget, #wa-widget-send-button {
      display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; width: 0 !important; height: 0 !important;
    }
    html.mm-wrapper_opened #scroll-top, html.mm-wrapper--opened #scroll-top,
    html.mm-wrapper_opened .scroll-top, html.mm-wrapper--opened .scroll-top {
      display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important;
    }
    button.scroll-top, #scroll-top, .btn-scroll-top, [class*="scroll-top"], .progress-wrap, [class*="progress-wrap"], [aria-label*="top"], [aria-label*="أعلى"] {
      bottom: 88px !important; right: 14px !important;
      transform: scale(0.76) !important; transform-origin: bottom right !important; z-index: 24 !important;
    }
    body[class*="cart"] button.scroll-top, body[class*="cart"] #scroll-top,
    body[class*="cart"] [class*="scroll-top"], body[class*="cart"] .progress-wrap,
    .cart-page button.scroll-top, .cart-page #scroll-top, .cart-page [class*="scroll-top"] {
      bottom: calc(var(--velina-cart-footer-h, 165px) + 14px) !important;
    }
    body[class*="cart"] .cart-submit-wrap, body[class*="cart"] [class*="cart-summary-sticky"],
    body[class*="cart"] [class*="sticky-cart"], body[class*="cart"] [class*="cart-total"],
    body[class*="cart"] [class*="cart-footer"], body[class*="cart"] [class*="summary-footer"],
    .cart-page .cart-submit-wrap, .cart-page [class*="cart-summary-sticky"],
    .cart-page [class*="sticky-cart"], .cart-page [class*="cart-total"],
    .cart-page [class*="cart-footer"], .cart-page [class*="summary-footer"] {
      bottom: 82px !important; z-index: 25 !important;
    }
    form[action*="cart"], .cart-page, body[class*="cart"] { padding-bottom: 140px !important; }
    salla-login-modal, salla-modal, .s-login-modal, .s-modal, .s-modal-body, [role="dialog"] { z-index: 999999 !important; }
    salla-login-modal iframe { min-height: 480px !important; width: 100% !important; }
  ''';
}
