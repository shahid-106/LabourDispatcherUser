import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/controller/jobLog_api.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/pdf_api.dart';
import '../shared_widgets/toast.dart';

class Export extends StatefulWidget {
  _ExportState createState() => new _ExportState();
}

class _ExportState extends State<Export> {

  final prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  bool visibleDocumentButton = true;
  var companyId, pin;
  List<Job> jobs = new List();
  Job job = new Job();
  PdfApi pdfApi = new PdfApi();
  JobApi api = new JobApi();
  JobLog jobLog = new JobLog();
  JobLogApi jobLogApi = new JobLogApi();
  String _selectedStartDate = '';
  String _selectedEndDate = '';
  var jobLogCount = 0;

  @override
  void initState() {
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
    _selectedStartDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(DateTime.now().toString()))
        .toString();
    _selectedEndDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(DateTime.now().toString()))
        .toString();
    super.initState();
  }

  getJobs() {
    api.getAllJobsForReport(companyId, pin).then((value) {
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

  getJobLog() {
    jobLogApi.getJobLog(job.jobNumber).then((value) {
      jobLog = value;
      setState(() {});
    });
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
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: DecorationBoxes.decorationWithRadiusAll(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Click below to select a different Job Number:',
                    style: TextStyle(
                        color: AppColors.APP_LIGHT_GREEN_COLOR,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10),
                  jobsDropdown,
                  SizedBox(height: 10),
                  Text('${job.jobDate ?? 'Job Date'}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.jobDesc ?? 'Job Description'}'),
                  SizedBox(height: 10),
                  Text('${job.jobPin ?? 'Pin'}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${job.companyId ?? 'Company Id'}'),
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
                  Text('${job.jobHours == "null" || job.jobHours.isEmpty ? 'Job Hours' : job.jobHours}'),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_selectedStartDate, style: TextStyle(color: AppColors.APP_PRIMARY_COLOR, fontWeight: FontWeight.bold),),
                Text(_selectedEndDate, style: TextStyle(color: AppColors.APP_PRIMARY_COLOR, fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget(
                  btnText: 'Start Date',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_PRIMARY_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () async {
                    // if (jobs.length > 0) {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());
                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 1095)),
                        lastDate: DateTime.now().add(Duration(days: 700)),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: AppColors.APP_PRIMARY_COLOR,
                              accentColor: AppColors.APP_PRIMARY_COLOR,
                              colorScheme: ColorScheme.light(
                                primary: AppColors.APP_PRIMARY_COLOR,
                              ),
                              buttonTheme:
                              ButtonThemeData(textTheme: ButtonTextTheme.primary),
                            ),
                            child: child,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _selectedStartDate = DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(date.toIso8601String()))
                              .toString();
                        });
                      }
                    // }
                  },
                ),
                buttonWidget(
                  btnText: 'End Date',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_PRIMARY_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () async {
                    // if (jobs.length > 0) {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());
                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 1095)),
                        lastDate: DateTime.now().add(Duration(days: 700)),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: AppColors.APP_PRIMARY_COLOR,
                              accentColor: AppColors.APP_PRIMARY_COLOR,
                              colorScheme: ColorScheme.light(
                                primary: AppColors.APP_PRIMARY_COLOR,
                              ),
                              buttonTheme:
                              ButtonThemeData(textTheme: ButtonTextTheme.primary),
                            ),
                            child: child,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _selectedEndDate = DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(date.toIso8601String()))
                              .toString();
                        });
                      }
                    // }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget(
                  btnText: 'Export All',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if (jobs.length > 0) {
                      exportJobs(jobs);
                    }
                  },
                ),
                buttonWidget(
                  btnText: 'Export Job',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if (jobs.length > 0) {
                      exportJob(job.toJson().toString(), job.jobNumber);
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            buttonWidget(
              btnText: 'Email Export File',
              btnTextSize: 16,
              btnColor: AppColors.APP_GREEN_COLOR,
              btnTextColor: AppColors.APP_WHITE_COLOR,
              height: 40,
              width: 200,
              onPressed: () {
                if (jobs.length > 0) {

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
        title: Text('DispatchLabor: USER', style: TextStyle(color: AppColors.APP_WHITE_COLOR),),
        iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
      ),
      body: isLoading ? Loader() : screenUI(),
    );
  }

  exportJob(String str, String jobNumber) async {
    Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
    if(statuses[Permission.storage].isGranted){
      final pdfFile = await PdfApi.generateCenteredText([str], jobNumber);
      ToastUtil.showToast(context, 'Job Exported\nFile Saved at ${pdfFile.path}');
    }
  }

  exportJobs(List<Job> jobs) async {
    Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
    List<String> jsons = <String>[];
    for(var i=0;i<jobs.length;i++){
      jsons.add(jobs[i].toJson().toString());
    }
    if(statuses[Permission.storage].isGranted){
      final pdfFile = await PdfApi.generateCenteredText(jsons, 'AllJobs', pages: jobs.length);
      ToastUtil.showToast(context, 'All Jobs Exported\nFile Saved at ${pdfFile.path}');
    }
  }

}