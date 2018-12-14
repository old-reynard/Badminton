import 'package:flutter/material.dart';

import 'package:badminton/data/contract.dart';

class Backdrop extends StatefulWidget {
  final AnimationController controller;
  final Widget backLayer;

  Backdrop({this.controller, this.backLayer});

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> {
  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {

    final backPanelHeight = constraints.biggest.height;
    final frontPanelHeight = BadSizes.backdropHeight;

    return RelativeRectTween(
            begin: RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, 0.0),
            end: RelativeRect.fromLTRB(0.0, frontPanelHeight, 0.0, 0.0))
        .animate(
            CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }


  bool get isBackdropVisible {
    final AnimationStatus status = widget.controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }


  Widget bothPanels(BuildContext context, BoxConstraints constraints) {

    final double headerHeight = isBackdropVisible ? BadSizes.headerHeight : 0;

    return Container(
      child: Stack(
        children: <Widget>[
          widget.backLayer,
          PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: Material(
              elevation: 12.0,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(BadSizes.headerBorderRadius),
                  topRight: Radius.circular(BadSizes.headerBorderRadius)),
              child: Column(
                children: <Widget>[
                  Container(
                    height: headerHeight,
                    child: Material(
                      color: BadColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(BadSizes.headerBorderRadius),
                            topRight: Radius.circular(BadSizes.headerBorderRadius)),
                      ),
                      child: Center(
                        child: Text(
                          "Header",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text("Front Panel",
                          style:
                              TextStyle(fontSize: 24.0, color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: bothPanels,
    );
  }
}
