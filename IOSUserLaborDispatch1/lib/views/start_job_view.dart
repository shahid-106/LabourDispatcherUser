import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_strings.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/controller/cloud_storage_service.dart';
import 'package:ios_user_labor_dispatch_1/controller/jobLog_api.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/no_record_found.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/showDialog.dart';
import 'package:ios_user_labor_dispatch_1/views/pdf_view.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
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

class StartJobView extends StatefulWidget {
  _StartJobViewState createState() => new _StartJobViewState();
}

class _StartJobViewState extends State<StartJobView> {
  final prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  var companyId, pin;
  bool visibleButton = true;
  bool visibleDocumentButton = true;
  bool showIndicator = true;
  Job job = new Job();
  List<Job> jobs = new List();
  JobApi api = new JobApi();
  JobLog jobLog = new JobLog();
  JobLogApi jobLogApi = new JobLogApi();
  var currentLocation;
  var lat = 0.0, long = 0.0;
  var jobLogCount = 0;

  SendNotificationApi notificationApi = new SendNotificationApi();

  @override
  void initState() {
    getLocation();
    prefs.then((value) {
      companyId = value.getString('companyId');
      pin = value.getString('pin');
      getJobs();
      jobLogApi.getJobLogsCount(companyId, pin).then((value) {
        jobLogCount = value;
        // print(jobLogCount);
        setState(() {});
      });
    });

    super.initState();
  }

  getJobs() {
    api.getNotStartedJobs(companyId, pin).then((value) {
      jobs = value;
      if (jobs.length > 0) {
        job = jobs[0];
        getJobLog();
      }
      else{
        job = new Job();
      }
      isLoading = false;
      setState(() {});
    });
  }

  String getAddress(Job job) {
    if (job.adress != null) {
      List<String> data = [];
      job.adress.toJsonWithoutCoordinates().entries.forEach((e) => data.add(e.value.toString()));
      print(data.toString());
      // data = data.sublist(2);
      return data.join(', ');
    }
    return 'Address';
  }

