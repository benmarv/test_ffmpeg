import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  
  SizedBox get sh=>SizedBox(height: toDouble(),);
  SizedBox get sw=>SizedBox(width: toDouble(),);
  
}