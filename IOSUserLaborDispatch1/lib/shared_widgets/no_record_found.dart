import '../configs/app_colors.dart';

import '../shared_widgets/buttons.dart';
import 'package:flutter/material.dart';

class NoRecordFound extends StatelessWidget {
  final String msg;
  final String btnText;
  final Function onPressed;
  final IconData icon;

  NoRecordFound({this.msg = '', this.btnText, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                    msg.isEmpty ? "No Record Found!" : msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.APP_BLACK_COLOR,
                    ),
                  ),
            ],
          )),
    );
  }
}
