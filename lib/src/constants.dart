// API
const String kBaseUrl = String.fromEnvironment("API_BASE_URL", defaultValue: "http://localhost:8080");
// ignore: prefer_interpolation_to_compose_strings
const String kApiBaseUrl = String.fromEnvironment("API_BASE_URL", defaultValue: "http://localhost:8080") + "/query";
// ignore: prefer_interpolation_to_compose_strings
const String kWebSocketUrl = String.fromEnvironment("API_WS_BASE_URL", defaultValue: "ws://localhost:8080") + "/query";

// Constants
const String kApplicationScheme = "echocircle";
