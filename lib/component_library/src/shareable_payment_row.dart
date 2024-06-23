import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nostr_pay/component_library/component_library.dart';
import 'package:nostr_pay/services/device.dart';

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final String sharedValue;
  final bool isURL;
  final bool isExpanded;
  final TextStyle? titleTextStyle;
  final TextStyle? childrenTextStyle;
  final EdgeInsets? iconPadding;
  final EdgeInsets? tilePadding;
  final EdgeInsets? childrenPadding;
  final bool hideCopyShare;

  const ShareablePaymentRow({
    super.key,
    required this.title,
    required this.sharedValue,
    this.isURL = false,
    this.isExpanded = false,
    this.titleTextStyle,
    this.childrenTextStyle,
    this.iconPadding,
    this.tilePadding,
    this.childrenPadding,
    this.hideCopyShare = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ExpansionTile(
      iconColor: isExpanded ? Colors.transparent : NWCColors.woodSmoke,
      collapsedIconColor: NWCColors.woodSmoke,
      initiallyExpanded: isExpanded,
      tilePadding: tilePadding,
      title: AutoSizeText(
        title,
        style: titleTextStyle ??
            textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: NWCColors.black,
            ),
        maxLines: 2,
      ),
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: childrenPadding ??
                    const EdgeInsets.only(
                      left: 16.0,
                      right: 0.0,
                      bottom: 8,
                    ),
                child: GestureDetector(
                  // onTap: isURL
                  //     ? () => launchLinkOnExternalBrowser(context,
                  //         linkAddress: sharedValue)
                  //     : null,
                  onTap: () {},
                  child: Text(
                    sharedValue,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                    style: childrenTextStyle ??
                        textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: hideCopyShare
                  ? const SizedBox(height: 10)
                  : Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            alignment: Alignment.centerRight,
                            padding: iconPadding ??
                                const EdgeInsets.only(right: 8.0),
                            tooltip: 'Copy $title',
                            iconSize: 16.0,
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Device().setClipboardText(sharedValue);
                              Navigator.pop(context);
                              showToast(
                                context,
                                title: '$title was copied to your clipboard.',
                                autoCloseDuration: const Duration(seconds: 4),
                              );
                            },
                          ),
                          IconButton(
                            padding: iconPadding ??
                                const EdgeInsets.only(right: 8.0),
                            tooltip: 'Share',
                            iconSize: 16.0,
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              Device().shareText(sharedValue);
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
