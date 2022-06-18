import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateCenteredText(List<String> text, String JobNo, {int pages = 1}) async {
    // making a pdf document to store a text and it is provided by pdf package
    final pdf = Document();

    // Text is added here in center
    if(pages == 1){
      pdf.addPage(Page(
        build: (context) => Center(
          child: Text(text[0], style: TextStyle(fontSize: 48)),
        ),
      ));
    }
    else {
      for(var i=0;i<pages;i++){
        pdf.addPage(Page(
          build: (context) => Center(
            child: Text(text[i], style: TextStyle(fontSize: 48)),
          ),
        ));
      }
    }

    // passing the pdf and name of the document to make a directory in  the internal storage
    return saveDocument(name: '${JobNo}_${DateTime.now().microsecondsSinceEpoch}.pdf', pdf: pdf);
  }

  // it will make a named directory in the internal storage and then return to its call
  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    // pdf save to the variable called bytes
    final bytes = await pdf.save();

    // here a beautiful package  path provider helps us and take directory and name of the file  and made a proper file in internal storage
    final dir = await getExternalStorageDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    // returning the file to the top most method which is generate centered text.
    return file;
  }
}