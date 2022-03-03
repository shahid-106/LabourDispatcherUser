import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/controller/jobLog_api.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/toast.dart';
import 'package:ios_user_labor_dispatch_1/views/pdf_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jobs_list.dart';

class Reports extends StatefulWidget {
  _ReportsState createState() => new _ReportsState();
}

class _ReportsState extends State<Reports> {

  final prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  bool visibleDocumentButton = true;
  var companyId, pin;
  List<Job> jobs = new List();
  List<JobLog> jobLogs = new List();
  Job job = new Job();
  JobApi api = new JobApi();
  JobLog jobLog = new JobLog();
  JobLogApi jobLogApi = new JobLogApi();
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
    super.initState();
  }

  getJobs() {
    api.getAllJobs(companyId, pin).then((value) {
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

    jobLogApi.getJobLogs(companyId).then((value) {
      jobLogs = value;
      isLoading = false;
      setState(() { });
    });
  }

  getJobLog() {
    jobLogApi.getJobLog(job.jobNumber).then((value) {
      jobLog = value;
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
        print(file.path);
        print(file.absolute.path);
        raf.writeFromSync(response.data);
        ToastUtil.showToast(context, 'File Saved at $savePath');
        await raf.close();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfView(path: file, isNetwork: false,)
            )
        );
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

    showData(Job job) async {
      List<String> data  = [];
      var address = '';
      if(job.adress != null){
        job.adress.toJson().entries.forEach((e) => data.add(e.value.toString()));
        // data = data.sublist(2);
        address = data.join(', ');
      }
      var jobLog = jobLogs.firstWhere((element) => element.jobNumber == job.jobNumber, orElse: () => null);
      print(jobLog);
      showDialog(
          context: context,
          builder: (_) => Dialog(
            child: Container(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.5,
              padding: EdgeInsets.all(15),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Job Number: '+job.jobNumber, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Description: '+job.jobDesc, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Date: '+job.jobDate, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Hours: '+job.jobHours, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Quantity: '+job.quantity, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Flag: '+job.jobFlag, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Rate: '+job.jobRate, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Price Quote: '+job.priceQuote, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Pin: '+job.jobPin, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Start Time: '+job.startTime, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Stop Time: '+job.stopTime, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Start Latitude: '+job.startLatitude, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Start Longitude: '+job.startLongitude, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('PDF Filename: '+job.pdfFileName, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  (jobLog == null || jobLog == '') ? Text('Image Filename: ', style: TextStyle(fontSize: 14),)
                      : Text('Image Filename: '+jobLog.imageFileName, style: TextStyle(fontSize: 14),),
                  SizedBox(height: 5,),
                  Text('Job Address: '+address, style: TextStyle(fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          )
      );
    }

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
                    'Click below to select a different Job:',
                    style: TextStyle(
                      color: AppColors.APP_LIGHT_GREEN_COLOR,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: screenSize.width / 2.2, child: Text('${job.priceQuote == null ? 'Price Quote' : 'Price Quote: '+job.priceQuote}')),
                      Container(child: Text('${job.quantity == null ? 'Quantity ' : ', Quantity: '+job.quantity}')),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: screenSize.width / 2.2, child: Text('${job.jobRate == null ? 'Rate' : 'Rate: '+job.jobRate}')),
                      Container(child: Text('${job.priceQuote == null ? 'Cost ' : ', Cost: '+job.priceQuote}')),
                    ],
                  ),
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
                  Text(
                    getAddress(job),
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget(
                  btnText: 'View All',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if (jobs.length > 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => JobsList()));
                    }
                  },
                ),
                buttonWidget(
                  btnText: 'View Job',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_GREEN_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if (jobs.length > 0) {
                      showData(job);
                    }
                  },
                ),
              ],
            )
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

}