import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/provider/theme_provider.dart';

extension MyWidgetRef on WidgetRef {

  bool get lightMode => !read(themeState).darkMode;
  
}