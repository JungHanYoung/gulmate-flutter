class EnvironmentConfig {
  static const IS_PROD = bool.fromEnvironment("IS_PROD");
  static const API_DOMAIN = String.fromEnvironment("API_DOMAIN");
  static const API_VERSION = String.fromEnvironment("API_VERSION", defaultValue: "v1");
}