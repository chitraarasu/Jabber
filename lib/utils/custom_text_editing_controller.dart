// import 'package:flutter/material.dart';
//
// class CustomTextFieldController extends TextEditingController {
//   @override
//   TextSpan buildTextSpan(
//       {required BuildContext context,
//       TextStyle? style,
//       required bool withComposing}) {
//     // children  stores all  spans that textfield is going to display
//     List<InlineSpan> children = [];
//
//     // this map has all data to identify and apply a style to a substr of
//     // textfield's text
//     Map styleMaps = {
//       "**": [
//         // Regex for identifying bold expressions and to get text that has to be bold
//         r'\*\*(.+?)\*\*',
//         // Defining style for bold text
//         // using style?.copyWith as defining a TextStyle() will remove all
//         // the style except which are defined
//         style?.copyWith(fontWeight: FontWeight.bold),
//       ],
//       "*": [
//         // Regex for identifying italic expressions and to get text that has
//         // to be italic
//         r'\*(.+?)\*',
//         // Defining style for italic text
//         // using style?.copyWith as defining a TextStyle() will remove all the
//         //style except which are defined
//         style?.copyWith(fontStyle: FontStyle.italic),
//       ],
//     };
//
//     // creates a pattern using styleMaps for matching text in textfield's text
//     Pattern pattern = RegExp(
//         styleMaps.keys.map((key) {
//           return styleMaps[key][0];
//         }).join('|'),
//         multiLine: true);
//
//     // splitMapJoin identifies a pattern in textfield's text using the pattern
//     // we created before
//     text.splitMapJoin(
//       pattern,
//       onMatch: (Match matchedText) {
//         TextStyle customStyle = const TextStyle();
//
//         // delimeter is used for replacing the identifier(like * for italic)
//         // with an invisible character so cursor position will be accurate
//         String delimeter = "";
//
//         // Going through the styleMaps to extract the style defined for matched
//         // text and set delimeter to the key
//         for (String key in styleMaps.keys) {
//           var styleMap = styleMaps[key];
//           // checking if the current styleMap matches with matchedText
//           if (RegExp(styleMap[0]).hasMatch(matchedText[0]!)) {
//             customStyle = styleMap[1];
//             delimeter = key;
//             // breaking as the match is matched with current matchedText
//             break;
//           }
//         }
//         // adding textspan to children with given style
//         children.add(
//           TextSpan(children: [
//             // this if checkes if the cursor position is bw the matchedText
//             //or at the start or end to show the whole string with delimeters
//             (matchedText[0]!.length + text.indexOf(matchedText[0]!) >=
//                         selection.base.offset &&
//                     selection.base.offset >= text.indexOf(matchedText[0]!))
//                 ? TextSpan(text: matchedText[0])
//                 : TextSpan(
//                     text: matchedText[0]!.replaceAll(
//                       delimeter,
//                       // replacing the identifier with an invisible character
//                       // with the size of the identifier copy the invisible
//                       //character from github (it will show as an empty string
//                       //as its invisible)
//                       "‎" * delimeter.length,
//                     ),
//                   ),
//           ], style: customStyle),
//         );
//
//         // returning "" as we need not to return anything
//         return "";
//       },
//       onNonMatch: (str) {
//         // if str is not matched, adding it to children with normal style
//         children.add(TextSpan(text: str, style: style));
//         return "";
//       },
//     );
//
//     return TextSpan(children: children);
//   }
// }
