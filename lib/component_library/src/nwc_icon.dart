// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NWCIcons {
  arrow_back,
  arrow_forward,
  arrow_up_right,
  arrow_down_left,
  command,
  close,
  copy,
  check,
  info,
  nwc,
  settings,
  share_black,
  zap,
}

extension NWCIconsExtension on NWCIcons {
  String get data {
    switch (this) {
      case NWCIcons.nwc:
        return 'assets/icons/nwc_logo.svg';
      case NWCIcons.arrow_forward:
        return 'assets/icons/arrow_forward.svg';
      case NWCIcons.arrow_up_right:
        return 'assets/icons/arrow-up-right.svg';
      case NWCIcons.arrow_down_left:
        return 'assets/icons/arrow-down-left.svg';
      case NWCIcons.command:
        return 'assets/icons/command.svg';
      case NWCIcons.info:
        return 'assets/icons/info.svg';
      case NWCIcons.zap:
        return 'assets/icons/zap.svg';
      case NWCIcons.settings:
        return 'assets/icons/settings.svg';
      case NWCIcons.close:
        return 'assets/icons/close.svg';
      case NWCIcons.arrow_back:
        return 'assets/icons/arrow_back.svg';
      case NWCIcons.copy:
        return 'assets/icons/copy.svg';
      case NWCIcons.share_black:
        return 'assets/icons/share_black.svg';
      case NWCIcons.check:
        return 'assets/icons/check.svg';
    }
  }
}

class NWCIcon extends StatelessWidget {
  final NWCIcons icon;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;

  const NWCIcon(
    this.icon, {
    super.key,
    this.height,
    this.width,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.data,
      width: width,
      height: height,
      colorFilter: colorFilter,
    );
  }
}
