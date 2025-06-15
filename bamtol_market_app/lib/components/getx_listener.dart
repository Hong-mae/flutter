import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxListener<T> extends StatefulWidget {
  final Rx<T> stream;
  final Widget child;
  final Function(T) listen;
  final Function()? initCall;

  const GetxListener({
    super.key,
    this.initCall,
    required this.stream,
    required this.child,
    required this.listen,
  });

  @override
  State<GetxListener<T>> createState() => _GetxListenerState();
}

class _GetxListenerState<T> extends State<GetxListener<T>> {
  late final StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();

    if (widget.initCall != null) {
      widget.initCall!();
    }

    _subscription = widget.stream.listen(widget.listen);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
