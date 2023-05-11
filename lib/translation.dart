import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'helper.dart' as helper;
import 'package:localization_manager_plugin/localization_manager_plugin.dart';

final languageCode = "de";

Future<Map<int, Map<String, dynamic>>> getMapWithTheContents() async {
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

  Map<int, Map<String, dynamic>> folders = {};

  var mainHeader = await helper
      .getLocaleTranslationFileContent("docs_titles_$languageCode.csv");
  var mainHeaderLines = mainHeader.split("\n");

  for (var mainLine in mainHeaderLines) {
    var mainLineSplit = mainLine.split(",");
    var mainFolderId = int.parse(mainLineSplit[0]);
    var mainFolderTitle = mainLineSplit[1];

    folders[mainFolderId] = {
      "title": mainFolderTitle,
      "subFolders": {},
      "content": {},
    };

    var subHeader = await helper
        .getLocaleTranslationFileContent("docs_headings_$languageCode.csv");
    var subHeaderLines = subHeader.split("\n");

    for (var subLine in subHeaderLines) {
      var subLineSplit = subLine.split(",");
      var subFolderId = subLineSplit[0];
      var mainFolderIdFromSub = int.parse(subLineSplit[1]);

      if (mainFolderIdFromSub != mainFolderId) continue;

      folders[mainFolderId]!["subFolders"][subFolderId] = subLineSplit[2];
    }

    var subContent = await helper
        .getLocaleTranslationFileContent("docs_texts_$languageCode.csv");
    var subContentLines = subContent.split("\n");

    for (var subContentLine in subContentLines) {
      var subContentLineSplit = helper.customSplit(subContentLine, ",", 2);
      var subFolderIdFromContent = subContentLineSplit[0];

      if (folders[mainFolderId]!["content"][subFolderIdFromContent] == null) {
        folders[mainFolderId]!["content"][subFolderIdFromContent] = [];
      }

      if (subContentLineSplit.length < 3) continue;

      var content = subContentLineSplit[2].trim();
      if (content.isNotEmpty) {
        folders[mainFolderId]!["content"][subFolderIdFromContent]!.add(content);
      }
    }
  }

  return folders;
}

Future<TranslationFolder> getTranslationFolder() async {
  Map<int, Map<String, dynamic>> folders = await getMapWithTheContents();

  var translationFolder = TranslationFolder(name: "Section", keys: []);

  return translationFolder;
}
