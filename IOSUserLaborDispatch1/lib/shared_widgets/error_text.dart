

import 'package:flutter/material.dart';

class ErrorReactiveWidget extends StatelessWidget {
  final Widget child;
  final String error;
  final bool errorExists;

  const ErrorReactiveWidget({Key key, this.error, this.errorExists = false, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        Visibility(
          visible: errorExists,
              child: Padding(
            padding: const EdgeInsets.only(left:4.0, top: 4),
            child: Text(error ?? "this field is required", style:Theme.of(context).textTheme.caption.copyWith(
              color:Colors.red
            )),
          ),
        ),
      ],
    );
  }
}