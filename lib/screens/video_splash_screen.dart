import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
// Using print for Flutter web debugging

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;
  String _currentText = '';
  bool _isVideoInitialized = false;
  bool _hasUserInteracted = false;
  bool _isVideoPlaying = false;
  Timer? _textTimer;
  Timer? _transitionTimer;

  final List<String> _texts = [
    'Is this you when stepping on the scale?',
    'Don\'t obsess over weights calories',
    'We care all about YOU'
  ];

  final List<int> _textDurations = [3, 3, 4]; // seconds

  @override
  void initState() {
    super.initState();
    debugPrint('VideoSplashScreen: Constructor and initState called - Starting initialization');
    if (kDebugMode) {
      print('VideoSplashScreen: Constructor and initState called - Starting initialization');
    }
    _initializeVideo();
    // Don't start text sequence until user interaction
  }

  Future<void> _initializeVideo() async {
    try {
      print('VideoSplashScreen: Initializing video player...');
      
      // Try different video formats for web compatibility
      String videoPath = 'assets/videos/start_screen-no_text.mov';
      print('VideoSplashScreen: Attempting to load video: $videoPath');
      
      _controller = VideoPlayerController.asset(videoPath);
      
      // Set looping before initialization - disabled for single play
      _controller.setLooping(false);
      
      // Add listener for video player events
      _controller.addListener(() {
        if (mounted) {
          print('VideoSplashScreen: Video player state changed: isPlaying=${_controller.value.isPlaying}, hasError=${_controller.value.hasError}');
          if (_controller.value.hasError) {
            print('VideoSplashScreen: Video player error: ${_controller.value.errorDescription}');
          }
        }
      });
      
      await _controller.initialize();
      
      print('VideoSplashScreen: Video initialized successfully. Size: ${_controller.value.size}');
      print('VideoSplashScreen: Video duration: ${_controller.value.duration}');
      print('VideoSplashScreen: Video aspect ratio: ${_controller.value.aspectRatio}');
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
        
        // Don't start video playback automatically - wait for user interaction
        print('VideoSplashScreen: Video initialized, waiting for user interaction');
      }
    } catch (e) {
      print('VideoSplashScreen: Video loading error: $e');
      print('VideoSplashScreen: Error type: ${e.runtimeType}');
      print('VideoSplashScreen: Error details: ${e.toString()}');
      
      // Handle video loading error
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
        });
        
        // If video fails to load, still wait for user interaction
        print('VideoSplashScreen: Video failed to load, but will wait for user interaction');
      }
    }
  }

  Future<void> _handleUserInteraction() async {
    if (_hasUserInteracted) return;
    
    setState(() {
      _hasUserInteracted = true;
    });
    
    print('VideoSplashScreen: User interaction detected, starting video and text sequence');
    
    // Start video playback with sound (unmuted)
    if (_isVideoInitialized) {
      try {
        await _controller.play();
        setState(() {
          _isVideoPlaying = true;
        });
        print('VideoSplashScreen: Video playback started with sound enabled');
      } catch (e) {
        print('VideoSplashScreen: Error starting video playback: $e');
      }
    }
    
    // Start text sequence
    _startTextSequence();
    
    // Set up automatic transition after 10 seconds
    _transitionTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  void _startTextSequence() {
    int currentIndex = 0;
    
    // Show first text immediately
    setState(() {
      _currentText = _texts[0];
    });
    
    print('VideoSplashScreen: Starting text sequence...');
    
    // Schedule text changes based on durations
    Timer(Duration(seconds: _textDurations[0]), () {
      if (mounted && currentIndex < _texts.length - 1) {
        currentIndex++;
        print('VideoSplashScreen: Changing to text ${currentIndex + 1}: ${_texts[currentIndex]}');
        setState(() {
          _currentText = _texts[currentIndex];
        });
        
        // Schedule second text change
        Timer(Duration(seconds: _textDurations[1]), () {
          if (mounted && currentIndex < _texts.length - 1) {
            currentIndex++;
            print('VideoSplashScreen: Changing to text ${currentIndex + 1}: ${_texts[currentIndex]}');
            setState(() {
              _currentText = _texts[currentIndex];
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textTimer?.cancel();
    _transitionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('VideoSplashScreen: build() called - isVideoInitialized: $_isVideoInitialized');
    if (kDebugMode) {
      print('VideoSplashScreen: build() called - isVideoInitialized: $_isVideoInitialized');
    }
    
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black, // Black background for letterboxing
      body: GestureDetector(
        onTap: _handleUserInteraction,
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.black, // Ensure full black background
          child: Stack(
            children: [

            // Centered video player with letterboxing
            Center(
              child: _isVideoInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      width: screenSize.width * 0.8,
                      height: screenSize.height * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 20),
                            Text(
                              'Loading Video...',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            
            // Tap to start overlay (shown before user interaction)
            if (!_hasUserInteracted)
              Container(
                width: screenSize.width,
                height: screenSize.height,
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Tap to Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Experience with sound',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Text overlay - positioned over centered video (shown after interaction)
            if (_hasUserInteracted)
              Positioned(
                bottom: screenSize.height * 0.15, // Responsive positioning
                left: screenSize.width * 0.1,
                right: screenSize.width * 0.1,
                child: Text(
                  _currentText.isEmpty ? 'Loading...' : _currentText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            

            ],
          ),
        ),
      ),
    );
  }
}