import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProviderByMode = StateProvider<bool>((ref) {
  return false; // false = light, true = dark
});
