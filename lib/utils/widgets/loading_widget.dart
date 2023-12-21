import 'package:flutter/material.dart';
import 'package:weather_app/utils/utils.dart';

class LoadingWidget extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final Widget child;
  final Widget? loadingWidget;
  final bool? loading;
  final void Function(dynamic err)? errorHandler;
  const LoadingWidget({
    super.key,
    this.onPressed,
    this.errorHandler,
    this.loading,
    required this.child,
    this.loadingWidget,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    _loading = widget.loading ?? _loading;
    return InkWell(
      onTap: _loading || widget.onPressed == null
          ? null
          : () async {
              setState(() {
                _loading = true;
              });
              try {
                await widget.onPressed!();
              } catch (e) {
                if (widget.errorHandler != null) {
                  widget.errorHandler!(e);
                } else if (context.mounted) {
                  showMsg(context, e.toString());
                }
              }
              if (context.mounted) {
                setState(() {
                  _loading = false;
                });
              }
            },
      child: _loading
          ? (widget.loadingWidget ?? const CircularProgressIndicatorRainbow())
          : widget.child,
    );
  }
}
