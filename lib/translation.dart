import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'helper.dart' as helper;
import 'package:localization_manager_plugin/localization_manager_plugin.dart';

final languageCode = "de";

void getTranslationFolder() async {
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
  //     description: "The name of the section",
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

  Map<int, String> mainFolders = HashMap();
  Map<int, Map<String, String>> subFolders = HashMap();
  Map<String, List<String>> subFoldersMainContent = HashMap();

  // Read the main folder headers. The format is: 0, Section
  var mainHeader = await helper
      .getLocaleTranslationFileContent("docs_titles_$languageCode.csv");
  var mainHeaderLines = mainHeader.split("\n");
  String mainLine;
  for (mainLine in mainHeaderLines) {
    List<String> lineSplit = mainLine.split(",");
    mainFolders[int.parse(lineSplit[0])] = lineSplit[1];

    // Read the sub folder headers. The format is: 00, 0, Header where 00 is the sub folder id and 0 is the main folder id
    var subHeader = await helper
        .getLocaleTranslationFileContent("docs_headings_$languageCode.csv");
    var subHeaderLines = subHeader.split("\n");
    String subLine;
    for (subLine in subHeaderLines) {
      List<String> subLineSplit = subLine.split(","); // 00, 0, Header
      if (subLineSplit[1] == lineSplit[0]) {
        if (subFolders[int.parse(subLineSplit[1])] == null) {
          subFolders[int.parse(subLineSplit[1])] = HashMap();
        }

        subFolders[int.parse(subLineSplit[1])]![subLineSplit[0]] =
            subLineSplit[2];
      }

      // Read the sub folder actual content(text). The format is: 00, 0. The 0 can be increment as it can be multiple lines because of the max character limit
      var subContent = await helper
          .getLocaleTranslationFileContent("docs_texts_$languageCode.csv");
      var subContentLines = subContent.split("\n");
      String subContentLine;
      int i = 0;
      for (subContentLine in subContentLines) {
        if (i == 5) break;
        // Split only twice as the content can have commas
        List<String> subContentLineSplit =
            helper.customSplit(subContentLine, ",", 2);

        if (subContentLineSplit.length < 3) continue;
        if (subFoldersMainContent[subContentLineSplit[0]] == null) {
          if (subContentLineSplit[2].isNotEmpty) {
            subFoldersMainContent[subContentLineSplit[0]] = [
              subContentLineSplit[2]
            ];
          } else {
            subFoldersMainContent[subContentLineSplit[0]] = [];
          }
        } else if (subContentLineSplit[2].isNotEmpty) {
          subFoldersMainContent[subContentLineSplit[0]]!
              .add(subContentLineSplit[2]);
        }

        //
      }
    }
  }

  print(subFoldersMainContent);
}
