import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/views/docs_view.dart';
import 'package:ios_user_labor_dispatch_1/views/image_view.dart';
import 'package:ios_user_labor_dispatch_1/views/setup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocsImagesView extends StatefulWidget {
  _DocsImagesViewState createState() => new _DocsImagesViewState();
}

class _DocsImagesViewState extends State<DocsImagesView> {

  final prefs = SharedPreferences.getInstance();
  var companyId;
  var menus = List<Map<String, dynamic>>();

  @override
  void initState() {
    getCompanyId();
    super.initState();
  }

  getCompanyId(){
    prefs.then((value) {
      companyId = value.getString('companyId');
      setMenus();
    });
  }

  setMenus(){
    menus.clear();
    menus.add({
      'name': 'Documents',
      'color': AppColors.APP_BLUE_COLOR,
      'icons': Icons.edit,
      'route': companyId == null ? Setup() : DocumentsView(),
    });
    menus.add({
      'name': 'Images',
      'color': AppColors.APP_BLUE_COLOR,
      'icons': Icons.image,
      'route': companyId == null ? Setup() : ImageView(),
    });
    setState(() { });
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
          padding: EdgeInsets.all(5),
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
                        builder: (context) => menus[index]['route'])).then((value) {
                  getCompanyId();
                });
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
                      // width: screenSize.width * 0.2,
                        child: Text(menus[index]['name'], style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 12), textAlign: TextAlign.center,)
                    )
                  ],
                ),
              ),
            );
          });
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