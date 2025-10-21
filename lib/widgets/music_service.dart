import 'package:flutter/material.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.isFavorite = false,
  });
}

class MusicService extends ChangeNotifier {
  Song? _currentSong;
  bool _isPlaying = false;
  double _progress = 0.0;
  final List<Song> _queue = [];
  int _currentIndex = -1;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  bool get hasCurrentSong => _currentSong != null;

  void playSong(Song song) {
    if (_currentSong?.id != song.id) {
      _currentSong = song;
      _progress = 0.0;
      _isPlaying = true;
      
      // Add to queue if not already there
      if (!_queue.any((s) => s.id == song.id)) {
        _queue.add(song);
        _currentIndex = _queue.length - 1;
      } else {
        _currentIndex = _queue.indexWhere((s) => s.id == song.id);
      }
      
      _startProgressSimulation();
      notifyListeners();
    } else {
      play();
    }
  }

  void play() {
    _isPlaying = true;
    _startProgressSimulation();
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void next() {
    if (_queue.isEmpty) return;
    
    _currentIndex = (_currentIndex + 1) % _queue.length;
    _currentSong = _queue[_currentIndex];
    _progress = 0.0;
    _isPlaying = true;
    _startProgressSimulation();
    notifyListeners();
  }

  void previous() {
    if (_queue.isEmpty) return;
    
    _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
    _currentSong = _queue[_currentIndex];
    _progress = 0.0;
    _isPlaying = true;
    _startProgressSimulation();
    notifyListeners();
  }

  void toggleFavorite() {
    if (_currentSong != null) {
      _currentSong!.isFavorite = !_currentSong!.isFavorite;
      notifyListeners();
    }
  }

  void closeMiniPlayer() {
    _currentSong = null;
    _isPlaying = false;
    _progress = 0.0;
    notifyListeners();
  }

  // Simulate progress (replace with actual audio player logic)
  void _startProgressSimulation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_isPlaying && _progress < 1.0) {
        _progress += 0.002; // Simulates ~3 minute song
        notifyListeners();
        return true;
      }
      
      if (_progress >= 1.0) {
        next(); // Auto-play next song
        return false;
      }
      
      return false;
    });
  }
}