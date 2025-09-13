class Config {
  // OpenAI Configuration
  static const String openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: 'YOUR_OPENAI_API_KEY_HERE',
  );
  
  // You can also use SharedPreferences for runtime configuration
  static String? _runtimeApiKey;
  
  static String get apiKey {
    return _runtimeApiKey ?? openaiApiKey;
  }
  
  static void setApiKey(String key) {
    _runtimeApiKey = key;
  }
  
  static bool get isApiKeyConfigured {
    return apiKey != 'YOUR_OPENAI_API_KEY_HERE' && apiKey.isNotEmpty;
  }
}

// Instructions for setting up the API key:
// 
// Method 1: Environment Variable (Recommended for production)
// Add to your IDE run configuration or terminal:
// export OPENAI_API_KEY="your-actual-api-key-here"
// 
// Method 2: Runtime Configuration
// Call Config.setApiKey("your-actual-api-key-here") in your app
// 
// Method 3: Direct replacement (Not recommended for production)
// Replace 'YOUR_OPENAI_API_KEY_HERE' with your actual API key
// 
// IMPORTANT: Never commit your actual API key to version control!
// Add your API key to .gitignore or use environment variables.