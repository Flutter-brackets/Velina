import 'dart:collection';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dom_cleaner_script.dart';

/// Pre-injection scripts and DOM triggers for seamless Salla store integration.
class WebviewScripts {
  const WebviewScripts._();

  /// 100% safe DOM cleaner and modal watcher script.
  static String get safeScript => DomCleanerScript.script;

  /// Pre-configured initial user scripts injected at document start.
  static final UnmodifiableListView<UserScript> initialUserScripts =
      UnmodifiableListView<UserScript>([
        UserScript(
          source: DomCleanerScript.script,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          forMainFrameOnly: false,
        ),
      ]);

  /// Reliable multi-strategy Salla login modal trigger.
  static const String loginTriggerJs = '''
(function openSallaLogin() {
  if (window.salla && salla.event && typeof salla.event.dispatch === 'function') {
    salla.event.dispatch('login::open');
  }
  var loginModal = document.querySelector('salla-login-modal');
  if (loginModal) {
    if (typeof loginModal.open === 'function') loginModal.open();
    loginModal.setAttribute('open', '');
  }
  var triggers = document.querySelectorAll(
    '[onclick*="login"], [data-modal="login"], button[aria-label*="دخول"], a[href*="/login"], salla-user-menu button, .header-btn[aria-label*="user"]'
  );
  for (var i = 0; i < triggers.length; i++) {
    var btn = triggers[i];
    if (btn.offsetParent !== null || btn.closest('header')) { btn.click(); break; }
  }
  var userMenu = document.querySelector('salla-user-menu');
  if (userMenu && userMenu.shadowRoot) {
    var shadowBtn = userMenu.shadowRoot.querySelector('button, a');
    if (shadowBtn) shadowBtn.click();
  }
})();
''';

  /// Reliable Salla search overlay trigger.
  static const String searchTriggerJs = '''
(function() {
  if (window.salla && salla.event && typeof salla.event.dispatch === 'function') {
    try { salla.event.dispatch('search::open'); return; } catch(e) {}
  }
  var s = document.querySelector('salla-search');
  if (s && typeof s.open === 'function') {
    try { s.open(); return; } catch(e) {}
  }
  var btn = document.querySelector('.header-btn--search, .mob-srch button, .mob-srch a, [data-salla-search]');
  if (btn) btn.click();
})();
''';
}
