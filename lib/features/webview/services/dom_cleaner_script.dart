import 'dom_cleaner_css.dart';

/// Clean DOM cleaner and reactive Salla modal watcher for Velina WebView.
class DomCleanerScript {
  const DomCleanerScript._();

  static final String script =
      '''
(function() {
  function injectSafeStyle() {
    var root = document.head || document.documentElement;
    if (!root || document.getElementById('velina-clean-style')) return;
    var s = document.createElement('style'); s.id = 'velina-clean-style'; s.textContent = `${DomCleanerCss.css}`; root.appendChild(s);
  }
  function hideOuterRedDrawerClose(root) {
    root = root || document;
    var panel = document.querySelector('#mobile-menu, .mm-menu, .mm-panels, salla-mobile-menu');
    var pRect = panel ? panel.getBoundingClientRect() : null;
    var drawerOpen = document.documentElement.classList.contains('mm-wrapper_opened') ||
      !!document.querySelector('.mm-menu_opened, #mobile-menu.mm-menu_opened, salla-mobile-menu[open]') ||
      (pRect && pRect.width > 150 && pRect.left >= 0 && pRect.left < window.innerWidth - 50);
    var menuLeft = (drawerOpen && pRect && pRect.left >= 20) ? pRect.left : 55;
    var all = root.querySelectorAll('button, a, div, span, [role="button"], .mburger');
    for (var i = 0; i < all.length; i++) {
      var el = all[i], r = el.getBoundingClientRect();
      if (drawerOpen && r.width >= 24 && r.width <= 90 && r.height >= 24 && r.height <= 90 && r.top <= 130 && r.right <= menuLeft + 8) {
        el.dataset.velinaHiddenClose = '1';
        el.style.setProperty('display', 'none', 'important');
      } else if (!drawerOpen && el.dataset.velinaHiddenClose === '1') {
        delete el.dataset.velinaHiddenClose;
        el.style.removeProperty('display');
      }
    }
    var hosts = root.querySelectorAll('salla-mobile-menu, salla-modal, [id*="mobile-menu"]');
    for (var j = 0; j < hosts.length; j++) { if (hosts[j].shadowRoot) hideOuterRedDrawerClose(hosts[j].shadowRoot); }
  }
  function liftCartSummary(root) {
    root = root || document;
    var all = root.querySelectorAll('button, a, div, span, p, salla-button');
    for (var i = 0; i < all.length; i++) {
      var node = all[i], txt = node.textContent || '';
      if ((txt.indexOf('إتمام الطلب') !== -1 || txt.indexOf('اتمام الطلب') !== -1) && node.children.length <= 2) {
        var cur = node;
        while (cur && cur !== document.body && cur !== document.documentElement) {
          var cs = window.getComputedStyle(cur);
          if (cs.position === 'fixed' || cs.position === 'sticky') { cur.style.setProperty('bottom', '82px', 'important'); cur.style.setProperty('z-index', '25', 'important'); break; }
          cur = cur.parentElement;
        }
        break;
      }
    }
    var vh = window.innerHeight, vw = window.innerWidth, bars = root.querySelectorAll('div, form, section, footer, salla-add-product-button');
    for (var j = 0; j < bars.length; j++) {
      var el = bars[j], cs2 = window.getComputedStyle(el);
      if (el.id === 'velina-clean-style' || el.closest('.salla-chat-widget, [class*="whatsapp"], nav, header') || cs2.display === 'none' || cs2.visibility === 'hidden') continue;
      if (cs2.position === 'fixed' || cs2.position === 'sticky') {
        var r = el.getBoundingClientRect();
        if (r.width >= vw * 0.8 && r.height >= 44 && r.height <= 260 && (vh - r.bottom) <= 15) { el.style.setProperty('bottom', '82px', 'important'); el.style.setProperty('z-index', '25', 'important'); }
      }
    }
    var hosts = root.querySelectorAll('salla-add-product-button, salla-cart-summary');
    for (var k = 0; k < hosts.length; k++) { if (hosts[k].shadowRoot) liftCartSummary(hosts[k].shadowRoot); }
  }
  function isVis(e) { return e && window.getComputedStyle(e).display !== 'none' && parseFloat(window.getComputedStyle(e).opacity || '1') > 0.1 && e.getBoundingClientRect().height > 50; }
  function isAnyOverlayOpen() {
    if (document.documentElement.classList.contains('mm-wrapper_opened') || !!document.querySelector('#mobile-menu.mm-menu_opened, .mm-menu_opened, salla-mobile-menu[open]')) return true;
    var modals = document.querySelectorAll('salla-login-modal, salla-modal, salla-localization-modal, salla-search, [role="dialog"], .s-modal');
    for (var i = 0; i < modals.length; i++) {
      var el = modals[i];
      if (el.tagName && el.tagName.toLowerCase() === 'salla-search') {
        var sT = el.shadowRoot ? el.shadowRoot.querySelector('.s-search-modal, .salla-modal-wrapper, [role="dialog"]') : el.querySelector('.s-search-modal, [role="dialog"]');
        if (isVis(sT)) return true; continue;
      }
      var inner = el.shadowRoot ? el.shadowRoot.querySelector('.salla-modal-wrapper, .s-modal, [role="dialog"], .modal-dialog') : null;
      if (inner) { if (isVis(inner)) return true; continue; }
      var hasOpen = el.hasAttribute('open') || el.hasAttribute('is-open') || el.getAttribute('aria-hidden') === 'false' || (el.classList && (el.classList.contains('is-open') || el.classList.contains('open') || el.classList.contains('s-modal-entering')));
      if (hasOpen && isVis(el)) return true;
    }
    var fixedEls = document.querySelectorAll('div[style*="fixed"], div[style*="absolute"], div[class*="backdrop"], div[class*="overlay"], .mm-wrapper__blocker');
    for (var f = 0; f < fixedEls.length; f++) {
      var fel = fixedEls[f]; if (fel.closest('.salla-chat-widget, [class*="whatsapp"], #wa-widget-send-button')) continue;
      var fcs = window.getComputedStyle(fel), fr = fel.getBoundingClientRect();
      if ((fcs.position === 'fixed' || fcs.position === 'absolute') && fcs.display !== 'none' && fcs.visibility !== 'hidden' && parseFloat(fcs.opacity || '1') > 0.1 && fr.width >= window.innerWidth * 0.85 && fr.height >= window.innerHeight * 0.85 && fr.top <= 10 && fr.left <= 10) return true;
    }
    return !!(document.documentElement.classList.contains('mm-wrapper_opened') && document.body && (window.getComputedStyle(document.body).overflow === 'hidden' || window.getComputedStyle(document.documentElement).overflow === 'hidden'));
  }
  function updateButtons(isOpen) {
    var wa = document.querySelectorAll('.salla-chat-widget, [class*="whatsapp"], [id*="whatsapp"], a[href*="wa.me"], a[href*="whatsapp"]');
    for (var j = 0; j < wa.length; j++) {
      var t = wa[j].closest('[style*="fixed"], .wa-widget, .salla-chat-widget') || wa[j];
      t.style.setProperty('visibility', isOpen ? 'hidden' : 'visible', isOpen ? 'important' : ''); t.style.setProperty('opacity', isOpen ? '0' : '1', isOpen ? 'important' : '');
      t.style.setProperty('pointer-events', isOpen ? 'none' : 'auto', isOpen ? 'important' : ''); if (!isOpen) t.style.setProperty('bottom', '90px', 'important');
    }
    var btns = document.querySelectorAll('button.scroll-top, #scroll-top, .btn-scroll-top, [class*="scroll-top"], .progress-wrap, [aria-label*="top"], [aria-label*="أعلى"]');
    for (var k = 0; k < btns.length; k++) btns[k].style.setProperty('bottom', '90px', 'important');
  }
  var lastState = null, closeTimer = null, rafPending = false;
  function updateOverlay() {
    rafPending = false;
    injectSafeStyle(); hideOuterRedDrawerClose(); liftCartSummary();
    var isOpen = isAnyOverlayOpen();
    if (isOpen) {
      if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
      updateButtons(true);
      if (lastState !== true) { lastState = true; if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) window.flutter_inappwebview.callHandler('onModalState', true); }
    } else if (lastState === true && !closeTimer) {
      closeTimer = setTimeout(function() { closeTimer = null; if (!isAnyOverlayOpen()) { lastState = false; updateButtons(false); if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) window.flutter_inappwebview.callHandler('onModalState', false); } }, 120);
    } else if (lastState === null) { lastState = false; updateButtons(false); }
  }
  function scheduleUpdate() { if (!rafPending) { rafPending = true; requestAnimationFrame(updateOverlay); } }
  if (!window._velinaWatcher) {
    window._velinaWatcher = true; document.addEventListener('DOMContentLoaded', scheduleUpdate);
    document.addEventListener('click', function() { scheduleUpdate(); setTimeout(scheduleUpdate, 80); setTimeout(scheduleUpdate, 250); }, true);
    new MutationObserver(scheduleUpdate).observe(document.documentElement, { attributes: true, childList: true, subtree: true });
  }
  scheduleUpdate();
})();
''';
}
