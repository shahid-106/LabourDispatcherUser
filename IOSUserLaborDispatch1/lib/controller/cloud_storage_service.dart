import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CloudStorageService {

  Future<String> uploadFile({
    @required File file,
    @required String title,
  }) async {
    try {
      if(file != null){
        var fileName = title + DateTime.now().millisecondsSinceEpoch.toString();

        final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);

        UploadTask uploadTask = firebaseStorageRef.putFile(file);

        return await uploadTask.then((storageSnapshot) async {
          var downloadUrl = await storageSnapshot.ref.getDownloadURL();
          return downloadUrl.toString();
        });
      }
      else{
        return "";
      }

    } catch (e) {
      return e.message;
    }
  }

  Future deleteFile(String fileName) async {
    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
