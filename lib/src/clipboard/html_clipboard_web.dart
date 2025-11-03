// Web implementation: copy rich HTML via contenteditable selection; fall back to writeText.

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as dom;

Future<void> copyHtml({required String html, required String plainText}) async {
  // Preferred: use a hidden contenteditable container and copy selection (keeps HTML)
  try {
    final container = dom.DivElement()
      ..contentEditable = 'true'
      ..style.position = 'fixed'
      ..style.left = '-9999px'
      ..style.top = '0'
      ..setInnerHtml(html, treeSanitizer: dom.NodeTreeSanitizer.trusted);

    dom.document.body!.append(container);

    final selection = dom.window.getSelection();
    selection?.removeAllRanges();
    final range = dom.document.createRange();
    range.selectNodeContents(container);
    selection?.addRange(range);

    dom.document.execCommand('copy');

    selection?.removeAllRanges();
    container.remove();
    return;
  } catch (_) {
    // fallback below
  }

  // Fallback: plain text copy
  try {
    await dom.window.navigator.clipboard?.writeText(plainText);
  } catch (_) {
    // Last resort: textarea + execCommand
    try {
      final temp = dom.TextAreaElement()
        ..value = plainText
        ..style.position = 'fixed'
        ..style.left = '-9999px';
      dom.document.body!.append(temp);
      temp.focus();
      temp.select();
      dom.document.execCommand('copy');
      temp.remove();
    } catch (_) {}
  }
}
