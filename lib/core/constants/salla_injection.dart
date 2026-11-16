import '../../features/webview/services/dom_cleaner_script.dart';

/// CSS & JavaScript injection snippets for Salla web store integration.
class SallaInjection {
  const SallaInjection._();

  /// 100% safe DOM cleaner and overlay watcher script.
  static String get injectSallaFixes => DomCleanerScript.script;

  /// Triggers Salla's mobile drawer menu.
  static const String openDrawerJs =
      "document.querySelector('.mburger, a[href=\"#mobile-menu\"], [data-id=\"mobile-menu\"], .header-btn--menu')?.click();";

  /// Opens Salla's built-in login/profile modal.
  static const String openProfileModalJs =
      "var m=document.querySelector('salla-login-modal');if(m&&typeof m.open==='function'){m.open();}else{document.querySelector('.header-signInBtn, [slot=\"login-btn\"], .header-btn--user')?.click();}";
}
