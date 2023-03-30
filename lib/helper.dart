import 'package:http/http.dart' as http;

Future<String> getLocaleTranslationFileContent(String filename) async {
  var url =
      'https://raw.githubusercontent.com/necodeIT/lb_planner/web/locale/$filename';

  print(url);
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load translation file');
  }
}
