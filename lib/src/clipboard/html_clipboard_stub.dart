// Stub (non-web) implementation: fall back to plain text clipboard.

import 'package:flutter/services.dart';

Future<void> copyHtml({required String html, required String plainText}) async {
  await Clipboard.setData(ClipboardData(text: plainText));
}
