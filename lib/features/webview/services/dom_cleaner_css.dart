/// Safe injected CSS styles for Salla WebView cleanup and floating buttons.
class DomCleanerCss {
  const DomCleanerCss._();

  static const String css = '''
    html, body, main, #app, .app-inner { padding-top: 0 !important; margin-top: 0 !important; }
    body, footer { padding-bottom: 92px !important; }
    #mobile-nav, .mobile-nav-inner, .mobile-nav-outer, .s-bottom-nav, salla-bottom-nav,
    .header-spacer, [class*="header-spacer"] { display: none !important; height: 0 !important; }
    html.mm-wrapper_opened .mburger, html.mm-wrapper_opened [class*="mburger"],
    html.mm-wrapper_opened a[href*="mobile-menu"], html.mm-wrapper_opened .header-menu-icon,
    html.mm-wrapper_opened .mm-wrapper__blocker a, html.mm-wrapper_opened .mm-wrapper__blocker button,
    html.mm-wrapper_opened .mm-wrapper__blocker [class*="close"],
    .mm-btn--close, button.mm-btn_close, .mm-menu__close, [class*="mm-btn"][class*="close"],
    .mm-wrapper__blocker::before, .mm-wrapper__blocker::after,
    html.mm-wrapper_opened salla-chat-widget, html.mm-wrapper_opened [class*="whatsapp"],
    html.mm-wrapper_opened [id*="whatsapp"], html.mm-wrapper_opened #wa-widget-send-button {
      display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; width: 0 !important; height: 0 !important;
    }
    salla-chat-widget, .salla-chat-widget, [class*="whatsapp-widget"], [id*="whatsapp-widget"], #wa-widget-send-button {
      bottom: 88px !important;
    }
    button.scroll-top, #scroll-top, .btn-scroll-top, [class*="scroll-top"], .progress-wrap, [class*="progress-wrap"], [aria-label*="top"], [aria-label*="أعلى"] {
      bottom: 88px !important; zoom: 0.72 !important;
    }
    salla-add-product-button, .sticky-product-bar, [class*="sticky-cart"], .cart-summary-sticky,
    .s-add-product-button-sticky, .cart-submit-wrap, [class*="cart-summary"]:not(header *):not(nav *),
    [class*="cart-total"]:not(header *), [class*="cart-footer"], [class*="summary-footer"] {
      bottom: 82px !important; z-index: 25 !important;
    }
    form[action*="cart"], .cart-page, body[class*="cart"] { padding-bottom: 140px !important; }
    salla-login-modal, salla-modal, .s-login-modal, .s-modal, .s-modal-body, [role="dialog"] { z-index: 999999 !important; }
    salla-login-modal iframe { min-height: 480px !important; width: 100% !important; }
  ''';
}
