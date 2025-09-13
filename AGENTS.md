# Fatless App Development Plan

## 🎯 Project Overview
Flutter-based fitness app with AI-powered chat, onboarding flow, and meal/workout tracking for SF Belle Hackathon 2025.

## 📋 Development Phases

### Phase 1: Core Setup & Dependencies
- [ ] Add required dependencies (animations, state management, HTTP, database)
- [ ] Setup project structure (screens, widgets, models, services)
- [ ] Configure assets folder for images/videos
- [ ] Setup basic routing and navigation

### Phase 2: Onboarding Flow
- [ ] **Video Introduction (0-10s)**
  - Background video with overlay text
  - Auto-progression through 3 text screens
  - Audio integration
- [ ] **Interactive Survey (10-20s)**
  - Q1: Exercise preferences with lighting animation
  - Q2: Diet experience multi-select
  - Q3: Quit reasons multi-select
  - Click sound effects and visual feedback
- [ ] **Transition Sequence (20s+)**
  - Smooth animations between screens
  - Auto-progression to user survey

### Phase 3: User Survey & Profile
- [ ] **Data Collection Form**
  - Height, current weight, target weight (int)
  - Other fields as strings
  - Form validation
- [ ] **User ID Generation**
  - Format: YYYYMMDD + target weight
  - Auto-save to local database
- [ ] **Profile Setup**
  - Tag generation from survey answers
  - Avatar selection (3 placeholder options)
  - Weight loss declaration

### Phase 4: Chat System
- [ ] **AI Integration**
  - Model API setup (Arena/OpenAI)
  - System prompt configuration
  - Mood-based responses (distract/motivate/remind)
- [ ] **Chat Interface**
  - Message bubbles with Daniel character
  - Hardcoded welcome messages for first-time users
  - Real-time conversation flow
- [ ] **Content Extraction**
  - Auto-detect diet recipes → Meal section
  - Auto-detect workout videos → Workout section

### Phase 5: Core Features
- [ ] **Main Dashboard**
  - User profile tags display
  - Navigation to Chat/Meal/Workout
  - Progress indicators
- [ ] **Meal Section**
  - Recipe cards from chat conversations
  - Blue filter toggle for appetite suppression
  - Search functionality (future enhancement)
- [ ] **Workout Section**
  - Video cards from chat conversations
  - Duration-based filtering
  - Exercise categorization

### Phase 6: Database & State Management
- [ ] **Local Storage**
  - User profile data
  - Chat history
  - Saved recipes and workouts
- [ ] **State Management**
  - User session management
  - Chat state persistence
  - Navigation state

### Phase 7: UI/UX Polish
- [ ] **Animations**
  - Onboarding lighting effects
  - Smooth transitions
  - Loading states
- [ ] **Responsive Design**
  - Mobile-first approach
  - Cross-platform compatibility
- [ ] **Visual Assets**
  - Placeholder images integration
  - Icon set implementation
  - Color scheme consistency

## 🛠 Technical Stack

### Dependencies to Add
```yaml
dependencies:
  # State Management
  provider: ^6.1.1

  # Animations
  lottie: ^3.1.0

  # HTTP & API
  http: ^1.1.2
  dio: ^5.4.0

  # Database
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2

  # Media
  video_player: ^2.8.1
  audioplayers: ^5.2.1

  # UI Components
  flutter_staggered_animations: ^1.1.1
  cached_network_image: ^3.3.0
```

### Project Structure
```
lib/
├── main.dart
├── models/
│   ├── user_profile.dart
│   ├── chat_message.dart
│   ├── recipe.dart
│   └── workout.dart
├── screens/
│   ├── onboarding/
│   ├── survey/
│   ├── dashboard/
│   ├── chat/
│   ├── meal/
│   └── workout/
├── widgets/
│   ├── common/
│   └── custom/
├── services/
│   ├── api_service.dart
│   ├── database_service.dart
│   └── audio_service.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

## 🎨 Key Features Implementation

### Onboarding Animation System
- Video background with text overlays
- Interactive multi-select with lighting effects
- Sound feedback on interactions
- Smooth transitions between phases

### AI Chat Integration
- Context-aware responses based on user mood selection
- Automatic content categorization
- Conversation history persistence

### Content Management
- Auto-extraction of recipes and workouts from chat
- Visual filtering effects (blue filter for meals)
- Categorization and search capabilities

## 🚀 Development Priority
1. **High Priority**: Onboarding flow, basic chat, user survey
2. **Medium Priority**: Meal/workout sections, database integration
3. **Low Priority**: Advanced animations, search features, filters

## 📱 Platform Targets
- Primary: Web (Chrome) for demo
- Secondary: iOS/Android for future deployment

## ⏰ Hackathon Timeline
- **Setup & Dependencies**: 2 hours
- **Onboarding Flow**: 4 hours
- **Chat System**: 3 hours
- **Core Features**: 3 hours
- **Polish & Testing**: 2 hours

Total: ~14 hours development time
