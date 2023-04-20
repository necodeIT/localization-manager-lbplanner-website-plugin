import 'dart:io';
import 'helper.dart' as helper;
import 'package:localization_manager_plugin/localization_manager_plugin.dart';

final languageCodes = ['de', 'en'];
final List<String> files = [
  '{}.csv',
  'docs_titles_{}.csv',
  'docs_headings_{}.csv',
  'docs_texts_{}.csv',
];

Future<TranslationFolder> getTranslationFolder() async {
  /**
   * 
   * docs_headings_de.csv hat eine beziehung zu docs_texts_de.csv 
   * docs_headings_de.csv hat eine beziehung zu docs_titles_de.csv
   * de.csv ist alleine bzw ist von Landing page   */

  // return TranslationFolder(name: "Section", keys: [
  //   TranslationKey(
  //     name: "Section name",
  //     translations: {},
  //     autocompleteValues: [],
  //     description: "The name of the sectiob",
  //     parameters: [],
  //   ),
  // ], folders: [
  //   TranslationFolder(name: "Header name", keys: [
  //     TranslationKey(
  //       name: "Header name",
  //       translations: {},
  //       autocompleteValues: [],
  //       description: "The name of the header",
  //       parameters: [],
  //     ),
  //     TranslationKey(
  //       name: "Contnetn",
  //       translations: {},
  //       autocompleteValues: [],
  //       description: "The text to display in the header",
  //       parameters: [],
  //     ),
  //   ])
  // ]);

  // Loop through all the files
  for (var file in files) {
    // Loop through all the languages
    for (var languageCode in languageCodes) {
      // Get the file name
      var fileName = file.replaceAll("{}", languageCode);

      // As each file (name) has a different formatting and columns, we need to handle them differently
      if (fileName == files[0]) {}
      if (fileName == files[1]) {}
      if (fileName == files[2]) {}
      if (fileName == files[3]) {}
    }
  }
}
