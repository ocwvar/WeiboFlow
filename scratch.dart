import 'package:flutter/cupertino.dart';

void main() {
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
/*

for(int start = 0; start < text.length ; start++) {
    // first loop to find first '['
    if (text[start] == '[') {
      for(int end = start + 1; end < text.length; end++) {
        // second loop to find next ']'
        if (text[end] == ']') {
          // substring to get text: [xxx]
          final String found = text.substring(start, end + 1);
          if (tags.contains(found)) {
            // is a valid tag
            resultTag.add(found);
          } else {
            // is text

          }
          break;
        }
      }
    }
  }

 */