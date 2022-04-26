import 'dart:convert';
import 'dart:io';


void main() {
  final File file = File("assets/json/emoji_20220426.json");
  final List<dynamic> categoryList = json.decoder.convert(file.readAsStringSync());
  for (Map<String, dynamic> child in categoryList) {
    final List<dynamic> emojiList = child["value"];
    for (Map<String, dynamic> emoji in emojiList) {
      print(emoji["phrase"]);
      print(emoji["url"]);
      print('');
    }
  }
}

void main2() {
  const List<String> tags = [
    "[a]",
    "[b]",
    "[c]"
  ];
  const String text = "[[[[]]]]";
  //const String text = "asd";
  final List<String> resultText = [];

  for(int index = 0, lastValidEnd = 0, lastValidStart = 0, lastCropIndex = 0; index < text.length ; index++) {
    // first loop to find first '['
    if (text[index] == '[') {
      for(int end = index + 1; end < text.length; end++) {
        // second loop to find next ']'
        if (text[end] == ']') {
          // substring to get text: [xxx]
          final String found = text.substring(index, end + 1);
          if (tags.contains(found)) {
            // is a valid tag
            lastValidEnd = end + 1;
            lastValidStart = index;
            resultText.add(found);
          }
          break;
        }
      }

      // crop plain text
      final String croppedPlainText;
      if (lastCropIndex < lastValidStart) {
        croppedPlainText = text.substring(lastCropIndex, lastValidStart);
      } else {
        croppedPlainText = "";
      }

      // add plain text into list in correct order
      if (croppedPlainText.isNotEmpty) {
        if (resultText.isEmpty) {
          resultText.add(croppedPlainText);
        } else if (index + 1 == text.length) {
          resultText.add(croppedPlainText);
        } else {
          resultText.insert(resultText.length - 1, croppedPlainText);
        }
      }

      lastCropIndex = lastValidEnd;
    }

    // for last part of text
    if (index + 1 >= text.length) {
      final String aa = text.substring(lastCropIndex, index + 1);
      resultText.add(aa);
    }
  }

  for (var element in resultText) {
    print(element);
  }

}