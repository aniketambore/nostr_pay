import 'package:flutter/material.dart';

import 'transparent_page_route.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.value,
    this.label,
    this.color,
    this.strokeWidth = 4.0,
  });

  final double? value;
  final String? label;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: value,
          semanticsLabel: label,
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

TransparentPageRoute createLoaderRoute(BuildContext context,
    {String message = "",
    double opacity = 0.5,
    Future? action,
    Function? onClose}) {
  return TransparentPageRoute((context) {
    return TransparentRouteLoader(
        message: message, opacity: opacity, action: action, onClose: onClose);
  });
}

class TransparentRouteLoader extends StatefulWidget {
  const TransparentRouteLoader({
    super.key,
    required this.message,
    this.opacity = 0.5,
    this.action,
    this.onClose,
  });
  final String message;
  final double opacity;
  final Future? action;
  final Function? onClose;

  @override
  State<TransparentRouteLoader> createState() => _TransparentRouteLoaderState();
}

class _TransparentRouteLoaderState extends State<TransparentRouteLoader> {
  @override
  void initState() {
    super.initState();
    widget.action?.whenComplete(() {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenLoader(
        message: widget.message,
        opacity: widget.opacity,
        onClose: widget.onClose);
  }
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({
    super.key,
    this.message,
    this.opacity = 0.5,
    this.value,
    this.progressColor,
    this.bgColor = Colors.black,
    this.onClose,
  });

  final String? message;
  final double opacity;
  final double? value;
  final Color? progressColor;
  final Color bgColor;
  final Function? onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: bgColor.withOpacity(opacity),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Loader(value: value, label: message, color: progressColor),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: message != null
                        ? Text(message!, textAlign: TextAlign.center)
                        : const SizedBox(),
                  )
                ],
              ),
            ),
          ),
          onClose != null
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () => onClose!(),
                      icon: Icon(Icons.close,
                          color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
