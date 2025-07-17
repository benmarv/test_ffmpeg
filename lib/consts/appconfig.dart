// ignore_for_file: library_prefixes

import 'config_live.dart' as LiveConfig;
import 'config_test.dart' as TestConfig;

class AppConfig {
  static String apiUrl = '';
  static String baseUrl = '';

  static void setupConfig({required bool isDevelopmentEnviroment}) {
    if (isDevelopmentEnviroment) {
      apiUrl = TestConfig.AppConfig.apiPathLinkon;
      baseUrl = TestConfig.AppConfig.baseUrlLinkOn;
    } else {
      apiUrl = LiveConfig.AppConfig.apiPathLinkon;
      baseUrl = LiveConfig.AppConfig.baseUrlLinkOn;
    }
  }
}
