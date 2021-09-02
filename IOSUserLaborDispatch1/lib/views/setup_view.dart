import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setup extends StatefulWidget {
  var route;
  Setup({this.route});

  _SetupState createState() => new _SetupState();
}

class _SetupState extends State<Setup> {
  final prefs = SharedPreferences.getInstance();
  var companyId, pin;
  TextEditingController companyIdController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();

  @override
  void initState() {
    prefs.then((value) {
      companyId = value.getString('companyId');
      pin = value.getString('pin');
      if (companyId != null) {
        companyIdController.text = companyId;
        pinController.text = pin;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final companyIdField = TextFormField(
      controller: companyIdController,
      keyboardType: TextInputType.text,
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'Company ID'),
    );

    final pinField = TextFormField(
      controller: pinController,
      keyboardType: TextInputType.number,
      autofocus: false,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[0-9]")),
        BlacklistingTextInputFormatter(RegExp("[abFeG]")),
      ],
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'PIN'),
    );

    Widget screenUI() {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            companyIdField,
            SizedBox(
              height: 20,
            ),
            pinField,
            SizedBox(
              height: 20,
            ),
            buttonWidget(
              btnText: 'Save',
              btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
              btnTextColor: AppColors.APP_BLACK_COLOR,
              btnTextSize: 18,
              onPressed: () {
                if(companyIdController.text.isNotEmpty && pinController.text.isNotEmpty){
                  prefs.then((value) {
                    value.setString('companyId', companyIdController.text.toUpperCase());
                    value.setString('pin', pinController.text);
                    FocusScope.of(context).requestFocus(new FocusNode());
                    ToastUtil.showToast(context, 'Saved');
                    if(widget.route != null){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.route));
                    }
                    else{
                      Navigator.pop(context);
                    }
                  });
                }
                else{
                  ToastUtil.showToast(context, 'Fill Required Fields');
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.APP_ORANGE_COLOR,
        elevation: 0,
        titleSpacing: 10,
        title: Text(
          'DispatchLabor: USER',
          style: TextStyle(color: AppColors.APP_WHITE_COLOR),
        ),
        iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
      ),
      body: screenUI(),
    );
  }
}
