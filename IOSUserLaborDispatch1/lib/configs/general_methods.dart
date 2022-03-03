import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../shared_widgets/showDialog.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'app_colors.dart';

String getRandomString(int length) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

String requiredValidation(String value) {
  if (value.length < 1)
    return '*Required';
  else
    return null;
}

String validateMobileNumberLength(String value) {
  if (value.length != 11)
    return 'Phone Number must be of 11 digit';
  else
    return null;
}

String validatePasswordLength(String value) {
  if (value.length < 8)
    return 'Password must be of 8 characters at least';
  else
    return null;
}

String validateConfirmPassword(String confirmPassword, String password) {
  if (confirmPassword != password)
    return 'Confirm Password must be same as Password';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email Address';
  else
    return null;
}

getFileBase64(path) {
  File image = new File(path);
  return base64Encode(image.readAsBytesSync());
}

String getDateFormattedAsDDMMYYYYHHMM(DateTime date) {
  return DateFormat('d MMM yyyy - hh:mm a').format(date).toString();
}

String getDateFormattedAsHHMM(DateTime date) {
  return DateFormat('hh:mm a').format(date).toString();
}

String getDate(DateTime date) {
  return DateFormat('d').format(date).toString();
}

String getDateFormattedAsYYYYMMMD(DateTime date) {
  return DateFormat('yyyy-MMM-d').format(date).toString();
}

String getDateFormattedAsDDMMYYYY(DateTime date) {
  return DateFormat('d/MM/yyyy').format(date).toString();
}

String getDateFormattedAsDayMonDate(DateTime date) {
  return DateFormat('E MMM d, yyyy').format(date).toString();
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(now);
}

String priceFormatter(int amount) {
  var format = new NumberFormat("#,###", "en_US");
  return '${format.format(amount)}';
}

// void launchWhatsApp(String phone, String message) async {
//   String url() {
//     if (Platform.isIOS) {
//       return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
//     } else {
//       return "whatsapp://send?phone=+92$phone&text=${Uri.parse(message)}";
//     }
//   }
//
//   if (await canLaunch(url())) {
//     await launch(url());
//   } else {
//     throw 'Could not launch ${url()}';
//   }
// }
//
// void launchPhone(String phone) async {
//   var url = "tel:${phone}";
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

// launchUrl(url, BuildContext context) async {
//   if (await canLaunch(url)) {
//     await launch(
//       url,
//     );
//   } else {
//     ToastUtil.showToast(context, 'Invalid Url');
//     throw 'Could not launch $url';
//   }
// }

Future getImageChoice({BuildContext context, Function cameraMethod, Function galleryMethod}) async {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 16,
          child: Container(
            // decoration: DecorationBoxes.decorationSquareWithShadowWithNormalRadius(),
            padding: EdgeInsets.all(20),
            height: 150.0,
            width: MediaQuery
                .of(context)
                .size
                .width - 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Camera or Gallery?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: cameraMethod,
                      child: new Icon(
                        Icons.add_a_photo,
                        color: AppColors.APP_PRIMARY_COLOR,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    RawMaterialButton(
                      onPressed: galleryMethod,
                      child: new Icon(
                        Icons.image,
                        color: AppColors.APP_PRIMARY_COLOR,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

setImage(image){
  return image == "" || image ==  null || image == "null" ? AssetImage('assets/avatar.png') : MemoryImage(base64Decode(image));
}

getLabel(String label, {double padding}) {
  return Padding(
    padding: EdgeInsets.only(left: padding ?? 10.0),
    child: new Text(
      label,
      style: TextStyle(
        fontFamily: "SF Cartoonist Hand",
        fontSize: 14,
        color: Color(0xff4f4f4f),
      ),
    ),
  );
}

showGoToSettingsPopUp(BuildContext context) async {
  return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              title: Text(
                "Permission required!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                margin:
                                const EdgeInsets.only(top: 5.0, bottom: 20),
                                child: new Text(
                                    'This app required some permissions to process your information. Please enable them manually from "Settings".'),
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              // side: BorderSide(color: Color.fromRGBO(113, 128, 233, 1)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(12),
                            color: Colors.grey,
                            child: Text('CANCEL',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          new RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              // side: BorderSide(color: Color.fromRGBO(113, 128, 233, 1)),
                            ),
                            onPressed: () {
                              openAppSettings();
                            },
                            padding: EdgeInsets.all(12),
                            child: Text('Open Settings',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}

Future<bool> getPermission(BuildContext context, perm) async {
  Permission permission = await Permission.byValue(perm);
  PermissionStatus pStatus = await permission.request();
  return statusPermission(context, pStatus, permission);
}

Future<bool> statusPermission(BuildContext context, perStatus, Permission permissionObj) async {
  if (perStatus == PermissionStatus.granted) {
    return true;
  } else if (perStatus == PermissionStatus.limited) {
    PermissionStatus status = await permissionObj.request();
    return statusPermission(context, status, permissionObj);
  } else if (perStatus == PermissionStatus.denied) {
    PermissionStatus status = await permissionObj.request();
    return statusPermission(context, status, permissionObj);
  } else if (perStatus == PermissionStatus.restricted) {
    showAlert(context, "Open settings to enable permissions");
  } else if (perStatus == PermissionStatus.permanentlyDenied) {
    showAlert(context, "Open settings to enable permissions");
  } else {
    showAlert(context, "Open settings to enable permissions");
    return false;
  }
}

String getDiffYMD(DateTime then, DateTime now) {
  int years = now.year - then.year;
  int months = now.month - then.month;
  int days = now.day - then.day;
  if (months < 0 || (months == 0 && days < 0)) {
    years--;
    months += (days < 0 ? 11 : 12);
  }
  if (days < 0) {
    final monthAgo = DateTime(now.year, now.month - 1, then.day);
    days = now.difference(monthAgo).inDays + 1;
  }

  if(years == 0){
    return '$months months $days days';
  }
  else if(years == 0 && months == 0){
    return '$days days';
  }
  return '$years years $months months $days days';
}