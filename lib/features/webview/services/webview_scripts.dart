import 'dart:collection';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dom_cleaner_script.dart';

/// Pre-injection scripts and DOM triggers for seamless Salla store integration.
class WebviewScripts {
  const WebviewScripts._();

  static String get safeScript => DomCleanerScript.script;

  static const String earlyHideCss =
      '#mobile-nav, .mobile-nav-inner, .mobile-nav-outer, .s-bottom-nav, salla-bottom-nav, salla-chat-widget, .salla-chat-widget, #wa-widget-send-button, [id*="moatmt"], [class*="moatmt"], [id*="widget-host"], [class*="widget-host"], moatmt-widget-host, #moatmt_chat_widget, #moatmt-widget-send-button, .moatmt-chat-box { display: none !important; height: 0 !important; width: 0 !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; }';

  static const String earlyHideScript =
      '''
(function() {
  try {
    var doc = document.documentElement || document.head;
    if (doc && !document.getElementById('velina-early-hide')) {
      var s = document.createElement('style');
      s.id = 'velina-early-hide';
      s.textContent = '$earlyHideCss';
      doc.appendChild(s);
    }
  } catch (e) {}
})();
''';

  static final UnmodifiableListView<UserScript> initialUserScripts =
      UnmodifiableListView<UserScript>([
        UserScript(
          source: earlyHideScript,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          forMainFrameOnly: false,
        ),
        UserScript(
          source: DomCleanerScript.script,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
          forMainFrameOnly: true,
        ),
      ]);

  static const String loginTriggerJs = '''
(function() {
  if (window.salla && salla.event && typeof salla.event.dispatch === 'function') salla.event.dispatch('login::open');
  var m = document.querySelector('salla-login-modal');
  if (m) { if (typeof m.open === 'function') m.open(); m.setAttribute('open', ''); return; }
  var btn = document.querySelector('[onclick*="login"], [data-modal="login"], button[aria-label*="دخول"], a[href*="/login"], salla-user-menu button');
  if (btn) btn.click();
})();
''';

  static const String searchTriggerJs = '''
(function() {
  if (window.salla && salla.event && typeof salla.event.dispatch === 'function') {
    try { salla.event.dispatch('search::open'); return; } catch(e) {}
  }
  var s = document.querySelector('salla-search');
  if (s && typeof s.open === 'function') { try { s.open(); return; } catch(e) {} }
  var btn = document.querySelector('.header-btn--search, .mob-srch button, .mob-srch a, [data-salla-search]');
  if (btn) btn.click();
})();
''';
}
