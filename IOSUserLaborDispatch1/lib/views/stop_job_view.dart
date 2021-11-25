import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_strings.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/controller/cloud_storage_service.dart';
import 'package:ios_user_labor_dispatch_1/controller/jobLog_api.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/no_record_found.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/send_notification_api.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/model/notification.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/toast.dart';
import 'package:ios_user_labor_dispatch_1/views/add_address_view.dart';
import 'package:ios_user_labor_dispatch_1/views/jobs_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopJobView extends StatefulWidget {
  _StopJobViewState createState() => new _StopJobViewState();
}

class _StopJobViewState extends State<StopJobView> {
  final prefs = SharedPreferences.getInstance();

  var companyId, pin;
  bool isLoading = true;
  bool visibleButton = true;
  bool visibleImageButton = true;
  bool showIndicator = true;
  final picker = ImagePicker();
  Job job = new Job();

  // JobLog jobLog = new JobLog();
  List<Job> jobs = new List();
  JobApi api = new JobApi();

  // File image = null;
  JobLogApi jobLogApi = new JobLogApi();
  var currentLocation;
  var lat = 0.0, long = 0.0;
  var jobLogCount = 0;
  var imageUrl = '';

  SendNotificationApi notificationApi = new SendNotificationApi();
  TextEditingController priceQuoteController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();

  @override
  void initState() {
    getLocation();
    prefs.then((value) {
      companyId = value.getString('companyId');
      pin = value.getString('pin');
      getJobs();
    });

    super.initState();
  }

  getJobs() {
    api.getStartedJobs(companyId, pin).then((value) {
      jobs = value;
      if (jobs.length > 0) {
        job = jobs[0];
        // getJobLog();
        priceQuoteController.text = job.priceQuote;
        quantityController.text = job.quantity;
      }
      else{
        job = new Job();
      }
      isLoading = false;
      setState(() {});
    });

    jobLogApi.getJobLogsCount(companyId, pin).then((value) {
      jobLogCount = value;
      // print(jobLogCount);
      setState(() {});
    });
  }

  // getJobLog(){
  //   jobLogApi.getJobLog(job.jobNumber).then((value) {
  //     jobLog = value;
  //     setState(() { });
  //   });
  // }

  String getAddress(Job job) {
    if (job.adress != null) {
      List<String> data = [];
      job.adress.toJsonWithoutCoordinates().entries.forEach((e) => data.add(e.value.toString()));
      return data.join(', ');
    }
    return 'Address';
  }

  getLocation() async {
    var location = new Location();
    try {
      location.getLocation().then((value) async {
        // print("location Latitude: ${value.latitude}");
        // print("location Longitude: ${value.longitude}");
        lat = value.latitude;
        long = value.longitude;
        showIndicator = false;
        setState(() {});
      });
    } on Exception {
      currentLocation = null;
    }
  }

