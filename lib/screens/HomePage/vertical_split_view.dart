import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HorizontalSplitView extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double ratio;
  final Color handleColor;
  final Color iconColor;

  const HorizontalSplitView({
    Key? key,
    required this.left,
    required this.right,
    this.ratio = 0.5,
    this.handleColor = Colors.black,
    this.iconColor = Colors.white,
  })  : assert(ratio >= 0),
        assert(ratio <= 1),
        super(key: key);

  @override
  State<HorizontalSplitView> createState() => _HorizontalSplitViewState();
}

class _HorizontalSplitViewState extends State<HorizontalSplitView> {
  final dividerWidth = 12.0;

  //from 0-1
  late double ratio;
  double maxWidth = 0;

  double get width1 => max(1, ratio * maxWidth);

  double get width2 => max(1, (1 - ratio) * maxWidth);

  @override
  void initState() {
    super.initState();
    ratio = widget.ratio;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        assert(ratio <= 1);
        assert(ratio >= 0);

        if (maxWidth == 0) {
          maxWidth = constraints.maxWidth - dividerWidth;
        }

        return SizedBox(
          width: constraints.maxWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: width1.toInt(),
                child: widget.left,
              ),
              Material(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  dragStartBehavior: DragStartBehavior.down,
                  child: Container(
                    height: constraints.maxWidth,
                    width: dividerWidth,
                    decoration: BoxDecoration(
                      color: widget.handleColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FittedBox(
                      child: Icon(
                        Icons.drag_handle,
                        color: widget.iconColor,
                      ),
                    ),
                  ),
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      ratio += details.delta.dx / maxWidth;
                      if (ratio > 1) {
                        ratio = 1;
                      } else if (ratio < 0) {
                        ratio = 0;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                flex: width2.toInt(),
                child: widget.right,
              ),
            ],
          ),
        );
      },
    );
  }
}
