import 'dart:io';

Future<String> getLocaleTranslationFileContent(String filename) async {
  var folder = "files";
  // Read the file in the files folder
  var file = File('$folder/$filename');
  var content = await file.readAsString();
  return content;
}
