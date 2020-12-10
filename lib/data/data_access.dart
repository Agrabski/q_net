import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<List<T>> loadPointers<T>(T constructor(String name, String path)) async {
  final filesDirectory = Directory('${getDirectoryFor<T>()}');
  return filesDirectory
      .list(recursive: false)
      .map((file) => constructor(file.path, basename(file.path)))
      .toList();
}

Future<String> getDirectoryFor<T>() {
  return getApplicationDocumentsDirectory().then((value) => '$value$T');
}

Future<String> getPathToFile<T>(String name) {
  return getDirectoryFor<T>().then((value) => '$value/$name.json');
}

Future saveFile<T>(String path, T file) async {
  var file = File(path);
  if (!file.existsSync()) file.create(recursive: true);
  file.writeAsString(json.encode(file));
}

Future deleteFile(String path) {
  return File(path).delete();
}
