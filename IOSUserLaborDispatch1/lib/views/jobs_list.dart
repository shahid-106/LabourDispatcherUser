import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/controller/jobLog_api.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsList extends StatefulWidget {
  _JobsListState createState() => new _JobsListState();
}

class _JobsListState extends State<JobsList> {

  final prefs = SharedPreferences.getInstance();
  JobApi api = new JobApi();
  JobLogApi jobLogApi = new JobLogApi();
  List<Job> jobs = new List();
  List<JobLog> jobLogs = new List();
  bool isLoading = true;
  var companyId, pin;

  @override
  void initState() {
    prefs.then((value) {
      companyId = value.getString('companyId');
      pin = value.getString('pin');
      api.getAllJobsForReport(companyId, pin).then((value) {
        jobs = value;
        isLoading = false;
        setState(() { });
      });

      jobLogApi.getJobLogs(companyId, pin).then((value) {
        jobLogs = value;
        isLoading = false;
        setState(() { });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    showData(Job job) async {
      List<String> data  = [];
      var address = '';
      if(job.adress != null){
        job.adress.toJson().entries.forEach((e) => data.add(e.value.toString()));
        // data = data.sublist(2);
        address = data.join(', ');
      }
      var jobLog = jobLogs.firstWhere((element) => element.jobNumber == job.jobNumber, orElse: () => null);
      // print(jobLog);
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
      return ListView.builder(
          itemCount: jobs.length,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index){
            return Container(
              decoration: DecorationBoxes.decorationWithRadiusAllAndBorderColor(AppColors.APP_WHITE_COLOR, AppColors.APP_WHITE_COLOR, radius: 15),
              margin: EdgeInsets.all(10),
              child: ListTile(
                onTap: (){
                  showData(jobs[index]);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(jobs[index].jobNumber),
                    Text('Detail', style: TextStyle(color: AppColors.APP_BLUE_COLOR, fontSize: 14, fontWeight: FontWeight.bold),),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(jobs[index].jobDesc),
                    Text(jobs[index].jobDate),
                  ],
                ),
              ),
            );
          }
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