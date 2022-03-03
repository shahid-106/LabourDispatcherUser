import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
import 'package:ios_user_labor_dispatch_1/controller/jobLog_api.dart';
import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
import 'package:ios_user_labor_dispatch_1/model/job.dart';
import 'package:ios_user_labor_dispatch_1/model/jobLog.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
import 'package:ios_user_labor_dispatch_1/shared_widgets/showDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jobs_list.dart';

class Edit extends StatefulWidget {
  _EditState createState() => new _EditState();
}

class _EditState extends State<Edit> {
  final prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  bool visibleDocumentButton = true;
  var companyId, pin;
  List<Job> jobs = new List();

  // List<JobLog> jobLogs = new List();
  Job job = new Job();
  JobApi api = new JobApi();

  // JobLog jobLog = new JobLog();
  // JobLogApi jobLogApi = new JobLogApi();
  // var jobLogCount = 0;

  TextEditingController descriptionController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController companyIdController = new TextEditingController();
  TextEditingController jobHoursController = new TextEditingController();
  TextEditingController jobRateController = new TextEditingController();
  TextEditingController priceQuoteController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();

  @override
  void initState() {
    prefs.then((value) {
      companyId = value.getString('companyId');
      pin = value.getString('pin');
      getJobs();
    });
    super.initState();
  }

  getJobs() {
    api.getAllJobs(companyId, pin).then((value) {
      jobs = value;
      if (jobs.length > 0) {
        job = jobs[0];
        companyIdController.text = job.companyId ?? '';
        pinController.text = job.jobPin ?? '';
        priceQuoteController.text = job.priceQuote ?? '';
        descriptionController.text = job.jobDesc ?? '';
        jobRateController.text = job.jobRate ?? '';
        quantityController.text = job.quantity ?? '';
        jobHoursController.text = job.jobHours ?? '';
      } else {
        job = new Job();
      }
      isLoading = false;
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
              companyIdController.text = job.companyId ?? '';
              pinController.text = job.jobPin ?? '';
              priceQuoteController.text = job.priceQuote ?? '';
              descriptionController.text = job.jobDesc ?? '';
              jobRateController.text = job.jobRate ?? '';
              quantityController.text = job.quantity ?? '';
              jobHoursController.text = job.jobHours ?? '';
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
                    'Click below to select a different Job:',
                    style: TextStyle(
                      color: AppColors.APP_LIGHT_GREEN_COLOR,
                    ),
                  ),
                  SizedBox(height: 10),
                  jobsDropdown,
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    validator: requiredValidation,
                    style: TextStyle(
                        color: AppColors.APP_BLACK_COLOR, fontSize: 14),
                    decoration: DecorationInputs.textBoxInputDecoration(
                        label: 'Job Description'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: pinController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    enabled: false,
                    validator: requiredValidation,
                    style: TextStyle(
                        color: AppColors.APP_BLACK_COLOR, fontSize: 14),
                    decoration: DecorationInputs.textBoxInputDecoration(
                        label: 'PIN'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: companyIdController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    enabled: false,
                    validator: requiredValidation,
                    style: TextStyle(
                        color: AppColors.APP_BLACK_COLOR, fontSize: 14),
                    decoration: DecorationInputs.textBoxInputDecoration(
                        label: 'Company Id'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: jobHoursController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: requiredValidation,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      FilteringTextInputFormatter.deny(RegExp("[abFeG]"))
                    ],
                    style: TextStyle(
                        color: AppColors.APP_BLACK_COLOR, fontSize: 14),
                    decoration: DecorationInputs.textBoxInputDecoration(
                        label: 'Job Hours'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: jobRateController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: requiredValidation,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      FilteringTextInputFormatter.deny(RegExp("[abFeG]"))
                    ],
                    style: TextStyle(
                        color: AppColors.APP_BLACK_COLOR, fontSize: 14),
                    decoration: DecorationInputs.textBoxInputDecoration(
                        label: 'Job Rate'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: priceQuoteController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: requiredValidation,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      FilteringTextInputFormatter.deny(RegExp("[abFeG]"))
                    ],
                    style: TextStyle(
                        color: AppColors.APP_BLACK_COLOR, fontSize: 14),
                    decoration: DecorationInputs.textBoxInputDecoration(
                        label: 'Price Quote'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: requiredValidation,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      FilteringTextInputFormatter.deny(RegExp("[abFeG]"))
                    ],
                    style: TextStyle(
                        color: AppColors.APP_BLACK_COLOR, fontSize: 14),
                    decoration: DecorationInputs.textBoxInputDecoration(
                        label: 'Quantity'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            buttonWidget(
              btnText: 'Save',
              btnTextSize: 16,
              btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
              btnTextColor: AppColors.APP_BLACK_COLOR,
              height: 40,
              onPressed: () {
                if (job.companyId != null) {
                  showAlertWithTwoButtons(context, 'Are you sure you want to update this Job?', onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });
                    job.priceQuote = priceQuoteController.text;
                    job.jobDesc = descriptionController.text;
                    job.jobRate = jobRateController.text;
                    job.quantity = quantityController.text;
                    job.jobHours = jobHoursController.text;
                    api.updateJob(job).then((value){
                      if(value){
                        getJobs();
                      }
                    });
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget(
                  btnText: 'Clear',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_ORANGE_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if (jobs.length > 0) {}
                  },
                ),
                buttonWidget(
                  btnText: 'Delete',
                  btnTextSize: 16,
                  btnColor: AppColors.APP_LIGHT_GREEN_COLOR,
                  btnTextColor: AppColors.APP_WHITE_COLOR,
                  height: 40,
                  onPressed: () {
                    if(job.companyId != null){
                      showAlertWithTwoButtons(context, 'Are you sure you want to delete this Job?', onPressed: (){
                        Navigator.pop(context);
                        setState(() {
                          isLoading = true;
                        });
                        api.deleteJob(job).then((value){
                          if(value){
                            getJobs();
                          }
                        });
                      });
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
        title: Text(
          'DispatchLabor: USER',
          style: TextStyle(color: AppColors.APP_WHITE_COLOR),
        ),
        iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
      ),
      body: isLoading ? Loader() : GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: screenUI()
      ),
    );
  }
}
