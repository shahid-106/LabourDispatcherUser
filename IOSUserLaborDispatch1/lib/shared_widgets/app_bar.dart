import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'decoration.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  var scaffoldKey;
  Row actionButtons;
  MyAppBar({this.scaffoldKey, this.actionButtons});

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(70, 70);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        // preferredSize: Size(70, 80),
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: DecorationBoxes.decorationBackgroundWithBottomRadius(color: AppColors.APP_BACKGROUND_COLOR),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.028,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sort,
                        size: 25.0,
                      ),
                      onPressed: () => scaffoldKey.currentState.openDrawer(),
                    ),
                    Image.asset('assets/logo_black.png'),
                    actionButtons,
                  ],
                ),
              ],
            ),
          ),
    );
  }

}