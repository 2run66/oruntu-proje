# Emotion Recognition Mobile App

A Flutter mobile app that records 3 seconds of human speech and recognizes emotions using a machine learning API.

## Features

- 🎤 **3-Second Voice Recording**: Automatically records for exactly 3 seconds
- 🧠 **Emotion Recognition**: Analyzes speech to detect emotions
- 🎨 **Beautiful UI**: Modern dark theme with emotion-based colors
- 📱 **Cross-Platform**: Works on both iOS and Android
- ⚡ **Real-time Feedback**: Visual and textual emotion results

## Prerequisites

Before running the app, make sure you have:

1. **Flutter SDK** installed (version 3.6.0 or higher)
2. **Your API server** running on `localhost:5000` with the `/predict` endpoint
3. **Android Studio** or **Xcode** for device/emulator testing

## API Requirements

Your API should:
- Run on `localhost:5000`
- Have a `POST /predict` endpoint
- Accept WAV files as multipart form data
- Return JSON response: `{"emotion": "emotion_name"}`

Example API response:
```json
{
  "emotion": "happy"
}
```

## Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure API Endpoint

The app is pre-configured for different environments:

- **Android Emulator**: Uses `http://10.0.2.2:5000` (automatically maps to your computer's localhost)
- **iOS Simulator**: You'll need to replace with your computer's IP address
- **Real Device**: You'll need to replace with your computer's IP address

To change the API endpoint, edit `lib/config.dart`:

```dart
static String get baseUrl {
  return 'http://YOUR_COMPUTER_IP:5000'; // Replace with your IP
}
```

To find your computer's IP address:
- **macOS/Linux**: Run `ifconfig | grep inet`
- **Windows**: Run `ipconfig`

### 3. Run the App

#### For Android Emulator:
```bash
flutter run
```

#### For iOS Simulator:
1. First, update the API URL in `lib/config.dart` with your computer's IP
2. Then run:
```bash
flutter run
```

#### For Real Device:
1. Update the API URL in `lib/config.dart` with your computer's IP
2. Make sure your device is on the same network as your computer
3. Run:
```bash
flutter run
```

## How to Use

1. **Launch the app** on your device/emulator
2. **Tap the microphone button** to start recording
3. **Speak clearly** for 3 seconds (recording stops automatically)
4. **Wait for analysis** - the app will send your recording to the API
5. **View the result** - the detected emotion will be displayed with a color-coded icon

## Supported Emotions

The app recognizes and displays the following emotions with appropriate colors and icons:

- 😊 **Happy** - Yellow
- 😢 **Sad** - Blue  
- 😠 **Angry** - Red
- 😨 **Fearful** - Purple
- 😲 **Surprised** - Orange
- 🤢 **Disgust** - Green
- 😌 **Calm** - Light Blue
- 😐 **Neutral** - Grey

## Troubleshooting

### Permission Issues
- Make sure microphone permissions are granted
- On iOS, check Settings > Privacy & Security > Microphone
- On Android, the app will request permission automatically

### API Connection Issues
- Ensure your API server is running on port 5000
- For emulator/simulator: Use your computer's IP address instead of localhost
- Check your firewall settings
- Make sure your device and computer are on the same network

### Recording Issues
- Test on a real device if emulator has audio issues
- Ensure your device has a working microphone
- Check device volume settings

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── config.dart                  # API configuration
├── models/
│   └── emotion_result.dart      # Data model for emotion results
├── services/
│   ├── audio_service.dart       # Audio recording functionality
│   └── api_service.dart         # API communication
├── widgets/
│   ├── recording_button.dart    # Animated recording button
│   ├── emotion_result_card.dart # Emotion display card
│   ├── error_message.dart       # Error message widget
│   └── instructions_card.dart   # Instructions display
├── screens/
│   └── recording_screen.dart    # Main recording screen
└── utils/
    └── emotion_utils.dart       # Emotion-related utilities
```

## API Configuration

The app is currently configured to use your IP address (`192.168.1.157:5000`). To change this:

**For Android Emulator**: Edit `lib/config.dart` and change the baseUrl to:
```dart
return 'http://10.0.2.2:5000';
```

**For iOS Simulator or Real Device**: The current configuration should work with your IP.

## Dependencies

- `record: ^5.0.4` - Audio recording
- `permission_handler: ^11.0.1` - Microphone permissions
- `path_provider: ^2.1.1` - File path management
- `http: ^1.1.0` - API requests

## Development Notes

- The app records audio in WAV format at 16kHz sample rate
- Recordings are saved temporarily and cleaned up automatically
- The UI includes visual feedback during recording and processing
- Error handling is implemented for common scenarios

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is open source and available under the MIT License.
