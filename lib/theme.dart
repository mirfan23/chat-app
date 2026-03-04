import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color(0xFFFFFFFF);
Color secondaryColor = const Color(0xFFF6643A);

Color creamColor = const Color(0xFFFFF5E4);
Color lightLimeColor = const Color(0xFFE3EDC7);

Color blackColor = Color(0xFF252525);

Color whiteColor = const Color(0xffFFFFFF);
Color brokenWhiteColor = const Color(0xFFFCFCFC);
Color darkWhiteColor = const Color(0xFFF9F9F9);

Color lightGreyColor = Color(0xFFF0F0F0);
Color greyColor = Color(0xFFBEBEBE);
Color darkGreyColor = Color(0xFF6F6E6E);

Color darkRedColor = Color(0xFF8E252E);

Color lightRedColor = Color(0xFFFDE9E9);
Color redColor = Color(0xFFCE2717);
Color lightGreenColor = Color(0xFFEAFAEB);
Color greenColor = Color(0xFF356530);
Color lightYellowColor = Color(0xFFF9F9E8);
Color yellowColor = Color(0xFFC78705);

Color randomColor = Colors.purple;
Color transparentColor = Colors.transparent;

Gradient primaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [primaryColor, secondaryColor],
);

Gradient redGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [darkRedColor, redColor],
);

Gradient greyGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [greyColor, greyColor],
);

double getMaxWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}

double getMaxHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

/// Defines global text style associated with design at 8px
TextStyle textStyleMoreTiny(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 36,
  );
}

/// Defines global text style associated with design at 10px
TextStyle textStyleTiny(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 32,
  );
}

/// Defines global text style associated with design at 12px
TextStyle textStyleSmall(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 28,
  );
}

/// Defines global text style associated with design at 14px
TextStyle textStyleMedium(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 24,
  );
}

/// Defines global text style associated with design at 16px
TextStyle textStyleMediumBig(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 22,
  );
}

/// Defines global text style associated with design at 18px
TextStyle textStyleBig(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 18,
  );
}

/// Defines global text style associated with design at 20px
TextStyle textStyleHuge(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 17,
  );
}

/// Defines global text style associated with design at 30px
TextStyle textStyleExtraHuge(BuildContext context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: blackColor,
    fontSize: MediaQuery.sizeOf(context).width / 14,
  );
}

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

getInputDecoration() {
  return InputDecorationThemeData(
    fillColor: whiteColor,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: greyColor),
      borderRadius: BorderRadius.circular(10),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: lightGreyColor),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: redColor),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: lightGreyColor),
      borderRadius: BorderRadius.circular(10),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: lightGreyColor.withValues(alpha: 0.3)),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

ThemeData customTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
  primaryColor: primaryColor,
  useMaterial3: true,

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
          // side: BorderSide(color: lightGreyColor),
        ),
      ),
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return lightGreyColor;
        } else if (states.contains(WidgetState.dragged)) {
          return Colors.yellowAccent;
        } else if (states.contains(WidgetState.error)) {
          return Colors.deepOrangeAccent.withValues(alpha: 0.8);
        } else if (states.contains(WidgetState.focused)) {
          return Colors.purpleAccent;
        } else if (states.contains(WidgetState.hovered)) {
          return primaryColor.withValues(alpha: 0.2);
        } else if (states.contains(WidgetState.scrolledUnder)) {
          return Colors.lime;
        } else if (states.contains(WidgetState.selected)) {
          return Colors.lightGreenAccent;
        }

        return primaryColor;
      }),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      visualDensity: VisualDensity.compact,
      minimumSize: WidgetStatePropertyAll(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 2, horizontal: 12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
          side: BorderSide(width: 3, color: primaryColor),
        ),
      ),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: lightGreyColor);
        } else if (states.contains(WidgetState.dragged)) {
          return BorderSide(color: lightGreyColor);
        } else if (states.contains(WidgetState.error)) {
          return BorderSide(color: redColor);
        } else if (states.contains(WidgetState.focused)) {
          return BorderSide(color: lightGreyColor);
        } else if (states.contains(WidgetState.hovered)) {
          return BorderSide(color: primaryColor);
        } else if (states.contains(WidgetState.scrolledUnder)) {
          return BorderSide(color: lightGreyColor);
        } else if (states.contains(WidgetState.selected)) {
          return BorderSide(color: lightGreyColor);
        }
        return BorderSide(color: primaryColor);
      }),
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return lightGreyColor.withValues(alpha: 0.3);
        } else if (states.contains(WidgetState.dragged)) {
          return Colors.yellowAccent;
        } else if (states.contains(WidgetState.error)) {
          return primaryColor.withValues(alpha: 0.8);
        } else if (states.contains(WidgetState.focused)) {
          return Colors.purpleAccent;
        } else if (states.contains(WidgetState.hovered)) {
          return primaryColor.withValues(alpha: 0.2);
        } else if (states.contains(WidgetState.scrolledUnder)) {
          return Colors.lime;
        } else if (states.contains(WidgetState.selected)) {
          return Colors.lightGreenAccent;
        }

        return whiteColor;
      }),
    ),
  ),
  inputDecorationTheme: getInputDecoration(),
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll(whiteColor)),
    inputDecorationTheme: getInputDecoration(),
  ),
  datePickerTheme: DatePickerThemeData(backgroundColor: whiteColor),
);