  getLocation() async {
    var location = new loc.Location();
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

  getJobLog() {
    jobLogApi.getJobLog(job.jobNumber).then((value) {
      jobLog = value;
      setState(() {});
    });
  }

  void launchUrl(url) async {
    await launch(url);
  }

  void customLaunch(command) async {
    command = "tel:" + command;
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      // print('could not launch $command');
      ToastUtil.showToast(context, 'Invalid Phone No');
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await launch(googleUrl);
  }

  Future downloadFile(String url, String savePath) async {
    try {
      setState(() {
        visibleDocumentButton = false;
      });
      var dio = Dio();
      var response = await dio.get(
        url,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
      if(statuses[Permission.storage].isGranted){
        File file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        setState(() {
          visibleDocumentButton = true;
        });
        raf.writeFromSync(response.data);
        ToastUtil.showToast(context, 'File Downloaded Successfully');
        await raf.close();
      }
    } catch (e) {
      print(e);
      ToastUtil.showToast(context, 'Error');
      setState(() {
        visibleDocumentButton = true;
      });

    }
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
            });
          },
        )));

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
                  Text('${job.startTime == null || job.startTime.isEmpty ? 'Last Start Time' : job.startTime}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.stopTime == null || job.stopTime.isEmpty ? 'Last Stop Time' : job.stopTime}'),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('${job.priceQuote == null ? 'Price Quote' : 'Price Quote: '+job.priceQuote}'),
                      Text('${job.quantity == null ? ', Quantity ' : ', Quantity: '+job.quantity}'),
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
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonWidget(
                        btnText: 'Display on Map'.toUpperCase(),
                        btnColor: AppColors.APP_ORANGE_COLOR,
                        btnTextSize: 9,
                        width: screenSize.width * 0.38,
                        btnTextColor: AppColors.APP_WHITE_COLOR,
                        onPressed: () {
                          if (jobs.length > 0) {
                            openMap(double.parse(job.adress.latitude),
                                double.parse(job.adress.longitude));
                          }
                        },
                      ),
                      buttonWidget(
                        btnText: 'Call Customer'.toUpperCase(),
                        btnColor: AppColors.APP_ORANGE_COLOR,
                        btnTextSize: 9,
                        width: screenSize.width * 0.38,
                        btnTextColor: AppColors.APP_WHITE_COLOR,
                        onPressed: () {
                          if (jobs.length > 0) {
                            customLaunch(job.adress.tellePhone);
                          }
                        },
                      ),
                    ],
                  ),
                  job.pdfFileName != null && job.pdfFileName.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              job.pdfFileName,
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  visibleDocumentButton
                      ? job.pdfUrl != null && job.pdfUrl.isNotEmpty ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buttonWidget(
                              btnText: 'Download Documents'.toUpperCase(),
                              btnColor: AppColors.APP_ORANGE_COLOR,
                              btnTextColor: AppColors.APP_WHITE_COLOR,
                              width: screenSize.width * 0.38,
                              btnTextSize: 9,
                              onPressed: () {
                                // print(job.pdfUrl);
                                if (jobs.length > 0 && job.pdfUrl.isNotEmpty) {
                                  showAlertWithTwoButtons(context, 'Are you sure you want to download this document?',
                                      onPressed: () async {
                                        Navigator.pop(context);
                                    String path = await ExtStorage
                                        .getExternalStoragePublicDirectory(
                                        ExtStorage.DIRECTORY_DOWNLOADS);
                                    String fullPath = "$path/${job.pdfFileName}";
                                    // print('full path $fullPath');
                                    downloadFile(job.pdfUrl, fullPath);
                                  });
                                } else {
                                  // print('not found');
                                }
                              },
                            ),
                            buttonWidget(
                              btnText: 'Open Document'.toUpperCase(),
                              btnTextSize: 9,
                              btnColor: AppColors.APP_ORANGE_COLOR,
                              btnTextColor: AppColors.APP_WHITE_COLOR,
                              width: screenSize.width * 0.38,
                              onPressed: () {
                                if (jobs.length > 0 && job.pdfUrl.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PdfView(
                                                url: job.pdfUrl,
                                              )
                                      )
                                  );
                                }
                              },
                            ),
                          ],
                        ) : Container()
                      : Loader(),
                  SizedBox(
                    height: 20,
                  ),
                  visibleButton
                      ? buttonWidget(
                          btnText: 'Start Job',
                          btnTextSize: 16,
                          btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
                          btnTextColor: AppColors.APP_WHITE_COLOR,
                          onPressed: () {
                            if (jobs.length > 0) {
                              startJob();
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

  startJob() {
    if (lat == 0.0 || long == 0.0) {
      ToastUtil.showToast(context,
          'Please On Current Location & Refresh again to start the job');
    } else {
      setState(() {
        visibleButton = false;
      });

      var date = new DateTime.now().toString();
      String result = date.substring(0, date.indexOf('.'));

      job.jobFlag = "STARTED";
      job.startLatitude = lat.toString();
      job.startLongitude = long.toString();
      job.startTime = result;

      if (jobLog.uid == null) {
        JobLog record = new JobLog(
            uid: (jobLogCount + 1).toString(),
            jobNumber: job.jobNumber,
            jobDesc: job.jobDesc,
            jobPin: job.jobPin,
            jobRate: job.jobRate,
            priceQuote: job.priceQuote,
            quantity: job.quantity,
            companyId: companyId,
            jobFlag: "STARTED",
            jobHours: '0',
            pdfFileName: job.pdfFileName,
            pdfUrl: job.pdfUrl,
            imageFileName: '',
            imageUrl: '',
            startLatitude: lat.toString(),
            startLongitude: long.toString(),
            startTime: new DateTime.now().toString(),
            startingTeg: '0',
            stopingTeg: '0');

        api.updateJob(job).then((val) {
          jobLogApi.saveJobLog(record).then((value) {
            if (value is bool && value) {
              getJobs();
              setState(() {
                isLoading = true;
                visibleButton = true;
              });
              sendNotification(job);
              ToastUtil.showToast(context, 'Job Started');
            } else if (value is bool && !value) {
              ToastUtil.showToast(context, 'Error');
            } else if (value is String) {
              ToastUtil.showToast(context, 'Error : $value');
            }
          });
        });
      } else {
        jobLog.jobFlag = "STARTED";
        jobLog.startLatitude = lat.toString();
        jobLog.startLongitude = long.toString();
        jobLog.startTime = result;

        api.updateJob(job).then((val) {
          jobLogApi.updateJobLog(jobLog).then((value) {
            if (value is bool && value) {
              getJobs();
              setState(() {
                isLoading = true;
                visibleButton = true;
              });
              sendNotification(job);
              ToastUtil.showToast(context, 'Job Started');
            } else if (value is bool && !value) {
              ToastUtil.showToast(context, 'Error');
            } else if (value is String) {
              ToastUtil.showToast(context, 'Error : $value');
            }
          });
        });
      }
    }
  }

  sendNotification(Job job) {
    notificationApi.sendNotification(new NotificationModel(
        title: "Job Started",
        body: "Job Number: " + job.jobNumber + " | User Pin: " + job.jobPin,
        companyId: job.companyId));
  }
}
