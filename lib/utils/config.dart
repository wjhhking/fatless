import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // OpenAI Configuration
  static String get openaiApiKey {
    return dotenv.env['OPENAI_API_KEY'] ?? 'YOUR_OPENAI_API_KEY_HERE';
  }
  
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
// Method 1: Direct replacement (Easiest for development)
// Replace 'YOUR_OPENAI_API_KEY_HERE' with your actual API key
// 
// Method 2: Runtime Configuration
// Call Config.setApiKey("your-actual-api-key-here") in your main.dart
// 
// Method 3: Environment Variable (For production)
// Add to your IDE run configuration or terminal:
// export OPENAI_API_KEY="your-actual-api-key-here"
// 
// IMPORTANT: The .env file and *.key files are already in .gitignore
// so they won't be committed to GitHub.