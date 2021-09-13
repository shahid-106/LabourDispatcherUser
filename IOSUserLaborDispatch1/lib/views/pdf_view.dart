import 'package:flutter/material.dart';
import 'package:ios_user_labor_dispatch_1/configs/app_colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  var url;
  PdfView({this.url});

  _PdfViewState createState() => new _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
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
        body: Container(
            child: SfPdfViewer.network(widget.url)
        )
    );
  }
}
