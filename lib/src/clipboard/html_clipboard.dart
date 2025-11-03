// Cross-platform HTML clipboard helper.
// Uses a web implementation when running on the web and falls back to plain-text elsewhere.

import 'html_clipboard_stub.dart' if (dart.library.html) 'html_clipboard_web.dart' as impl;

class HtmlClipboard {
  /// Copies HTML to the clipboard when supported (web), and always sets a plain-text fallback.
  static Future<void> copy({required String html, required String plainText}) {
    return impl.copyHtml(html: html, plainText: plainText);
  }
}
