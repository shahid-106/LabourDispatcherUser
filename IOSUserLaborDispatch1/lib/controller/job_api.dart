import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';

class JobApi {
  final dbRef = FirebaseDatabase.instance.reference().child('JOBS');

  Future<List<Job>> getAllJobs(String companyId, String pin) async {

    List<Job> userJobs = [];
    await dbRef
        .orderByChild('jobDate').once()
        .then((result) async {
      if (result.value != null) {
        result.value.forEach((key, childSnapshot) {
          userJobs.add(Job.fromJson(Map.from(childSnapshot)));
        });
        userJobs = userJobs.where((element) => element.companyId == companyId.toUpperCase()).toList();
        userJobs = userJobs.where((element) => element.jobPin == pin).toList();
        var twoMonthAgoDate = DateTime.now().subtract(Duration(days: 61));
        //Job Date” <= Current Date() - 61 Days.
        userJobs.removeWhere((element) => DateTime.parse(element.jobDate).isBefore(twoMonthAgoDate));
        userJobs = userJobs.reversed.toList();
      } else {
        print('getAllJobs() no jobs found');
      }
    }).catchError((e) {
      print('getAllJobs() error: $e');
    });
    return userJobs;
  }

  Future<List<Job>> getNotStartedJobs(String companyId, String pin) async {

    List<Job> userJobs = [];
    await dbRef
        .orderByChild('companyId').equalTo(companyId).once()
        .then((result) async {
      if (result.value != null) {
        result.value.forEach((key, childSnapshot) {
          userJobs.add(Job.fromJson(Map.from(childSnapshot)));
        });
        // print(userJobs.length);
        userJobs = userJobs.where((element) => element.jobPin == pin).toList();
        userJobs = userJobs.where((element) => element.jobFlag != 'STARTED').toList();
        //Job Date <= 30 Days
        var monthAgoDate = DateTime.now().subtract(Duration(days: 31));
        userJobs.removeWhere((element) => DateTime.parse(element.jobDate).isBefore(monthAgoDate));
        userJobs = userJobs.reversed.toList();
        // print(userJobs.length);
      } else {
        print('getNotStartedJobs() no jobs found');
      }
    }).catchError((e) {
      print('getNotStartedJobs() error: $e');
    });
    return userJobs;
  }

  Future<List<Job>> getStartedJobs(String companyId, String pin) async {

    List<Job> userJobs = [];
    await dbRef
        .orderByChild('companyId')
        .equalTo(companyId)
        .once()
        .then((result) async {
      if (result.value != null) {
        result.value.forEach((key, childSnapshot) {
          userJobs.add(Job.fromJson(Map.from(childSnapshot)));
        });
        userJobs = userJobs.where((element) => element.jobPin == pin).toList();
        userJobs = userJobs.where((element) => element.jobFlag == 'STARTED').toList();
        userJobs = userJobs.reversed.toList();
      } else {
        print('getStartedJobs() no jobs found');
      }
    }).catchError((e) {
      print('getStartedJobs() error: $e');
    });
    return userJobs;
  }

  Future<dynamic> saveJob(Job job) {
    return dbRef.child(job.jobNumber).get().then((value){
      if(value.value != null){
        return 'Key already exist';
      }
      else{
        return dbRef.child(job.jobNumber).set(job.toJson()).then((value){
          return true;
        }).catchError((error){
          return false;
        });
      }
    });

  }

  Future<bool> updateJob(Job job) {
    return dbRef.child(job.jobNumber).update(job.toJson()).then((value){
      return true;
    }).catchError((error){
      return false;
    });
  }

  Future<dynamic> getLocation(String address) async {
    String apiKey = '4341cc85aa46d4d614dd863368a0b0e6';
    var response = await http.get(Uri.parse('http://api.positionstack.com/v1/forward?access_key=$apiKey&query=$address'));
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print(json);
      // print(json['data'][0]);
      return json['data'][0];
    } else {
      return null;
    }

  }
}