  void launchUrl(url) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final jobsDropdown = Container(
        padding: EdgeInsets.only(left: 5, right: screenSize.width * 0.3),
        child: DropdownButtonHideUnderline(
            child: new DropdownButton<Job>(
          // isExpanded: true,
          icon: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.arrow_drop_down_sharp,
              color: Colors.grey.shade500,
            ),
          ),
          value: job,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.APP_LIGHT_GREEN_COLOR,
          ),
          items: jobs.map((value) {
            return new DropdownMenuItem(
              value: value,
              child: new Text(value.jobNumber),
            );
          }).toList(),
          onChanged: (value) async {
            setState(() {
              job = value;
              // getJobLog();
            });
          },
        )));

    final priceQuoteField = TextFormField(
      controller: priceQuoteController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[0-9]")),
        BlacklistingTextInputFormatter(RegExp("[abFeG]")),
      ],
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'Price Quote'),
    );

    final quantityField = TextFormField(
      controller: quantityController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[0-9]")),
        BlacklistingTextInputFormatter(RegExp("[abFeG]")),
      ],
      autofocus: false,
      validator: requiredValidation,
      style: TextStyle(color: AppColors.APP_BLACK_COLOR, fontSize: 14),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'Quantity'),
    );

    Widget screenUI() {
      return Container(
        padding: EdgeInsets.all(20),
        child: isLoading
            ? Loader()
            : ListView(
                children: [
                  showIndicator
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              backgroundColor:
                                  AppColors.APP_PINK_COLOR.withOpacity(0.2),
                              color: AppColors.APP_PINK_COLOR,
                              semanticsLabel: 'Linear progress indicator',
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Updating Location...',
                              style: TextStyle(
                                color: AppColors.APP_BLACK_COLOR,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                      : Container(),
                  Text(
                    'Click below to select a different Job:',
                    style: TextStyle(
                      color: AppColors.APP_LIGHT_GREEN_COLOR,
                    ),
                  ),
                  SizedBox(height: 10),
                  jobsDropdown,
                  SizedBox(height: 10),
                  Text('${job.jobDesc ?? 'Job Description'}'),
                  SizedBox(height: 10),
                  Text('${job.jobPin ?? 'Job Pin'}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.companyId ?? 'Company Id'}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.jobFlag ?? 'Job Flag'}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.jobDate ?? 'Job Date'}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.startTime ?? 'Start Time'}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.stopTime ?? 'Stop Time'}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: screenSize.width * 0.4,
                          child: priceQuoteField),
                      Container(
                          width: screenSize.width * 0.4, child: quantityField),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    getAddress(job),
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  visibleImageButton
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buttonWidget(
                                btnText: 'Select Image File'.toUpperCase(),
                                btnColor: AppColors.APP_ORANGE_COLOR,
                                btnTextSize: 10,
                                btnTextColor: AppColors.APP_WHITE_COLOR,
                                onPressed: () async {
                                  // if (jobs.length > 0) {
                                    await selectCamera();
                                  // }
                                }),
                            buttonWidget(
                              btnText: 'Display Image'.toUpperCase(),
                              btnColor: AppColors.APP_ORANGE_COLOR,
                              btnTextSize: 10,
                              btnTextColor: AppColors.APP_WHITE_COLOR,
                              onPressed: () {
                                if (imageUrl.isNotEmpty && jobs.length > 0) {
                                  showImage(screenSize, imageUrl);
                                }
                              },
                            ),
                          ],
                        )
                      : Loader(),
                  imageUrl.isNotEmpty
                      ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('${job.jobNumber}_image',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ) : SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  visibleButton
                      ? buttonWidget(
                          btnText: 'Stop Job',
                          btnTextSize: 16,
                          btnColor: AppColors.APP_RED_COLOR,
                          btnTextColor: AppColors.APP_WHITE_COLOR,
                          onPressed: () {
                            if (jobs.length > 0) {
                              stopJob();
                            }
                          },
                        )
                      : Loader(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
      );
    }

    return Scaffold(
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

  Future selectCamera() async {
    var permissionStatus =
        await getPermission(context, AppConstants.cameraPermissionValue);
    if (permissionStatus) {
      var image =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
      setState(() {
        if (image != null) {
          var selectedImage = File(image.path);
          setState(() {
            visibleImageButton = false;
          });
          CloudStorageService _cloudService = new CloudStorageService();
          _cloudService
              .uploadFile(file: selectedImage, title: '${job.jobNumber}_image')
              .then((url) {
            ToastUtil.showToast(context, 'Image Uploaded Successfully');
            imageUrl = url;
            setState(() {
              visibleImageButton = true;
            });
          });
        }
      });
    }
  }

  stopJob() {
    if (lat == 0.0 || long == 0.0) {
      ToastUtil.showToast(context,
          'Please On Current Location & Refresh again to stop the job');
    } else {
      setState(() {
        visibleButton = false;
      });

      var date = new DateTime.now().toString();
      String result = date.substring(0, date.indexOf('.'));

      job.jobFlag = "STOPPED";
      job.priceQuote = priceQuoteController.text;
      job.quantity = quantityController.text;
      job.stopTime = result;

      JobLog jobLog = new JobLog(
          uid: (jobLogCount + 1).toString(),
          jobNumber: job.jobNumber,
          jobDesc: job.jobDesc,
          jobPin: job.jobPin,
          jobRate: job.jobRate,
          priceQuote: job.priceQuote,
          quantity: job.quantity,
          companyId: companyId,
          jobFlag: job.jobFlag,
          jobHours: '0',
          pdfFileName: job.pdfFileName,
          pdfUrl: job.pdfUrl,
          imageFileName: '',
          imageUrl: '',
          startLatitude: lat.toString(),
          startLongitude: long.toString(),
          startTime: result,
          startingTeg: '0',
          stopingTeg: '0');

      if (imageUrl.isNotEmpty) {
        jobLog.imageFileName = '${job.jobNumber}_image';
        jobLog.imageUrl = imageUrl;
      }

      api.updateJob(job).then((val) {
        jobLogApi.saveJobLog(jobLog).then((value) {
          if (value is bool && value) {
            getJobs();
            setState(() {
              isLoading = true;
              visibleButton = true;
            });
            sendNotification(job);
            ToastUtil.showToast(context, 'Job Stopped');
          } else if (value is bool && !value) {
            ToastUtil.showToast(context, 'Error');
          } else if (value is String) {
            ToastUtil.showToast(context, 'Error : $value');
          }
        });
      });
    }
  }

  showImage(screenSize, image) async {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Container(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.6,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover)),
              ),
            ));
  }

  sendNotification(Job job) {
    notificationApi.sendNotification(new NotificationModel(
        title: "Job Stopped",
        body: "Job Number: " + job.jobNumber + " | User Pin: " + job.jobPin,
        companyId: job.companyId));
  }
}
