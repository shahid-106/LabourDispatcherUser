import 'package:flutter/material.dart';

class BackGroundImageCard extends StatelessWidget {
  final BorderRadius borderRadius;
  final String imagePath;
  final double circularRadius;

  const BackGroundImageCard({
    Key key,
    this.borderRadius,
    this.imagePath,
    this.circularRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: borderRadius ??
              BorderRadius.only(
                topLeft: Radius.circular(circularRadius),
                topRight: Radius.circular(circularRadius),
              ),
          image:
              DecorationImage(fit: BoxFit.cover, image: AssetImage(imagePath))),
    );
  }
}
