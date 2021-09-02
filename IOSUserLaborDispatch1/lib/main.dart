import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../views/dashboard_view.dart';
import 'configs/app_colors.dart';
import 'configs/app_routes.dart';
import 'controller/push_notification_service.dart';

final appTheme = ThemeData(
  primaryColor: AppColors.APP_WHITE_COLOR,
  scaffoldBackgroundColor: AppColors.APP_BACKGROUND_COLOR,
  primaryIconTheme: IconThemeData(color: AppColors.APP_BLACK_COLOR),
  iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if(kReleaseMode){
    new PushNotificationService().setUpFirebase();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IOSUserLaborDispatch1',
      theme: appTheme,
      routes: routes,
      home: Dashboard(),
    );
  }
}