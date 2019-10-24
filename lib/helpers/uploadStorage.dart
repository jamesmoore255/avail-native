import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Upload file to firebase storage
///
/// [file] File to be uploaded.
/// [path] The path of the desired storage location.
/// [name] The name of the file.
/// [contentType] The mime content type of the file.
/// [metadata] The associated metadata for the file to be uploaded.
Future<String> upload(File file, String path, String name, String contentType,
    Map metadata) async {
  final StorageReference ref =
      FirebaseStorage.instance.ref().child(path).child(name);
  final StorageUploadTask uploadTask = ref.putFile(
    file,
    StorageMetadata(
      contentType: contentType,
      customMetadata: metadata,
    ),
  );
  StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}
