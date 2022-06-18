import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';

class JobLogApi {
  final dbRef = FirebaseDatabase.instance.reference().child('JOB_LOG');

  Future<List<JobLog>> getJobLogs(String companyId, String pin) async {
  print(pin);
    List<JobLog> userJobLogs = [];
    await dbRef
        .orderByChild('jobPin').equalTo(pin).once().then((result) async {
      if (result.value != null) {
        result.value.forEach((childSnapshot) {
          userJobLogs.add(JobLog.fromJson(Map.from(childSnapshot)));
        });
        userJobLogs = userJobLogs.where((element) => element.companyId == companyId.toUpperCase()).toList();
      } else {
        print('getJobLogs() no jobs found');
      }
    }).catchError((e) {
      print('getJobLogs() error: $e');
    });
    return userJobLogs;
  }

  Future<JobLog> getJobLog(String jobNumber) async {

    JobLog jobLog = new JobLog();
    await dbRef.orderByChild('jobNumber').equalTo(jobNumber)
        .once().then((result) async {
      if (result.value != null) {
        result.value.forEach((key, childSnapshot) {
          jobLog = JobLog.fromJson(Map.from(childSnapshot));
        });
        // print(jobLog.toJson().toString());
      } else {
        print('getJobLog() no jobs found');
      }
    }).catchError((e) {
      print('getJobLog() error: $e');
    });
    return jobLog;
  }

  Future<int> getJobLogsCount(String companyId, String pin) async {

    List<JobLog> userJobLogs = [];
    var count = 0;
    await dbRef.orderByChild('companyId').equalTo(companyId.toUpperCase()).once().then((result) async {
      if (result.value != null) {
        result.value.forEach((childSnapshot) {
          userJobLogs.add(JobLog.fromJson(Map.from(childSnapshot)));
        });
        userJobLogs = userJobLogs.where((element) => element.jobPin == pin).toList();
        // userJobLogs = userJobLogs.where((element) => element.companyId == companyId.toUpperCase()).toList();
        userJobLogs.sort((a, b) => int.parse(b.uid) - int.parse(a.uid));
        count = int.parse(userJobLogs[0].uid);
      } else {
        print('getJobLogsCount() no jobs found');
      }
    }).catchError((e) {
      print('getJobLogsCount() error: $e');
    });
    return count;
  }

  Future<dynamic> saveJobLog(JobLog job) {
    return dbRef.child(job.uid).get().then((value){
      if(value.value != null){
        return 'Key already exist';
      }
      else{
        return dbRef.child(job.uid).set(job.toJson()).then((value){
          return true;
        }).catchError((error){
          return false;
        });
      }
    });

  }

  Future<bool> updateJobLog(JobLog job) {
    return dbRef.child(job.uid).update(job.toJson()).then((value){
      return true;
    }).catchError((error){
      return false;
    });
  }
}
