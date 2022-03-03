import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/controller/jobLog_api.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationView extends StatefulWidget {
  _LocationViewState createState() => new _LocationViewState();
}

class _LocationViewState extends State<LocationView> {

  final prefs = SharedPreferences.getInstance();
  var companyId, pin;
  bool isLoading = true;
  List<Job> jobs = new List();
  Job job = new Job();
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
                  Text('${job.jobHours ?? 'Job Hours'}'),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Start GPS', style: TextStyle(color: AppColors.APP_GREY_COLOR, fontWeight: FontWeight.bold),),
                Text('Stop GPS', style: TextStyle(color: AppColors.APP_GREY_COLOR, fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget(
                  btnText: 'Start GPS',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_GREEN_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if (jobs.length > 0) {

                    }
                  },
                ),
                buttonWidget(
                  btnText: 'Stop GPS',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_GREEN_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if (jobs.length > 0) {

                    }
                  },
                ),
              ],
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
        title: Text('DispatchLabor: USER', style: TextStyle(color: AppColors.APP_WHITE_COLOR),),
        iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
      ),
      body: screenUI(),
    );
  }

}