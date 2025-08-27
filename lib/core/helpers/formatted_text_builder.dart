import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../features/contextualcards/model/formatted_text_model.dart';
import 'color_utils.dart';

class FormattedTextBuilder {
  static Widget buildFormattedText(
    FormattedText formattedText, {
    TextStyle? style,
  }) {
    if (formattedText.entities.isEmpty) {
      return Text(formattedText.text, style: style);
    }

    if (!formattedText.text.contains('{}')) {
      return RichText(
        text: TextSpan(
          children: formattedText.entities.map((entity) {
            return TextSpan(
              text: entity.text,
              style: TextStyle(
                color: ColorUtils.parseColor(entity.color) ?? style?.color,
                fontStyle: entity.fontStyle == 'italic'
                    ? FontStyle.italic
                    : FontStyle.normal,
                decoration: entity.fontStyle == 'underline'
                    ? TextDecoration.underline
                    : TextDecoration.none,
                fontWeight: entity.fontStyle?.contains("semi_bold") == true
                    ? FontWeight.w600
                    : style?.fontWeight,
                fontSize: style?.fontSize,
              ),
              recognizer: entity.url != null
                  ? (TapGestureRecognizer()
                      ..onTap = () => UrlHandler.handleTap(entity.url))
                  : null,
            );
          }).toList(),
        ),
      );
    }

    List<TextSpan> spans = [];
    String text = formattedText.text;
    int entityIndex = 0;

    while (text.contains('{}') && entityIndex < formattedText.entities.length) {
      int index = text.indexOf('{}');
      if (index > 0) {
        spans.add(TextSpan(text: text.substring(0, index), style: style));
      }

      Entity entity = formattedText.entities[entityIndex];
      spans.add(
        TextSpan(
          text: entity.text,
          style: TextStyle(
            color: ColorUtils.parseColor(entity.color) ?? style?.color,
            decoration: entity.fontStyle == 'underline'
                ? TextDecoration.underline
                : TextDecoration.none,
            fontStyle: entity.fontStyle == 'italic'
                ? FontStyle.italic
                : FontStyle.normal,
            fontWeight: entity.fontStyle?.contains("semi_bold") == true
                ? FontWeight.w600
                : style?.fontWeight,
            fontSize: style?.fontSize,
          ),
          recognizer: entity.url != null
              ? (TapGestureRecognizer()
                  ..onTap = () => UrlHandler.handleTap(entity.url))
              : null,
        ),
      );

      text = text.replaceFirst('{}', '');
      entityIndex++;
    }

    if (text.isNotEmpty) {
      spans.add(TextSpan(text: text, style: style));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
