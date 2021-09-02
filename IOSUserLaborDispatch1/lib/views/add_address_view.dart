import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
import 'package:location/location.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/controller/cloud_storage_service.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/toast.dart';
import 'package:ios_user_labor_dispatch_1/views/jobs_list.dart';
import 'package:ios_user_labor_dispatch_1/views/map_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  _AddAddressState createState() => new _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController streetNoController = new TextEditingController();
  TextEditingController streetNameController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController telNoController = new TextEditingController();
  JobApi api = new JobApi();
  bool visibleButton = true;
  var currentLocation;
  var lat = 0.0, long = 0.0;
  Map<String, dynamic> address = {};

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    var location = new Location();
    try {
      location.getLocation().then((value) async {
        print("location Latitude: ${value.latitude}");
        print("location Longitude: ${value.longitude}");
        lat = value.latitude;
        long = value.longitude;
        final coordinates = new Coordinates(lat, long);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        print('${first.toMap().toString()}');
        streetNoController.text = first.featureName;
        streetNameController.text = first.addressLine;
        cityController.text = first.adminArea;
        stateController.text = first.adminArea;
        zipController.text = first.postalCode;
        setState(() { });
      });
    } on Exception {
      currentLocation = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final streetNoField = TextFormField(
      controller: streetNoController,
      keyboardType: TextInputType.text,
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'Street #'),
    );

    final streetNameField = TextFormField(
      controller: streetNameController,
      keyboardType: TextInputType.text,
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'Street Name'),
    );

    final cityField = TextFormField(
      controller: cityController,
      keyboardType: TextInputType.text,
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'City'),
    );

    final stateField = TextFormField(
      controller: stateController,
      keyboardType: TextInputType.text,
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration:
          DecorationInputs.textBoxInputDecoration(label: 'Province/State'),
    );

    final zipField = TextFormField(
      controller: zipController,
      keyboardType: TextInputType.text,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[0-9]")),
        BlacklistingTextInputFormatter(RegExp("[abFeG]")),
      ],
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration:
          DecorationInputs.textBoxInputDecoration(label: 'Zip/Postal Code'),
    );

    final telField = TextFormField(
      controller: telNoController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[0-9]")),
        BlacklistingTextInputFormatter(RegExp("[abFeG]")),
      ],
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'Tel #'),
    );

    Widget screenUI() {
      return Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: screenSize.width * 0.3, child: streetNoField),
                  Container(
                      width: screenSize.width * 0.6, child: streetNameField),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: screenSize.width * 0.44, child: cityField),
                  Container(width: screenSize.width * 0.44, child: stateField),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: screenSize.width * 0.44, child: zipField),
                  Container(width: screenSize.width * 0.44, child: telField),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              visibleButton ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttonWidget(
                    btnText: 'Search'.toUpperCase(),
                    height: 40,
                    width: screenSize.width * 0.44,
                    btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
                    btnTextColor: AppColors.APP_BLACK_COLOR,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          visibleButton = false;
                        });
                        FocusScope.of(context).requestFocus(new FocusNode());
                        var addressString = "${streetNoController.text}, " +
                            "${streetNameController.text}, " +
                            "${cityController.text}, " +
                            "${stateController.text}, " +
                            "${zipController.text} ";
                        api.getLocation(addressString).then((value){
                          setState(() {
                            visibleButton = true;
                          });
                          if(value != null){
                            lat = value['latitude'];
                            long = value['longitude'];
                            address['latitude'] = lat;
                            address['longitude'] = long;
                          }
                        });
                      }
                    },
                  ),
                  buttonWidget(
                    height: 40,
                    width: screenSize.width * 0.44,
                    btnText: 'Save'.toUpperCase(),
                    btnColor: AppColors.APP_GREEN_COLOR,
                    btnTextColor: AppColors.APP_WHITE_COLOR,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        // var address = "${streetNoController.text}, " +
                        //     "${streetNameController.text}, " +
                        //     "${cityController.text}, " +
                        //     "${stateController.text}, " +
                        //     "${zipController.text}, " + "${telNoController.text}";
                        address['streetNo'] = streetNoController.text;
                        address['streetName'] = streetNameController.text;
                        address['city'] = cityController.text;
                        address['state'] = stateController.text;
                        address['zipCode'] = zipController.text;
                        address['tellePhone'] = telNoController.text;
                        Navigator.pop(context, address);
                      }
                    },
                  ),
                ],
              ) : Loader(),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: MapView(lat: lat, long: long,)
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.APP_PRIMARY_COLOR,
        elevation: 0,
        titleSpacing: 10,
        title: Text(
          'DispatchLabor: USER',
          style: TextStyle(color: AppColors.APP_WHITE_COLOR),
        ),
        iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: screenUI()),
    );
  }
}
