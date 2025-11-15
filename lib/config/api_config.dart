/// Configuration for API keys and endpoints
///
/// SECURITY NOTE: In production, these values should be loaded from
/// environment variables or a secure configuration management system.
/// For local development, you can use flutter_dotenv package.
class ApiConfig {
  // YouTube Music API Key
  // NOTE: This is a client-side API key for YouTube Music.
  // While it's commonly used in web clients, consider:
  // 1. Using environment variables (flutter_dotenv)
  // 2. Implementing server-side proxy for sensitive operations
  // 3. Rotating keys periodically
  // 4. Adding usage quotas and monitoring
  static const String ytmApiKey = 'AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30';

  // Construct YTM API params
  static String get ytmParams => '?alt=json&key=$ytmApiKey';

  // API Endpoints
  static const String ytmDomain = 'music.youtube.com';
  static const String httpsYtmDomain = 'https://music.youtube.com';
  static const String baseApiEndpoint = '/youtubei/v1/';

  // User Agent
  static const String userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0';
}
