# OpenAI GPT-4o Integration Setup

This guide explains how to configure OpenAI GPT-4o for the chat feature in your Flutter app.

## Prerequisites

1. **OpenAI API Account**: Sign up at [OpenAI Platform](https://platform.openai.com/)
2. **API Key**: Generate an API key from your OpenAI dashboard
3. **Billing Setup**: Ensure you have billing configured for API usage

## Configuration Methods

### Method 1: Environment Variable (Recommended)

1. **For Development (Terminal/IDE)**:
   ```bash
   export OPENAI_API_KEY="your-actual-api-key-here"
   flutter run
   ```

2. **For VS Code**:
   - Create `.vscode/launch.json`:
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Flutter",
         "request": "launch",
         "type": "dart",
         "env": {
           "OPENAI_API_KEY": "your-actual-api-key-here"
         }
       }
     ]
   }
   ```

3. **For Android Studio**:
   - Go to Run → Edit Configurations
   - Add Environment Variable: `OPENAI_API_KEY=your-actual-api-key-here`

### Method 2: Runtime Configuration

Add this code in your app's initialization (e.g., in `main.dart`):

```dart
import 'lib/utils/config.dart';

void main() {
  // Set API key at runtime
  Config.setApiKey("your-actual-api-key-here");
  
  runApp(MyApp());
}
```

### Method 3: Direct Code Modification (Not Recommended)

Edit `lib/utils/config.dart` and replace the default value:

```dart
static const String openaiApiKey = 'your-actual-api-key-here';
```

**⚠️ Warning**: Never commit your API key to version control!

## Security Best Practices

1. **Add to .gitignore**:
   ```
   # API Keys
   .env
   *.key
   ```

2. **Use Environment Variables**: Always prefer environment variables over hardcoded keys

3. **Rotate Keys Regularly**: Generate new API keys periodically

4. **Monitor Usage**: Check your OpenAI dashboard for unexpected usage

## Testing the Integration

1. **Run the app**: `flutter run`
2. **Navigate to Chat**: Go to the chat screen
3. **Send a message**: Type a message and send it
4. **Check response**: You should see AI-generated responses instead of predefined ones

## Troubleshooting

### "API key not configured" Error
- Verify your API key is set correctly
- Check environment variable spelling: `OPENAI_API_KEY`
- Restart your IDE/terminal after setting environment variables

### "Failed to generate response" Error
- Check your internet connection
- Verify API key is valid and has billing enabled
- Check OpenAI service status

### Fallback Behavior
- If API calls fail, the app automatically falls back to local responses
- Error messages will be displayed with a red indicator

## API Usage and Costs

- **Model**: GPT-4o
- **Max Tokens**: 150 per response
- **Temperature**: 0.7 (balanced creativity)
- **Estimated Cost**: ~$0.01-0.03 per conversation

Monitor your usage at [OpenAI Usage Dashboard](https://platform.openai.com/usage)

## Features

✅ **Mood-based responses**: Motivate, Distract, Remind modes
✅ **Loading indicators**: Visual feedback during API calls
✅ **Error handling**: Graceful fallback to local responses
✅ **Secure configuration**: Multiple API key setup methods
✅ **Welcome messages**: AI-generated personalized greetings

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify your OpenAI account status
3. Review the console logs for detailed error messages