import 'dom_cleaner_css.dart';

/// Clean DOM cleaner and reactive Salla modal watcher for Velina WebView.
class DomCleanerScript {
  const DomCleanerScript._();

  static final String script =
      '''
(function() {
  function injectSafeStyle() {
    var root = document.head || document.documentElement; if (!root) return;
    if (!document.getElementById('velina-clean-style')) {
      var s = document.createElement('style'); s.id = 'velina-clean-style'; s.textContent = `${DomCleanerCss.css}`; root.appendChild(s);
    }
    if (!document.getElementById('velina-drawer-style')) {
      var d = document.createElement('style'); d.id = 'velina-drawer-style';
      d.textContent = 'html.mm-wrapper_opened .mm-menu__close,html.mm-wrapper_opened .mm-btn_close,html.mm-wrapper_opened [class*="close-mobile"],html.mm-wrapper_opened [class*="menu-close"],html.velina-drawer-open [data-velina-hidden-close="1"]{display:none!important;visibility:hidden!important;opacity:0!important;pointer-events:none!important;}'
        + 'html.mm-wrapper_opened .bottom-navigation,html.mm-wrapper_opened salla-bottom-navigation,html.mm-wrapper_opened [class*="bottom-nav"],html.velina-drawer-open [data-velina-hidden-nav="1"]{visibility:hidden!important;opacity:0!important;pointer-events:none!important;transition:none!important;}';
      root.appendChild(d);
    }
  }
  function getPanel() { return document.querySelector('#mobile-menu, .mm-menu, .mm-panels, salla-mobile-menu'); }
  function isDrawerOpen() {
    var panel = getPanel(), pRect = panel ? panel.getBoundingClientRect() : null;
    return document.documentElement.classList.contains('mm-wrapper_opened') || !!document.querySelector('.mm-menu_opened, #mobile-menu.mm-menu_opened, salla-mobile-menu[open]') || !!(pRect && pRect.width > 150 && pRect.left >= 0 && pRect.left < window.innerWidth - 50);
  }
  function restoreHidden(root, attr, props) {
    var h = root.querySelectorAll('[' + attr + '="1"]');
    for (var k = 0; k < h.length; k++) {
      h[k].removeAttribute(attr);
      for (var p = 0; p < props.length; p++) h[k].style.removeProperty(props[p]);
    }
    var hosts = root.querySelectorAll('salla-mobile-menu, salla-modal');
    for (var j = 0; j < hosts.length; j++) { if (hosts[j].shadowRoot) restoreHidden(hosts[j].shadowRoot, attr, props); }
  }
  function isInnerClose(el, r, pRect, onRight) {
    if (!pRect || r.width > 70 || r.height > 70 || r.top > pRect.top + 130 || r.top > 160) return false;
    var startSide = onRight ? (r.left - pRect.left) : (pRect.right - r.right);
    if (startSide > 90 || startSide < -8) return false;
    var tag = el.tagName.toLowerCase();
    var t = (el.textContent || '').trim();
    var cls = (typeof el.className === 'string' ? el.className : (el.className && el.className.baseVal) || '') + ' ' + (el.getAttribute('aria-label') || '') + ' ' + (el.id || '');
    if (/close|times|dismiss|cancel|اغلاق|إغلاق|x-mark|mburger/i.test(cls)) return true;
    if (t === '\u00d7' || t === 'x' || t === 'X' || t === '\u2715' || t === '\u2716' || t === '\u2573') return true;
    if ((tag === 'svg' || tag === 'i') && t === '') return true;
    return false;
  }
  function hideOuterRedDrawerClose(root, panel, pRect) {
    var isTop = !root;
    root = root || document;
    if (isTop) {
      if (!isDrawerOpen()) {
        document.documentElement.classList.remove('velina-drawer-open');
        restoreHidden(document, 'data-velina-hidden-close', ['display', 'visibility', 'opacity', 'pointer-events']);
        return;
      }
      document.documentElement.classList.add('velina-drawer-open');
      panel = getPanel(); pRect = panel ? panel.getBoundingClientRect() : null;
    }
    var vw = window.innerWidth;
    var panelOnRight = pRect ? ((pRect.left + pRect.right) / 2 > vw / 2) : true;
    var edge = pRect ? (panelOnRight ? pRect.left : pRect.right) : 55;
    var all = root.querySelectorAll('button, a, div, span, i, svg, [role="button"], .mburger');
    for (var i = 0; i < all.length; i++) {
      var el = all[i];
      var r = el.getBoundingClientRect();
      if (r.width < 8 || r.height < 8) continue;
      var inside = !!(panel && panel.contains(el));
      var hit = false;
      if (inside) {
        hit = isInnerClose(el, r, pRect, panelOnRight);
      } else if (r.width <= 120 && r.height <= 120 && r.top <= 140) {
        hit = panelOnRight ? (r.right <= edge + 8) : (r.left >= edge - 8);
      }
      if (hit) {
        el.setAttribute('data-velina-hidden-close', '1');
        el.style.setProperty('display', 'none', 'important');
      }
    }
    var hosts = root.querySelectorAll('salla-mobile-menu, salla-modal');
    for (var j = 0; j < hosts.length; j++) { if (hosts[j].shadowRoot) hideOuterRedDrawerClose(hosts[j].shadowRoot, panel, pRect); }
  }
  function hideBottomNav() {
    var attr = 'data-velina-hidden-nav';
    if (!isDrawerOpen()) { restoreHidden(document, attr, ['visibility', 'opacity', 'pointer-events']); return; }
    var vh = window.innerHeight, vw = window.innerWidth, panel = getPanel();
    function skip(el) {
      if (!el || el === document.body || el === document.documentElement) return true;
      if (panel && (panel.contains(el) || el.contains(panel))) return true;
      if (el.matches && el.matches('.mm-wrapper__blocker, .cart-submit-wrap, [class*="cart-summary"], [class*="sticky-cart"], salla-add-product-button')) return true;
      if (el.querySelector && el.querySelector('salla-add-product-button, .cart-submit-wrap, #mobile-menu, .mm-menu, salla-mobile-menu')) return true;
      return false;
    }
    function hideNav(target) {
      target.setAttribute(attr, '1');
      target.style.setProperty('visibility', 'hidden', 'important'); target.style.setProperty('opacity', '0', 'important'); target.style.setProperty('pointer-events', 'none', 'important');
    }
    var cands = document.querySelectorAll('.bottom-navigation, salla-bottom-navigation, [class*="bottom-nav"], [class*="bottom-bar"], [class*="tab-bar"], [class*="mobile-nav"], [class*="dock"], nav, [role="navigation"], footer');
    for (var i = 0; i < cands.length; i++) {
      var el = cands[i];
      if (skip(el)) continue;
      var target = outerFixed(el) || el;
      if (skip(target)) continue;
      var cs = window.getComputedStyle(target), r = target.getBoundingClientRect();
      var nameHit = /bottom-nav|bottom-bar|tab-bar|mobile-nav/i.test(typeof el.className === 'string' ? el.className : '') || el.tagName.toLowerCase() === 'salla-bottom-navigation';
      var geoHit = (cs.position === 'fixed' || cs.position === 'sticky') && r.width >= vw * 0.5 && r.height >= 36 && r.height <= 180 && (vh - r.bottom) <= 70 && r.top > vh * 0.6;
      if (nameHit || geoHit) hideNav(target);
    }
    if (document.elementsFromPoint) {
      var pts = [[vw * 0.5, vh - 40], [vw * 0.25, vh - 40], [vw * 0.75, vh - 40], [vw * 0.5, vh - 70]];
      for (var p = 0; p < pts.length; p++) {
        var stack = document.elementsFromPoint(pts[p][0], pts[p][1]);
        for (var q = 0; q < stack.length; q++) {
          var fx = outerFixed(stack[q]);
          if (!fx || skip(fx)) continue;
          var fr = fx.getBoundingClientRect();
          if (fr.width >= vw * 0.5 && fr.width <= vw * 1.01 && fr.height >= 36 && fr.height <= 180 && fr.top > vh * 0.6) hideNav(fx);
        }
      }
    }
  }
  var drawerLoop = false, lastTick = 0;
  function startDrawerLoop() {
    if (drawerLoop) return;
    drawerLoop = true;
    var startTs = 0;
    function tick(ts) {
      if (!startTs) startTs = ts;
      if (!isDrawerOpen()) {
        drawerLoop = false;
        hideOuterRedDrawerClose(); hideBottomNav();
        return;
      }
      if (ts - startTs < 800 || ts - lastTick > 90) { lastTick = ts; hideOuterRedDrawerClose(); hideBottomNav(); }
      requestAnimationFrame(tick);
    }
    requestAnimationFrame(tick);
  }
  function liftCartSummary(root) {
    if (window._velinaScrolling) return;
    root = root || document;
    var lifted = [];
    function addLift(n) { var t = outerFixed(n); if (t && lifted.indexOf(t) === -1) lifted.push(t); }
    var targets = root.querySelectorAll('salla-add-product-button, .cart-submit-wrap, [class*="cart-summary"], [class*="sticky-cart"], form[action*="cart"]');
    for (var i = 0; i < targets.length; i++) {
      var node = targets[i], txt = node.textContent || '';
      if (txt.indexOf('إتمام الطلب') !== -1 || txt.indexOf('اتمام الطلب') !== -1 || node.matches('salla-add-product-button, .cart-submit-wrap, [class*="sticky-cart"]')) addLift(node);
    }
    var vh = window.innerHeight, vw = window.innerWidth, bars = root.querySelectorAll('salla-add-product-button, .cart-submit-wrap, [class*="cart-summary-sticky"], [class*="sticky-cart"]');
    for (var j = 0; j < bars.length; j++) {
      var el = bars[j], cs2 = window.getComputedStyle(el), r = el.getBoundingClientRect();
      if (cs2.display !== 'none' && cs2.visibility !== 'hidden' && (cs2.position === 'fixed' || cs2.position === 'sticky') && r.width >= vw * 0.8 && r.height >= 44 && r.height <= 260 && (vh - r.bottom) <= 15) addLift(el);
    }
    for (var m = 0; m < lifted.length; m++) {
      lifted[m].dataset.velinaLift = '1';
      lifted[m].style.setProperty('bottom', '82px', 'important'); lifted[m].style.setProperty('z-index', '25', 'important');
    }
    var marked = root.querySelectorAll('[data-velina-lift="1"]');
    for (var q = 0; q < marked.length; q++) {
      if (lifted.indexOf(marked[q]) === -1) { marked[q].style.removeProperty('bottom'); marked[q].style.removeProperty('z-index'); delete marked[q].dataset.velinaLift; }
    }
    var hosts = root.querySelectorAll('salla-add-product-button, salla-cart-summary'); for (var k = 0; k < hosts.length; k++) { if (hosts[k].shadowRoot) liftCartSummary(hosts[k].shadowRoot); }
  }
  function isVis(e) { if (!e) return false; var cs = window.getComputedStyle(e); return cs.display !== 'none' && cs.visibility !== 'hidden' && parseFloat(cs.opacity || '1') > 0.1 && e.getBoundingClientRect().height > 40; }
  function isAnyOverlayOpen() {
    if (isDrawerOpen() || (document.body && document.body.classList.contains('modal-is-open'))) return true;
    var activeModal = document.querySelector('salla-login-modal[open], salla-login-modal[is-open], salla-modal[open], salla-modal[is-open], salla-localization-modal[open], salla-search.is-open, salla-search[open], [role="dialog"][open], [role="dialog"].is-open, [role="dialog"].show, .s-modal.is-open');
    if (activeModal && isVis(activeModal)) return true;
    var modals = document.querySelectorAll('salla-login-modal, salla-modal, salla-localization-modal, salla-search');
    for (var i = 0; i < modals.length; i++) { var m = modals[i]; if ((m.hasAttribute('open') || m.hasAttribute('is-open') || m.classList.contains('is-open') || m.classList.contains('open')) && isVis(m)) return true; }
    var blocker = document.querySelector('.mm-wrapper__blocker'); return !!(blocker && window.getComputedStyle(blocker).display !== 'none' && window.getComputedStyle(blocker).visibility !== 'hidden' && parseFloat(window.getComputedStyle(blocker).opacity || '0') > 0.1);
  }
  function outerFixed(n) {
    var cur = n, found = null;
    while (cur && cur !== document.body && cur !== document.documentElement) {
      var p = window.getComputedStyle(cur).position;
      if (p === 'fixed' || p === 'sticky') found = cur;
      cur = cur.parentElement;
    }
    return found;
  }
  function getTotalTop() {
    var vh = window.innerHeight, top = vh, i, b, r, cs;
    var nodes = document.querySelectorAll('.cart-submit-wrap, [class*="cart-summary"], [class*="sticky-cart"], salla-add-product-button');
    for (i = 0; i < nodes.length; i++) {
      b = outerFixed(nodes[i]) || nodes[i]; cs = window.getComputedStyle(b); r = b.getBoundingClientRect();
      if (cs.display !== 'none' && cs.visibility !== 'hidden' && r.height >= 40 && r.top > 0 && r.top < vh && (vh - r.bottom) <= 150 && r.top < top) top = r.top;
    }
    if (window.location.pathname.indexOf('/cart') !== -1) {
      var leaves = document.querySelectorAll('span, p, b, strong, div, h3, h4, label');
      for (i = 0; i < leaves.length; i++) {
        var lf = leaves[i];
        if (lf.children.length > 0 || (lf.textContent || '').indexOf('الإجمالي') === -1) continue;
        r = lf.getBoundingClientRect();
        if (r.height <= 0 || r.top < vh * 0.4 || r.top >= vh) continue;
        b = outerFixed(lf); var t = b ? b.getBoundingClientRect().top : (r.top - 40);
        if (t > 0 && t < top) top = t;
      }
    }
    return top;
  }
  function parentOf(n) { return n.parentElement || (n.getRootNode && n.getRootNode().host) || null; }
  function outerFixedDeep(n) {
    var cur = n, found = null;
    while (cur && cur !== document.body && cur !== document.documentElement) {
      var p = window.getComputedStyle(cur).position;
      if (p === 'fixed') found = cur;
      cur = parentOf(cur);
    }
    return found;
  }
  function findWa() {
    if (window._velinaWa && window._velinaWa.isConnected) return window._velinaWa;
    var result = null;
    function scan(root) {
      var els = root.querySelectorAll('*');
      for (var i = 0; i < els.length && !result; i++) {
        var el = els[i];
        if (el.shadowRoot) scan(el.shadowRoot);
        if (result) return;
        var href = el.getAttribute ? (el.getAttribute('href') || '') : '';
        var cls = (typeof el.className === 'string' ? el.className : '') + ' ' + (el.id || '');
        var txt = el.children.length === 0 ? (el.textContent || '') : '';
        var hit = txt.indexOf('تواصل معنا') !== -1 || href.indexOf('wa.me') !== -1 || href.indexOf('whatsapp') !== -1 || cls.toLowerCase().indexOf('whatsapp') !== -1;
        if (!hit) continue;
        var fx = outerFixedDeep(el);
        if (fx) result = fx;
      }
    }
    scan(document);
    if (result) window._velinaWa = result;
    return result;
  }
  function updateButtons(isOpen) {
    var vh = window.innerHeight, dynamicBottom = '88px', minTop = vh, cartBoxes = document.querySelectorAll('.cart-submit-wrap, [class*="cart-summary"], [class*="sticky-cart"], salla-add-product-button');
    for (var c = 0; c < cartBoxes.length; c++) {
      var curBox = cartBoxes[c]; while (curBox && curBox !== document.body && curBox !== document.documentElement) { if (window.getComputedStyle(curBox).position === 'fixed' || window.getComputedStyle(curBox).position === 'sticky') break; curBox = curBox.parentElement; }
      var box = (curBox && curBox !== document.body && curBox !== document.documentElement) ? curBox : cartBoxes[c], cs = window.getComputedStyle(box), r = box.getBoundingClientRect();
      if (cs.display !== 'none' && cs.visibility !== 'hidden' && r.height >= 40 && r.top > 0 && r.top < vh && (vh - r.bottom) <= 120 && r.top < minTop) minTop = r.top;
    }
    var inCart = minTop < vh || window.location.pathname.indexOf('/cart') !== -1 || window.location.pathname.indexOf('/checkout') !== -1;
    if (minTop < vh) { dynamicBottom = Math.max(255, Math.round(vh - minTop + 14)) + 'px'; } else if (inCart) { dynamicBottom = '265px'; }
    var totalTop = getTotalTop();
    if (totalTop < vh) { dynamicBottom = Math.round((vh - totalTop + 16) / 0.72) + 'px'; }
    var stNodes = document.querySelectorAll('button.scroll-top, #scroll-top, .btn-scroll-top, [class*="scroll-top"], .progress-wrap, [class*="progress-wrap"], [aria-label*="top"], [aria-label*="أعلى"]');
    var stBottomPx = parseInt(dynamicBottom, 10);
    for (var k = 0; k < stNodes.length; k++) {
      stNodes[k].style.setProperty('bottom', dynamicBottom, 'important'); stNodes[k].style.setProperty('zoom', '0.72', 'important');
      var sr = stNodes[k].getBoundingClientRect(); if (sr.height > 0 && sr.bottom > 0) stBottomPx = Math.round(vh - sr.bottom);
    }
    var waActualBottom = stBottomPx;
    if (totalTop < vh) { waActualBottom = Math.max(stBottomPx, Math.round(vh - totalTop + 82)); } else if (inCart) { waActualBottom = Math.max(stBottomPx, 255); }
    var waBottomZoomed = Math.round(waActualBottom / 0.72) + 'px', waLeft = inCart ? '56px' : '12px';
    var waStyle = document.getElementById('velina-wa-pos') || document.createElement('style');
    waStyle.id = 'velina-wa-pos';
    waStyle.textContent = isOpen
      ? '.salla-chat-widget,[id*="whatsapp"],[class*="whatsapp"],#wa-widget-send-button{visibility:hidden!important;opacity:0!important;pointer-events:none!important;}'
      : '.salla-chat-widget,[id*="whatsapp"],[class*="whatsapp"],#wa-widget-send-button{visibility:visible!important;opacity:1!important;pointer-events:auto!important;top:auto!important;bottom:' + waBottomZoomed + '!important;left:' + waLeft + '!important;right:auto!important;zoom:0.72!important;transform:none!important;}';
    (document.head || document.documentElement).appendChild(waStyle);
    var waEl = findWa();
    if (waEl) {
      if (isOpen) {
        waEl.style.setProperty('visibility', 'hidden', 'important'); waEl.style.setProperty('opacity', '0', 'important'); waEl.style.setProperty('pointer-events', 'none', 'important');
      } else {
        waEl.style.setProperty('visibility', 'visible', 'important'); waEl.style.setProperty('opacity', '1', 'important'); waEl.style.setProperty('pointer-events', 'auto', 'important');
        waEl.style.setProperty('position', 'fixed', 'important'); waEl.style.setProperty('top', 'auto', 'important'); waEl.style.setProperty('bottom', waBottomZoomed, 'important');
        waEl.style.setProperty('left', waLeft, 'important'); waEl.style.setProperty('right', 'auto', 'important');
        waEl.style.setProperty('zoom', '0.72', 'important'); waEl.style.setProperty('transform', 'none', 'important'); waEl.style.setProperty('z-index', '24', 'important');
      }
    }
  }
  var lastState = null, closeTimer = null, updateTimer = null;
  function updateOverlay() {
    injectSafeStyle(); hideOuterRedDrawerClose(); hideBottomNav(); liftCartSummary();
    if (isDrawerOpen()) startDrawerLoop();
    var isOpen = isAnyOverlayOpen();
    if (isOpen) {
      if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
      updateButtons(true); if (lastState !== true) { lastState = true; if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) window.flutter_inappwebview.callHandler('onModalState', true); }
    } else if (lastState === true && !closeTimer) {
      closeTimer = setTimeout(function() { closeTimer = null; if (!isAnyOverlayOpen()) { lastState = false; hideBottomNav(); updateButtons(false); if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) window.flutter_inappwebview.callHandler('onModalState', false); } }, 120);
    } else { updateButtons(false); if (lastState === null) lastState = false; }
  }
  function scheduleUpdate(imm) { if (updateTimer) clearTimeout(updateTimer); if (imm) { updateOverlay(); return; } updateTimer = setTimeout(updateOverlay, 180); }
  if (!window._velinaWatcher) {
    window._velinaWatcher = true;
    window.addEventListener('scroll', function() { window._velinaScrolling = true; clearTimeout(window._velinaScrollTimer); window._velinaScrollTimer = setTimeout(function() { window._velinaScrolling = false; scheduleUpdate(true); }, 150); }, { passive: true });
    document.addEventListener('DOMContentLoaded', function() { scheduleUpdate(true); }); document.addEventListener('click', function() { scheduleUpdate(true); setTimeout(scheduleUpdate, 80); setTimeout(scheduleUpdate, 250); setTimeout(scheduleUpdate, 500); }, true);
    new MutationObserver(function() {
      if (document.documentElement.classList.contains('mm-wrapper_opened')) { startDrawerLoop(); }
      scheduleUpdate();
    }).observe(document.documentElement, { attributes: true, childList: true, subtree: true });
    setTimeout(function() { scheduleUpdate(true); }, 1500); setTimeout(function() { scheduleUpdate(true); }, 3500);
  }
  scheduleUpdate(true);
})();
''';
}
