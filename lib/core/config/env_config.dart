const String apiUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://192.168.0.104:8080',
);

const String environmentName = String.fromEnvironment(
  'ENV_NAME',
  defaultValue: 'development',
);
