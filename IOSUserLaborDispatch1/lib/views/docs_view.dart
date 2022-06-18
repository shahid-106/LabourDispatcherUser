import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/no_record_found.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentsView extends StatefulWidget {
  _DocumentsViewState createState() => new _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {

  final prefs = SharedPreferences.getInstance();
  var companyId;
  var menus = List<Map<String, dynamic>>();

  @override
  void initState() {
    prefs.then((value) {
      companyId = value.getString('companyId');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget screenUI() {
      return Center(
        // padding: EdgeInsets.all(20),
        child: NoRecordFound(msg: 'No File Found',),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.APP_PRIMARY_COLOR,
        elevation: 0,
        titleSpacing: 10,
        title: Text('DispatchLabor: USER', style: TextStyle(color: AppColors.APP_WHITE_COLOR),),
        iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
      ),
      body: screenUI(),
    );
  }

}