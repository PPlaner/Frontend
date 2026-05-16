const String apiUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.101.0.171:8080',
);

const String environmentName = String.fromEnvironment(
  'ENV_NAME',
  defaultValue: 'development',
);
