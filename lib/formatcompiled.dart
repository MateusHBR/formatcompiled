import 'dart:convert';
import 'dart:io';

Future<void> formatJsonFile(String inputFilePath, String outputFilePath) async {
  try {
    final inputFile = File(inputFilePath);
    final outputFile = File(outputFilePath);

    if (await inputFile.exists()) {
      final jsonString = await inputFile.readAsString();
      final jsonObject = jsonDecode(jsonString) as Map;
      final decodedJsonObject = decodeNestedJson(jsonObject);
      final formattedJsonString =
          JsonEncoder.withIndent('  ').convert(decodedJsonObject);

      await outputFile.writeAsString(formattedJsonString);
      print('JSON formatted and saved to $outputFilePath');
    } else {
      print('Input file does not exist.');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

dynamic decodeNestedJson(dynamic value) {
  if (value is String) {
    try {
      final decodedValue = jsonDecode(value);
      if (decodedValue is Map || decodedValue is List) {
        return decodeNestedJson(decodedValue);
      }
    } catch (e) {
      // Not a JSON string, return the original value
    }
  } else if (value is Map) {
    return value.map((key, val) => MapEntry(key, decodeNestedJson(val)));
  } else if (value is List) {
    return value.map(decodeNestedJson).toList();
  }
  return value;
}
