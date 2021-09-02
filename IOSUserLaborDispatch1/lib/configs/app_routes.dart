import 'package:flutter/material.dart';
import '../views/dashboard_view.dart';
import '../views/setup_view.dart';

var routes = <String, WidgetBuilder>{
  '/Setup': (BuildContext context) => new Setup(),
  '/Dashboard': (BuildContext context) => new Dashboard(),
};
