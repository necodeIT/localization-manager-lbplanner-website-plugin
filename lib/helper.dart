import 'dart:io';

Future<String> getLocaleTranslationFileContent(String filename) async {
  var folder = "files";
  // Read the file in the files folder
  var workingPath = Directory.current.path;
  var file = File("$workingPath/lib/$folder/$filename");
  var content = await file.readAsString();
  return content;
}

List<String> customSplit(String text, String pattern, int times) {
  List<String> parts = [];

  for (int i = 0; i < times; i++) {
    int index = text.indexOf(pattern);
    if (index == -1) {
      break;
    }
    parts.add(text.substring(0, index));
    text = text.substring(index + pattern.length);
  }

  parts.add(text);
  return parts;
}
