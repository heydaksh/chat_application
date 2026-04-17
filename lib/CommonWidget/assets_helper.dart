import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetsHelper {
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';

  static Widget getImageAsset(
    String fileName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    return Image.asset(
      '$imagePath$fileName',
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image, size: width ?? 24, color: Colors.grey);
      },
    );
  }

  static Widget getSVGIcon(
    String fileName, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      '$iconPath$fileName',
      width: width,
      height: height,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      fit: fit,
      placeholderBuilder: (context) => Icon(Icons.insert_emoticon, size: width ?? 24, color: Colors.grey),
    );
  }
}
