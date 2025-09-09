import 'package:flutter/material.dart';

class ResponsiveUtils {

  static double clampTextScale(double textScaleFactor) {
    return textScaleFactor.clamp(0.8, 1.3);
  }

  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final textScaleFactor = clampTextScale(mediaQuery.textScaleFactor);

    double responsiveFontSize = baseFontSize;
    if (screenWidth < 360) {
      responsiveFontSize *= 0.9;
    } else if (screenWidth > 600) {
      responsiveFontSize *= 1.1;
    }
    return responsiveFontSize * textScaleFactor;
  }

  static Widget responsiveText(
    String text, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    BuildContext? context,
  }) {
    return Builder(
      builder: (context) {
        final effectiveFontSize = fontSize != null
            ? getResponsiveFontSize(context, fontSize)
            : fontSize;
        return Text(
          text,
          style: TextStyle(
            fontSize: effectiveFontSize,
            fontWeight: fontWeight,
            color: color,
          ),
          maxLines: maxLines ?? 1,
          overflow: overflow ?? TextOverflow.ellipsis,
          textAlign: textAlign,
        );
      },
    );
  }

  static Widget responsiveContainer({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    BoxDecoration? decoration,
    BuildContext? context,
  }) {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final textScaleFactor = clampTextScale(mediaQuery.textScaleFactor);
        return Container(
          width: width,
          height: height != null ? height * textScaleFactor : null,
          padding: padding != null 
              ? EdgeInsets.only(
                  left: padding.left * textScaleFactor,
                  top: padding.top * textScaleFactor,
                  right: padding.right * textScaleFactor,
                  bottom: padding.bottom * textScaleFactor,
                )
              : null,
          margin: margin != null
              ? EdgeInsets.only(
                  left: margin.left * textScaleFactor,
                  top: margin.top * textScaleFactor,
                  right: margin.right * textScaleFactor,
                  bottom: margin.bottom * textScaleFactor,
                )
              : null,
          decoration: decoration,
          child: child,
        );
      },
    );
  }

  static Widget responsiveRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    bool wrapWithFlexible = false,
  }) {
    final wrappedChildren = wrapWithFlexible
        ? children.map((child) => Flexible(child: child)).toList()
        : children;
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: wrappedChildren,
    );
  }

  static Widget responsiveColumn({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    bool wrapWithFlexible = false,
  }) {
    final wrappedChildren = wrapWithFlexible
        ? children.map((child) => Flexible(child: child)).toList()
        : children;
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: wrappedChildren,
    );
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = clampTextScale(mediaQuery.textScaleFactor);
    final screenWidth = mediaQuery.size.width;
    double spacing = baseSpacing;
    if (screenWidth < 360) {
      spacing *= 0.8;
    } else if (screenWidth > 600) {
      spacing *= 1.2;
    }
    return spacing * textScaleFactor;
  }
}

extension ResponsiveContext on BuildContext {

  double responsiveFontSize(double baseFontSize) {
    return ResponsiveUtils.getResponsiveFontSize(this, baseFontSize);
  }

  double responsiveSpacing(double baseSpacing) {
    return ResponsiveUtils.getResponsiveSpacing(this, baseSpacing);
  }

  bool get isSmallScreen => ResponsiveUtils.isSmallScreen(this);

  bool get isLargeScreen => ResponsiveUtils.isLargeScreen(this);

  double get clampedTextScale => ResponsiveUtils.clampTextScale(MediaQuery.of(this).textScaleFactor);
}
