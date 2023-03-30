import 'dart:io';

import 'helper.dart' as helper;
import 'package:localization_manager_plugin/localization_manager_plugin.dart';

final languageCodes = ['de', 'en'];
final List<String> filesNames = [
  'docs_titles_{}.csv',
  '{}.csv',
  'docs_headings_{}.csv',
  'docs_texts_{}.csv',
];

Future<TranslationFolder> getTranslationFolder() async {
  /**
   * 
   * docs_headings_de.csv hat eine beziehung zu docs_texts_de.csv 
   * docs_headings_de.csv hat eine beziehung zu docs_titles_de.csv
   * de.csv ist alleine bzw ist von Landing page   */

  List<TranslationFolder> translationFolders = [];

  // Get the folder names, the translation keys and the translation values
  List<String> folderNames = [];
  Map<String, List<String>> translationKeys = {};
  Map<String, List<String>> translationValues = {};

  for (var fileName in filesNames) {
    for (var languageCode in languageCodes) {
      String fileContent = await helper.getLocaleTranslationFileContent(
          fileName.replaceAll('{}', languageCode));

      // The title file is the folder for the translation
      if (fileName == 'docs_titles_{}.csv') {
        folderNames.add(fileContent.split(',')[1]);
      }

      // The heading file is is the key for the translation folder
      if (fileName == 'docs_headings_{}.csv') {
        String index = fileContent.split(",")[1];
        String keyToAdd = fileContent.split(',')[2];
        String headingId = fileContent.split(',')[0];

        // Check if the folder name is already in the list -> if not add it to the list, if yes add the translation key to the existing folder
        if (translationKeys.containsKey(index)) {
          translationKeys[index]!.add(keyToAdd);
        } else {
          translationKeys[index] = [keyToAdd];
          translationValues[headingId] = [];
        }
      }

      // The text file contains the translation for the keys
      if (fileName == 'docs_texts_{}.csv') {
        String headingId = fileContent.split(',')[0];
        String valueToAdd = fileContent.split(',')[2];

        if (translationValues.containsKey(headingId)) {
          translationValues[headingId]!.add(valueToAdd);
        } else {
          translationValues[headingId] = [valueToAdd];
        }
      } else {
        continue;
      }
    }
  }

  // Create the translation folders

  for (var i = 0; i < folderNames.length; i++) {
    var translationFolder = new TranslationFolder(
      name: folderNames[i],
      keys: translationKeys.map((key, value) => {
            new TranslationKey(
                name: name,
                translations: translations,
                autocompleteValues: autocompleteValues,
                description: description,
                parameters: parameters)
          }),
    );
  }
}
