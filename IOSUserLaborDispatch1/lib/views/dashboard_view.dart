import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/views/start_job_view.dart';
import 'package:ios_user_labor_dispatch_1/views/edit_view.dart';
import 'package:ios_user_labor_dispatch_1/views/export_view.dart';
import 'package:ios_user_labor_dispatch_1/views/images_view.dart';
import 'package:ios_user_labor_dispatch_1/views/location_view.dart';
import 'package:ios_user_labor_dispatch_1/views/reports_view.dart';
import 'package:ios_user_labor_dispatch_1/views/setup_view.dart';
import 'package:ios_user_labor_dispatch_1/views/stop_job_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final prefs = SharedPreferences.getInstance();
  var companyId;

  var menus = List<Map<String, dynamic>>();

  @override
  void initState() {

    getCompanyId();
    super.initState();
  }

  setMenus(){
    menus.clear();
    menus.add({
      'name': 'Setup',
      'color': AppColors.APP_GREEN_COLOR,
      'icons': Icons.settings,
      'route': Setup(),
    });
    menus.add({
      'name': 'Start A Job',
      'color': AppColors.APP_LIGHT_GREEN_COLOR,
      'icons': Icons.play_circle_fill,
      'route': companyId == null ? Setup(route: StartJobView(),) : StartJobView(),
    });
    menus.add({
      'name': 'Stop A Job',
      'color': AppColors.APP_RED_COLOR,
      'icons': Icons.stop_circle_sharp,
      'route': companyId == null ? Setup() : StopJobView(),
    });
    menus.add({
      'name': 'Reports',
      'color': AppColors.APP_LIGHT_GREEN_COLOR,
      'icons': Icons.request_page_outlined,
      'route': companyId == null ? Setup() : Reports(),
    });
    menus.add({
      'name': 'Edit',
      'color': AppColors.APP_ORANGE_COLOR,
      'icons': Icons.edit,
      'route': companyId == null ? Setup() : Edit(),
    });
    menus.add({
      'name': 'Export',
      'color': AppColors.APP_ORANGE_COLOR,
      'icons': Icons.publish,
      'route': companyId == null ? Setup() : Export(),
    });
    menus.add({
      'name': 'GPS',
      'color': AppColors.APP_BLUE_COLOR,
      'icons': Icons.location_pin,
      'route': companyId == null ? Setup() : LocationView(),
    });
    menus.add({
      'name': 'Images & Documents',
      'color': AppColors.APP_BLUE_COLOR,
      'icons': Icons.assessment,
      'route': companyId == null ? Setup() : Images(),
    });
    setState(() { });
  }

  getCompanyId(){
    prefs.then((value) {
      companyId = value.getString('companyId');
      setMenus();
    });
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    var _crossAxisSpacing = 10;
    var _screenWidth = screenSize.width;
    var _screenHeight = screenSize.height;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = _screenHeight * 0.21;
    var _aspectRatio = _width / cellHeight;

    Widget screenUI() {
      return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: menus.length ,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount,
              childAspectRatio: _aspectRatio),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => menus[index]['route']));
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: DecorationBoxes.decorationSquareWithShadow(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => menus[index]['route'])).then((value) {
                          getCompanyId();
                        });
                      },
                      elevation: 2.0,
                      color: menus[index]['color'],
                      child: Icon(
                        menus[index]['icons'],
                        size: 25.0,
                        color: AppColors.APP_WHITE_COLOR,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                    Container(
                      width: screenSize.width * 0.2,
                        child: Text(menus[index]['name'], style: TextStyle(color: AppColors.APP_BLACK_COLOR), textAlign: TextAlign.center,)
                    )
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.APP_PRIMARY_COLOR,
        elevation: 0,
        titleSpacing: 10,
        title: Text('DispatchLabor: USER', style: TextStyle(color: AppColors.APP_WHITE_COLOR),),
      ),
      body: screenUI(),
    );
  }

}