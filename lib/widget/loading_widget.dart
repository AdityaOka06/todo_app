import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingWidget(BuildContext context) {
  return SpinKitFadingCircle(
    color: Theme.of(context).primaryColor,
  );
}