import 'package:famapp/core/helpers/url_handler.dart';
import 'package:flutter/material.dart';
import '../../features/contextualcards/model/call_to_action_model.dart';
import 'color_utils.dart';

class CTAButton {
  static Widget buildCTAButton(CallToAction cta) {
    return ElevatedButton(
      onPressed: () => UrlHandler.handleTap(cta.url),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorUtils.parseColor(cta.bgColor) ?? Colors.white,
        foregroundColor: ColorUtils.parseColor(cta.textColor) ?? Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(cta.text),
    );
  }
}
