import 'dom_cleaner_css.dart';

/// Clean DOM cleaner and reactive Salla modal/drawer watcher for Velina WebView.
class DomCleanerScript {
  const DomCleanerScript._();

  static final String script =
      '''
(function() {
  try {
  function injectSafeStyle() {
    var root = document.head || document.documentElement; if (!root || document.getElementById('velina-clean-style')) return;
    var s = document.createElement('style'); s.id = 'velina-clean-style'; s.textContent = `${DomCleanerCss.css}`; root.appendChild(s);
  }
  function hideNode(el) {
    if (!el || !el.style) return;
    el.style.setProperty('display', 'none', 'important');
    el.style.setProperty('visibility', 'hidden', 'important');
    el.style.setProperty('opacity', '0', 'important');
    el.style.setProperty('pointer-events', 'none', 'important');
    el.style.setProperty('width', '0', 'important');
    el.style.setProperty('height', '0', 'important');
  }
  function isMoatmtWidget(el) {
    if (!el || el.nodeType !== 1) return false;
    var tag = (el.tagName || '').toLowerCase();
    var id = (el.id || '').toLowerCase();
    var cls = typeof el.className === 'string' ? el.className.toLowerCase() : '';
    if (tag === 'main' || tag === 'header' || tag === 'footer' || id === 'app' || (el.querySelector && el.querySelector('main, #app, header, footer'))) return false;
    if (tag.indexOf('widget-host') !== -1 || id.indexOf('widget-host') !== -1 || cls.indexOf('widget-host') !== -1 || tag.indexOf('moatmt') !== -1 || id.indexOf('moatmt') !== -1 || cls.indexOf('moatmt') !== -1) return true;
    return !!(el.shadowRoot && el.shadowRoot.querySelector('#moatmt_chat_widget, #moatmt-widget-send-button, .moatmt-chat-box'));
  }
  function killMoatmtHost(el) {
    hideNode(el);
    if (el && el.shadowRoot) {
      var inner = el.shadowRoot.querySelectorAll('#moatmt_chat_widget, #moatmt-widget-send-button, .moatmt-chat-box');
      for (var s = 0; s < inner.length; s++) hideNode(inner[s]);
    }
  }
  function isDrawerOpen() {
    var d = document.documentElement, b = document.body;
    return d.classList.contains('mm-wrapper_opened') || d.classList.contains('mm-wrapper--opened') || d.classList.contains('mm-ocd--open') || (b && (b.classList.contains('mm-ocd--open') || b.classList.contains('s-drawer-open'))) || !!document.querySelector('.mm-menu_opened, .mm-menu--opened, .mm-ocd--open, salla-mobile-menu[open], #mobile-menu.mm-menu_opened');
  }
  var lastDrawer = null;
  function checkDrawer() {
    var open = isDrawerOpen();
    if (open !== lastDrawer) {
      lastDrawer = open;
      if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) window.flutter_inappwebview.callHandler('onDrawerStateChanged', open);
    }
  }
  function isActuallyRendered(node) {
    if (!node || !node.isConnected) return false;
    var r = node.getBoundingClientRect();
    if (r.width < 40 || r.height < 40) return false;
    if (r.bottom <= 0 || r.top >= window.innerHeight || r.right <= 0 || r.left >= window.innerWidth) return false;
    var cur = node;
    while (cur && cur.nodeType === 1) {
      if (cur.getAttribute('aria-hidden') === 'true') return false;
      var st = window.getComputedStyle(cur);
      if (st.display === 'none' || st.visibility === 'hidden' || parseFloat(st.opacity) < 0.05) return false;
      cur = cur.parentElement || (cur.getRootNode && cur.getRootNode().host) || null;
    }
    return true;
  }
  function isModalVisible(el) {
    if (!el || !el.isConnected) return false;
    if (el.getAttribute('aria-hidden') === 'true' || el.getAttribute('open') === 'false' || el.getAttribute('is-open') === 'false') return false;
    var subSel = '.s-modal-body, .s-modal-wrapper, .s-modal-sub-wrapper, .s-modal-content, .s-search-results, [role="dialog"], iframe';
    var subs = el.querySelectorAll(subSel);
    if ((!subs || !subs.length) && el.shadowRoot) subs = el.shadowRoot.querySelectorAll(subSel);
    if (subs && subs.length) {
      for (var i = 0; i < subs.length; i++) {
        if (isActuallyRendered(subs[i])) return true;
      }
      return false;
    }
    return isActuallyRendered(el);
  }
  function isAnyOverlayOpen() {
    if (isDrawerOpen()) return true;
    var modals = document.querySelectorAll('salla-login-modal, salla-modal, salla-search, .s-login-modal, .s-modal, [role="dialog"]');
    for (var i = 0; i < modals.length; i++) {
      if (isModalVisible(modals[i])) return true;
    }
    return false;
  }
  function updateCartH() {
    if (window.location.pathname.indexOf('/cart') !== -1) {
      var bar = document.querySelector('.cart-submit-wrap, [class*="cart-summary-sticky"], [class*="sticky-cart"]');
      if (bar) { var h = Math.round(bar.getBoundingClientRect().height); if (h > 50) document.documentElement.style.setProperty('--velina-cart-footer-h', h + 'px'); }
    }
  }
  function liftCartSummary() {
    if (window.location.pathname.indexOf('/cart') === -1 && window.location.pathname.indexOf('/checkout') === -1) return;
    if (window._vTouch || window._vScroll) return;
    var bar = window._vCartBar && window._vCartBar.isConnected ? window._vCartBar : null;
    if (!bar) { bar = document.querySelector('.cart-submit-wrap, [class*="cart-summary-sticky"], [class*="sticky-cart"]'); if (bar) window._vCartBar = bar; }
    if (bar) { bar.style.setProperty('bottom', '82px', 'important'); bar.style.setProperty('z-index', '25', 'important'); }
  }
  function hideFloatingWhatsApp() {
    var list = document.querySelectorAll('salla-chat-widget, .salla-chat-widget, #wa-widget-send-button, [id*="moatmt"], [class*="moatmt"], [id*="widget-host"], [class*="widget-host"], moatmt-widget-host, #moatmt_chat_widget, #moatmt-widget-send-button, .moatmt-chat-box');
    for (var i = 0; i < list.length; i++) killMoatmtHost(list[i]);
    var kids = document.body ? document.body.children : [];
    for (var k = 0; k < kids.length; k++) {
      if (isMoatmtWidget(kids[k])) killMoatmtHost(kids[k]);
    }
    var wa = document.querySelectorAll('a[href*="wa.me"], a[href*="whatsapp"]');
    for (var j = 0; j < wa.length; j++) {
      var a = wa[j];
      if (a.closest && a.closest('form, .product-form, salla-add-product-button, salla-quick-buy, salla-quantity-input, salla-button, .sticky-product-bar, header, nav, footer, .cart-submit-wrap, [class*="cart-total"]')) continue;
      var cur = a; while (cur && cur !== document.body && cur !== document.documentElement) {
        var tag = (cur.tagName || '').toLowerCase();
        if (tag === 'body' || tag === 'html' || tag === 'main' || cur.id === 'app' || (cur.classList && (cur.classList.contains('app-inner') || cur.classList.contains('mm-page') || cur.classList.contains('mm-slideout')))) break;
        if (window.getComputedStyle(cur).position === 'fixed') {
          var r = cur.getBoundingClientRect();
          if (r.width > 0 && r.width <= 320 && r.height > 0 && r.height <= 160 && !cur.querySelector('main, header, footer, #app')) {
            hideNode(cur); break;
          }
        }
        cur = cur.parentElement;
      }
    }
  }
  function watchBodyForMoatmt() {
    if (window._velinaMoatmtObs || !document.body) return;
    window._velinaMoatmtObs = true;
    new MutationObserver(function(muts) {
      for (var m = 0; m < muts.length; m++) {
        var added = muts[m].addedNodes;
        for (var a = 0; a < added.length; a++) {
          if (isMoatmtWidget(added[a])) killMoatmtHost(added[a]);
        }
      }
    }).observe(document.body, { childList: true });
  }
  function updateButtons(isOpen) {
    var inCart = window.location.pathname.indexOf('/cart') !== -1 || window.location.pathname.indexOf('/checkout') !== -1;
    var st = window._vSt && window._vSt.isConnected ? window._vSt : null;
    if (!st) { st = document.querySelector('button.scroll-top, #scroll-top, .btn-scroll-top, [class*="scroll-top"], .progress-wrap'); if (st) window._vSt = st; }
    if (st) { st.style.setProperty('bottom', inCart ? 'calc(var(--velina-cart-footer-h, 165px) + 14px)' : '88px', 'important'); st.style.setProperty('transform', 'scale(0.76)', 'important'); st.style.setProperty('transform-origin', 'bottom right', 'important'); }
    hideFloatingWhatsApp();
  }
  var lastState = null, updateTimer = null;
  function updateOverlay(forceSync) {
    if (!forceSync && (window._vTouch || window._vScroll)) return;
    injectSafeStyle(); watchBodyForMoatmt(); checkDrawer(); updateCartH(); liftCartSummary();
    var isOpen = isAnyOverlayOpen(); updateButtons(isOpen);
    if (forceSync || isOpen !== lastState) {
      lastState = isOpen;
      if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
        window.flutter_inappwebview.callHandler('onModalState', isOpen);
      }
    }
  }
  function scheduleUpdate(forceSync) {
    if (!forceSync && (window._vTouch || window._vScroll)) return;
    if (updateTimer) clearTimeout(updateTimer);
    updateTimer = setTimeout(function() { updateOverlay(!!forceSync); }, 200);
  }
  window._velinaForceSync = function(force) { updateOverlay(force !== false); };
  if (!window._velinaWatcher) {
    window._velinaWatcher = true;
    watchBodyForMoatmt();
    window.addEventListener('touchstart', function() { window._vTouch = true; }, { passive: true });
    window.addEventListener('touchend', function() {
      window._vTouch = false;
      if (window.location.pathname.indexOf('/cart') !== -1) scheduleUpdate(false);
      setTimeout(function() { updateOverlay(true); }, 380);
    }, { passive: true });
    window.addEventListener('touchcancel', function() { window._vTouch = false; }, { passive: true });
    window.addEventListener('scroll', function() {
      window._vScroll = true;
      clearTimeout(window._vScrollTimer);
      window._vScrollTimer = setTimeout(function() {
        window._vScroll = false;
        if (window.location.pathname.indexOf('/cart') !== -1) scheduleUpdate(false);
        if (lastState === true) updateOverlay(true);
      }, 150);
    }, { passive: true });
    document.addEventListener('DOMContentLoaded', function() { updateOverlay(true); });
    window.addEventListener('load', function() { updateOverlay(true); });
    setTimeout(hideFloatingWhatsApp, 1000);
    setTimeout(hideFloatingWhatsApp, 3000);
    document.addEventListener('click', function(e) {
      var t = e.target; if (t && t.closest && (t.closest('.swiper') || t.closest('salla-slider') || t.closest('[class*="slider"]'))) return;
      setTimeout(function() { updateOverlay(false); }, 40);
      setTimeout(function() { updateOverlay(true); }, 350);
      setTimeout(function() { updateOverlay(true); }, 650);
    }, { passive: true });
    new MutationObserver(function(muts) {
      if (window._vTouch || window._vScroll) return;
      for (var i = 0; i < muts.length; i++) {
        var n = muts[i].target, el = n && n.nodeType === 1 ? n : (n ? n.parentElement : null);
        if (el && el.closest && el.closest('.swiper, salla-slider, [class*="slider"], [class*="carousel"], form, .product-form, salla-add-product-button, salla-quick-buy, .sticky-product-bar')) continue;
        scheduleUpdate(false); break;
      }
    }).observe(document.documentElement, { attributeFilter: ['class', 'open', 'is-open', 'style', 'aria-hidden'], attributes: true, childList: true, subtree: true });
  }
  updateOverlay(true);
  } catch(e) {}
})();
''';
}
