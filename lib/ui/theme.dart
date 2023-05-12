import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(useMaterial3: true, colorScheme: lightColorScheme);
final ThemeData darkTheme = ThemeData(useMaterial3: true, colorScheme: darkColorScheme);

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFB22156),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFD9DF),
  onPrimaryContainer: Color(0xFF3F0018),
  secondary: Color(0xFFB72020),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFDAD6),
  onSecondaryContainer: Color(0xFF410002),
  tertiary: Color(0xFF006B54),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF80F8D1),
  onTertiaryContainer: Color(0xFF002117),
  error: Color(0xFF973A85),
  errorContainer: Color(0xFFFFD7F0),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF3A0032),
  background: Color(0xFFFBFCFD),
  onBackground: Color(0xFF191C1D),
  outline: Color(0xFF70787C),
  onInverseSurface: Color(0xFFEFF1F2),
  inverseSurface: Color(0xFF2E3132),
  inversePrimary: Color(0xFFFFB1C2),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFB22156),
  outlineVariant: Color(0xFFBFC8CB),
  scrim: Color(0xFF000000),
  surface: Color(0xFFF8FAFA),
  onSurface: Color(0xFF191C1D),
  surfaceVariant: Color(0xFFDBE4E7),
  onSurfaceVariant: Color(0xFF3F484B),
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB1C2),
  onPrimary: Color(0xFF66002B),
  primaryContainer: Color(0xFF8F003F),
  onPrimaryContainer: Color(0xFFFFD9DF),
  secondary: Color(0xFFFFB4AB),
  onSecondary: Color(0xFF690006),
  secondaryContainer: Color(0xFF93000D),
  onSecondaryContainer: Color(0xFFFFDAD6),
  tertiary: Color(0xFF62DBB6),
  onTertiary: Color(0xFF00382A),
  tertiaryContainer: Color(0xFF00513E),
  onTertiaryContainer: Color(0xFF80F8D1),
  error: Color(0xFFFFACE7),
  errorContainer: Color(0xFF7A206B),
  onError: Color(0xFF5E0053),
  onErrorContainer: Color(0xFFFFD7F0),
  background: Color(0xFF191C1D),
  onBackground: Color(0xFFE1E3E4),
  outline: Color(0xFF899295),
  onInverseSurface: Color(0xFF191C1D),
  inverseSurface: Color(0xFFE1E3E4),
  inversePrimary: Color(0xFFB22156),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFB1C2),
  outlineVariant: Color(0xFF3F484B),
  scrim: Color(0xFF000000),
  surface: Color(0xFF111415),
  onSurface: Color(0xFFC4C7C8),
  surfaceVariant: Color(0xFF3F484B),
  onSurfaceVariant: Color(0xFFBFC8CB),
);