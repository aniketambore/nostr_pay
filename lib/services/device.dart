import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class Device {
  Future setClipboardText(String text) async {
    debugPrint("Setting clipboard text: $text");
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future shareText(String text) {
    debugPrint("Sharing text: $text");
    return Share.share(text);
  }
}
