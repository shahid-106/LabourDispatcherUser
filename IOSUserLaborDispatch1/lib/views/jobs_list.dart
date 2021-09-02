// import 'package:flutter/material.dart';
// import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
// import 'package:ios_user_labor_dispatch_1/configs/general_methods.dart';
// import 'package:ios_user_labor_dispatch_1/controller/job_api.dart';
// import 'package:ios_user_labor_dispatch_1/model/job.dart';
// import 'package:ios_user_labor_dispatch_1/shared_widgets/buttons.dart';
// import 'package:ios_user_labor_dispatch_1/shared_widgets/decoration.dart';
// import 'package:ios_user_labor_dispatch_1/shared_widgets/loader.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class JobsList extends StatefulWidget {
//   _JobsListState createState() => new _JobsListState();
// }
//
// class _JobsListState extends State<JobsList> {
//
//   final prefs = SharedPreferences.getInstance();
//   JobApi api = new JobApi();
//   List<Job> jobs = new List();
//   bool isLoading = true;
//   var companyId;
//
//   @override
//   void initState() {
//     prefs.then((value) {
//       companyId = value.getString('companyId');
//       api.getJobs(companyId).then((value) {
//         jobs = value;
//         isLoading = false;
//         setState(() { });
//       });
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     Widget screenUI() {
//       return ListView.builder(
//           itemCount: jobs.length,
//           padding: EdgeInsets.all(10),
//           itemBuilder: (context, index){
//             return Container(
//               decoration: DecorationBoxes.decorationWithRadiusAll(AppColors.APP_WHITE_COLOR, radius: 15),
//               margin: EdgeInsets.all(10),
//               child: ListTile(
//                 title: Text(jobs[index].jobNumber),
//                 subtitle: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(jobs[index].jobDesc),
//                     Text(jobs[index].jobDate),
//                   ],
//                 ),
//               ),
//             );
//           }
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.APP_ORANGE_COLOR,
//         elevation: 0,
//         titleSpacing: 10,
//         title: Text('DispatchLabor: USER', style: TextStyle(color: AppColors.APP_WHITE_COLOR),),
//         iconTheme: IconThemeData(color: AppColors.APP_WHITE_COLOR),
//       ),
//       body: isLoading ? Loader() : screenUI(),
//     );
//   }
//
// }