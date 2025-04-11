import 'package:flutter/material.dart';

import 'colors.dart';

class _ButtonThemes{
  ButtonStyle get transparentButton => ElevatedButton.styleFrom(
      backgroundColor: colors.transparent,
      shadowColor: colors.transparent
  );
}

final buttonThemes = _ButtonThemes();