import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quran_app/providers/audio_provider.dart';

import 'audio_provider_test.mocks.dart';

@GenerateMocks([AudioPlayer, Connectivity])
void main() {
  group('AudioProvider - Basic Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      // Mock default stream behavior
      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Initial state should be correct', () {
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.currentSurahNumber, null);
      expect(audioProvider.isBuffering, false);
      expect(audioProvider.errorMessage, null);
    });

    test('clearError should clear error message', () {
      audioProvider.clearError();
      expect(audioProvider.errorMessage, null);
    });
  });

  group('AudioProvider - State Management Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      // Mock default stream behavior
      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Initial buffering state should be false', () {
      expect(audioProvider.isBuffering, false);
    });

    test('Initial playing state should be false', () {
      expect(audioProvider.isPlaying, false);
    });

    test('Initial current surah should be null', () {
      expect(audioProvider.currentSurahNumber, null);
    });

    test('Initial error message should be null', () {
      expect(audioProvider.errorMessage, null);
    });
  });

  group('AudioProvider - Listener Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      // Mock default stream behavior
      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Should notify listeners when clearError is called', () {
      int notificationCount = 0;

      audioProvider.addListener(() {
        notificationCount++;
      });

      audioProvider.clearError();

      expect(notificationCount, greaterThan(0));
    });

    test('Should allow multiple listeners', () {
      int listener1Count = 0;
      int listener2Count = 0;

      audioProvider.addListener(() {
        listener1Count++;
      });

      audioProvider.addListener(() {
        listener2Count++;
      });

      audioProvider.clearError();

      expect(listener1Count, greaterThan(0));
      expect(listener2Count, greaterThan(0));
    });
  });

  group('AudioProvider - playSurah Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Should play surah successfully with WiFi', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);

      // Assert
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.currentSurahNumber, 1);
      expect(audioProvider.isBuffering, false);
      expect(audioProvider.errorMessage, null);
      verify(mockAudioPlayer.play(any)).called(1);
    });

    test('Should play surah successfully with Mobile Data', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(2);

      // Assert
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.currentSurahNumber, 2);
      expect(audioProvider.errorMessage, null);
      verify(mockAudioPlayer.play(any)).called(1);
    });

    test('Should play surah successfully with Ethernet', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.ethernet]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(3);

      // Assert
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.currentSurahNumber, 3);
      expect(audioProvider.errorMessage, null);
    });

    test('Should handle multiple connection types', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
      );
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);

      // Assert
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.errorMessage, null);
    });

    test('Should set buffering state during playback', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      bool wasBuffering = false;
      audioProvider.addListener(() {
        if (audioProvider.isBuffering) {
          wasBuffering = true;
        }
      });

      // Act
      await audioProvider.playSurah(1);

      // Assert
      expect(wasBuffering, true);
      expect(
        audioProvider.isBuffering,
        false,
      ); // Should be false after completion
    });

    test('Should stop previous surah before playing new one', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);
      await audioProvider.playSurah(2);

      // Assert
      expect(audioProvider.currentSurahNumber, 2);
      verify(mockAudioPlayer.stop()).called(1);
      verify(mockAudioPlayer.play(any)).called(2);
    });

    test('Should set error when no internet connection', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      await audioProvider.playSurah(1);

      // Assert
      expect(audioProvider.errorMessage, contains('لا يوجد اتصال بالإنترنت'));
      expect(audioProvider.isPlaying, false);
    });

    test('Should set error when audio playback fails', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenThrow(Exception('Playback failed'));

      // Act
      await audioProvider.playSurah(1);

      // Assert
      expect(audioProvider.errorMessage, contains('Playback failed'));
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.isBuffering, false);
    });

    test('Should handle network timeout during playback', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenThrow(Exception('TimeoutException'));

      // Act
      await audioProvider.playSurah(1);

      // Assert
      expect(audioProvider.errorMessage, contains('TimeoutException'));
      expect(audioProvider.isPlaying, false);
    });

    test('Should clear previous error when playing new surah', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // First play fails
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);
      await audioProvider.playSurah(1);
      expect(audioProvider.errorMessage, isNotNull);

      // Second play succeeds
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      await audioProvider.playSurah(2);

      // Assert
      expect(audioProvider.errorMessage, null);
    });
  });

  group('AudioProvider - pause Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Should pause successfully', () async {
      // Arrange
      when(mockAudioPlayer.pause()).thenAnswer((_) async {});

      // Act
      await audioProvider.pause();

      // Assert
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.errorMessage, null);
      verify(mockAudioPlayer.pause()).called(1);
    });

    test('Should set error when pause fails', () async {
      // Arrange
      when(mockAudioPlayer.pause()).thenThrow(Exception('Pause failed'));

      // Act
      await audioProvider.pause();

      // Assert
      expect(audioProvider.errorMessage, contains('فشل الإيقاف المؤقت'));
      verify(mockAudioPlayer.pause()).called(1);
    });

    test('Should update isPlaying state after pause', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});
      when(mockAudioPlayer.pause()).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);
      expect(audioProvider.isPlaying, true);

      await audioProvider.pause();

      // Assert
      expect(audioProvider.isPlaying, false);
    });

    test('Should pause even when nothing is playing', () async {
      // Arrange
      when(mockAudioPlayer.pause()).thenAnswer((_) async {});

      // Act
      await audioProvider.pause();

      // Assert
      expect(audioProvider.isPlaying, false);
      verify(mockAudioPlayer.pause()).called(1);
    });
  });

  group('AudioProvider - resume Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Should resume successfully', () async {
      // Arrange
      when(mockAudioPlayer.resume()).thenAnswer((_) async {});

      // Act
      await audioProvider.resume();

      // Assert
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.errorMessage, null);
      verify(mockAudioPlayer.resume()).called(1);
    });

    test('Should set error when resume fails', () async {
      // Arrange
      when(mockAudioPlayer.resume()).thenThrow(Exception('Resume failed'));

      // Act
      await audioProvider.resume();

      // Assert
      expect(audioProvider.errorMessage, contains('فشل الاستئناف'));
      verify(mockAudioPlayer.resume()).called(1);
    });

    test('Should update isPlaying state after resume', () async {
      // Arrange
      when(mockAudioPlayer.resume()).thenAnswer((_) async {});

      // Act
      await audioProvider.resume();

      // Assert
      expect(audioProvider.isPlaying, true);
    });

    test('Should resume even when nothing is playing', () async {
      // Arrange
      when(mockAudioPlayer.resume()).thenAnswer((_) async {});

      // Act
      await audioProvider.resume();

      // Assert
      expect(audioProvider.isPlaying, true);
      verify(mockAudioPlayer.resume()).called(1);
    });
  });

  group('AudioProvider - stop Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Should stop successfully', () async {
      // Arrange
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});

      // Act
      await audioProvider.stop();

      // Assert
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.currentSurahNumber, null);
      expect(audioProvider.errorMessage, null);
      verify(mockAudioPlayer.stop()).called(1);
    });

    test('Should set error when stop fails', () async {
      // Arrange
      when(mockAudioPlayer.stop()).thenThrow(Exception('Stop failed'));

      // Act
      await audioProvider.stop();

      // Assert
      expect(audioProvider.errorMessage, contains('فشل الإيقاف'));
      verify(mockAudioPlayer.stop()).called(1);
    });

    test('Should clear currentSurahNumber after stop', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);
      expect(audioProvider.currentSurahNumber, 1);

      await audioProvider.stop();

      // Assert
      expect(audioProvider.currentSurahNumber, null);
      expect(audioProvider.isPlaying, false);
    });

    test('Should stop even when nothing is playing', () async {
      // Arrange
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});

      // Act
      await audioProvider.stop();

      // Assert
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.currentSurahNumber, null);
      verify(mockAudioPlayer.stop()).called(1);
    });
  });

  group('AudioProvider - PlayerState Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;
    late StreamController<PlayerState> stateController;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();
      stateController = StreamController<PlayerState>();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => stateController.stream);

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      stateController.close();
      audioProvider.dispose();
    });

    test('Should handle PlayerState.completed', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.currentSurahNumber, 1);

      // Simulate playback completion
      stateController.add(PlayerState.completed);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.currentSurahNumber, null);
    });

    test('Should reset state when playback completes', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      bool stateUpdated = false;
      audioProvider.addListener(() {
        if (!audioProvider.isPlaying &&
            audioProvider.currentSurahNumber == null) {
          stateUpdated = true;
        }
      });

      // Act
      await audioProvider.playSurah(1);
      stateController.add(PlayerState.completed);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(stateUpdated, true);
    });
  });

  group('AudioProvider - Error Handling Tests', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('clearError should reset error message to null', () {
      audioProvider.clearError();
      expect(audioProvider.errorMessage, null);
    });

    test('Error message should remain null after clearError', () {
      audioProvider.clearError();
      audioProvider.clearError();
      expect(audioProvider.errorMessage, null);
    });
  });

  group('AudioProvider - Integration Scenarios', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test(
      'Provider should maintain consistent state after multiple operations',
      () {
        // Initial state
        expect(audioProvider.isPlaying, false);
        expect(audioProvider.isBuffering, false);
        expect(audioProvider.errorMessage, null);

        // Clear error multiple times
        audioProvider.clearError();
        audioProvider.clearError();

        // State should remain consistent
        expect(audioProvider.isPlaying, false);
        expect(audioProvider.isBuffering, false);
        expect(audioProvider.errorMessage, null);
      },
    );

    test('User plays a surah, pauses, then resumes', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});
      when(mockAudioPlayer.pause()).thenAnswer((_) async {});
      when(mockAudioPlayer.resume()).thenAnswer((_) async {});

      // Act & Assert
      // Play
      await audioProvider.playSurah(1);
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.currentSurahNumber, 1);

      // Pause
      await audioProvider.pause();
      expect(audioProvider.isPlaying, false);

      // Resume
      await audioProvider.resume();
      expect(audioProvider.isPlaying, true);
    });

    test('User switches between different surahs', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);
      expect(audioProvider.currentSurahNumber, 1);

      await audioProvider.playSurah(2);
      expect(audioProvider.currentSurahNumber, 2);

      verify(mockAudioPlayer.stop()).called(1); // Should stop previous
      verify(mockAudioPlayer.play(any)).called(2);
    });

    test('User plays, stops, then plays again', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act & Assert
      // First play
      await audioProvider.playSurah(1);
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.currentSurahNumber, 1);

      // Stop
      await audioProvider.stop();
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.currentSurahNumber, null);

      // Play again
      await audioProvider.playSurah(2);
      expect(audioProvider.isPlaying, true);
      expect(audioProvider.currentSurahNumber, 2);
    });
  });

  group('AudioProvider - Edge Cases', () {
    late AudioProvider audioProvider;
    late MockAudioPlayer mockAudioPlayer;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockConnectivity = MockConnectivity();

      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());

      audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      audioProvider.dispose();
    });

    test('Playing the same surah twice should work', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(1);
      await audioProvider.playSurah(1);

      // Assert
      expect(audioProvider.currentSurahNumber, 1);
      verify(mockAudioPlayer.play(any)).called(2);
      verify(mockAudioPlayer.stop()).called(1);
    });

    test('Calling pause before playing anything should work', () async {
      // Arrange
      when(mockAudioPlayer.pause()).thenAnswer((_) async {});

      // Act & Assert
      expect(() => audioProvider.pause(), returnsNormally);
      await audioProvider.pause();
      expect(audioProvider.isPlaying, false);
    });

    test('Calling resume before playing anything should work', () async {
      // Arrange
      when(mockAudioPlayer.resume()).thenAnswer((_) async {});

      // Act & Assert
      expect(() => audioProvider.resume(), returnsNormally);
      await audioProvider.resume();
      expect(audioProvider.isPlaying, true);
    });

    test('Calling stop before playing anything should work', () async {
      // Arrange
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});

      // Act & Assert
      expect(() => audioProvider.stop(), returnsNormally);
      await audioProvider.stop();
      expect(audioProvider.isPlaying, false);
      expect(audioProvider.currentSurahNumber, null);
    });

    test('Playing surah with number 0 should attempt to play', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(0);

      // Assert - Provider doesn't validate surah numbers, that's API's job
      verify(mockAudioPlayer.play(any)).called(1);
    });

    test('Playing surah with number 115 should attempt to play', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(115);

      // Assert - Provider doesn't validate surah numbers, that's API's job
      verify(mockAudioPlayer.play(any)).called(1);
    });

    test('Playing surah with negative number should attempt to play', () async {
      // Arrange
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(mockAudioPlayer.play(any)).thenAnswer((_) async {});

      // Act
      await audioProvider.playSurah(-1);

      // Assert - Provider doesn't validate surah numbers, that's API's job
      verify(mockAudioPlayer.play(any)).called(1);
    });
  });

  group('AudioProvider - Resource Management', () {
    test('Should properly dispose resources', () {
      final mockAudioPlayer = MockAudioPlayer();
      final mockConnectivity = MockConnectivity();
      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());
      when(mockAudioPlayer.dispose()).thenAnswer((_) async {});

      final audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );

      // Add a listener
      audioProvider.addListener(() {});

      // Dispose should not throw
      expect(() => audioProvider.dispose(), returnsNormally);
      verify(mockAudioPlayer.dispose()).called(1);
    });

    test('Should handle disposal with active listeners', () {
      final mockAudioPlayer = MockAudioPlayer();
      final mockConnectivity = MockConnectivity();
      when(
        mockAudioPlayer.onPlayerStateChanged,
      ).thenAnswer((_) => const Stream.empty());
      when(mockAudioPlayer.dispose()).thenAnswer((_) async {});

      final audioProvider = AudioProvider(
        audioPlayer: mockAudioPlayer,
        connectivity: mockConnectivity,
      );

      // Add multiple listeners
      audioProvider.addListener(() {});
      audioProvider.addListener(() {});
      audioProvider.addListener(() {});

      // Dispose should handle all listeners
      expect(() => audioProvider.dispose(), returnsNormally);
    });
  });
}

// Note: These tests provide comprehensive coverage of AudioProvider including:
// 1. Basic state management and initialization
// 2. All playback methods (play, pause, resume, stop)
// 3. Network connectivity scenarios (WiFi, Mobile, Ethernet, None)
// 4. PlayerState handling (completed state)
// 5. Error handling for all operations
// 6. Integration scenarios (user workflows)
// 7. Edge cases (invalid inputs, operations before initialization)
// 8. Resource management and disposal
