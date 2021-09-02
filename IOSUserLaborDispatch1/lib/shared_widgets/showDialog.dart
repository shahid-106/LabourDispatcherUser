import '../configs/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlertWithTwoButtons(BuildContext context, String text, {Function onPressed}) async {
  return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(builder: (context, setState) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                content: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: AppColors.APP_PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          onPressed: () {
                            if(onPressed == null){
                              Navigator.pop(context);
                            }
                            else{
                              onPressed();
                            }
                            //onPressed??Navigator.pop(context);
                          },
                          padding: EdgeInsets.all(12),
                          child: Text('Yes',
                              style:
                              TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                        RaisedButton(
                          color: AppColors.APP_PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.all(12),
                          child: Text('No',
                              style:
                              TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}

showAlert(BuildContext context, String text, {Function onPressed}) async {
  return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(builder: (context, setState) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                content: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                        ),
                      ],
                    ),
                    RaisedButton(
                      color: AppColors.APP_PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
                        if(onPressed == null){
                          Navigator.pop(context);
                        }
                        else{
                          onPressed();
                        }
                        //onPressed??Navigator.pop(context);
                      },
                      padding: EdgeInsets.all(12),
                      child: Text('OK',
                          style:
                          TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}
