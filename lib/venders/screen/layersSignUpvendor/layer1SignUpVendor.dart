import 'package:flutter/material.dart';
import 'package:wedweel/config.dart';

class Layer1SignUpVendor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 354,
      decoration: BoxDecoration(
        color: layerOneBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          bottomRight: Radius.circular(60.0)
        ),
      ),
    );
  }
}