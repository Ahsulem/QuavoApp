import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:confetti/confetti.dart';
import 'config/app_theme.dart';
import 'views/final_view.dart';
import 'widgets/gradient_button.dart';
import 'widgets/gradient_nav_icon.dart';
import 'widgets/gradient_card.dart';           
import 'widgets/gradient_icon_button.dart';    
import 'widgets/gradient_list_tile.dart';   
import 'package:provider/provider.dart'; 
import 'services/music_service.dart'; // ADD THIS // ADD THIS
import 'widgets/mini_player.dart'; // ADD THIS// ADD THIS  

void main() {
  runApp(const QuavoApp());
}

class QuavoApp extends StatefulWidget {
  const QuavoApp({super.key});

  @override
  State<QuavoApp> createState() => _QuavoAppState();
}

class _QuavoAppState extends State<QuavoApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(  // ADD: Wrap MaterialApp with Provider
      create: (_) => MusicService(),  // ADD: Create MusicService instance
      child: MaterialApp(  // ADD: Make MaterialApp a child of Provider
        debugShowCheckedModeBanner: false,
        title: 'QuavoApp',
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: SplashScreen(
          toggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode,
        ),
      ),  // ADD: Closing bracket for MaterialApp
    );  // ADD: Closing bracket for ChangeNotifierProvider
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(
              toggleTheme: widget.toggleTheme,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFAB47BC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.music_note, size: 100, color: Colors.white)
                  .animate()
                  .scale(duration: 600.ms)
                  .then()
                  .shimmer(duration: 1200.ms),
              const SizedBox(height: 20),
              const Text(
                'QUAVO',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
              const SizedBox(height: 10),
              const Text(
                'Your Music, Your Way',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 40),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// Sign In Page
class SignInPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SignInPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.music_note, size: 80, color: Colors.purple)
                  .animate()
                  .scale(duration: 500.ms),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(begin: -0.2),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        toggleTheme: toggleTheme,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(
                        toggleTheme: toggleTheme,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sign Up Page
class SignUpPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SignUpPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    _confettiController.play();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Congratulations! Your account has been created.'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              toggleTheme: widget.toggleTheme,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn().scale(),
                  const SizedBox(height: 40),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    onPressed: _onSignUp,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.purple,
                Colors.pink,
                Colors.yellow,
                Colors.green
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicService>(  // ADD: Wrap with Consumer
      builder: (context, musicService, child) {  // ADD: Builder
        return Scaffold(
          body: Stack(  // CHANGE: Scaffold body to Stack
            children: [  // ADD: Wrap in children array
              _buildPage(),
              
              // ADD: MiniPlayer overlay
              if (musicService.hasCurrentSong)
                Positioned(
                  bottom: 80, // Above bottom nav
                  left: 0,
                  right: 0,
                  child: MiniPlayer(
                    songTitle: musicService.currentSong!.title,
                    artistName: musicService.currentSong!.artist,
                    isPlaying: musicService.isPlaying,
                    isFavorite: musicService.currentSong!.isFavorite,
                    progress: musicService.progress,
                    onPlay: musicService.play,
                    onPause: musicService.pause,
                    onNext: musicService.next,
                    onPrevious: musicService.previous,
                    onFavorite: musicService.toggleFavorite,
                    onClose: musicService.closeMiniPlayer,
                  ),
                ),
            ],  // ADD: Close children array
          ),  // CHANGE: Close Stack instead of body
          bottomNavigationBar: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GradientNavIcon(
                  icon: Icons.home,
                  isActive: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                GradientNavIcon(
                  icon: Icons.search,
                  isActive: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                GradientNavIcon(
                  icon: Icons.favorite,
                  isActive: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                GradientNavIcon(
                  icon: Icons.dashboard,
                  isActive: _selectedIndex == 3,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ),
        );
      },  // ADD: Close builder
    );  // ADD: Close Consumer
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return HomeContent(
          isDarkMode: widget.isDarkMode,
          toggleTheme: widget.toggleTheme,
        );
      case 1:
        return const SearchPage();
      case 2:
        return const FavouritesPage();
      case 3:
        return const DashboardPage();
      default:
        return HomeContent(
          isDarkMode: widget.isDarkMode,
          toggleTheme: widget.toggleTheme,
        );
    }
  }
}

// Home Content
class HomeContent extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomeContent({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

List<Song> get _songs {
  // List all your MP3 filenames here
  final mp3Files = ['note1', 'note2', 'note3']; // Add more as needed
  
  return mp3Files.asMap().entries.map((entry) {
    final fileName = entry.value;
    return Song(
      id: fileName,
      title: fileName.replaceAll('note', 'Note '),
      artist: 'Your Artist',
      audioPath: 'assets/music/$fileName.mp3',
    );
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Good Evening!!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ).animate().fadeIn().slideX(begin: -0.2),
                  Row(
                    children: [
                      GradientIconButton(
                        icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        onPressed: toggleTheme,
                      ),
                      GradientIconButton(
                        icon: Icons.notifications_outlined,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'Recently Played',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return GradientCard(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecentsPage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.album, size: 50),
                            const SizedBox(height: 8),
                            Text('Track ${index + 1}'),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 100 * index))
                        .slideX(begin: 0.2);
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Recommended for You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GradientListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.music_note),
                    ),
                    title: Text('Song ${index + 1}'),
                    subtitle: Text('Artist ${index + 1}'),
                    trailing: GradientIconButton(
                      icon: Icons.more_vert,
                      onPressed: () {},
                      size: 20,
                    ),
                    onTap: () {},
                  )
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 100 * index))
                      .slideX(begin: 0.1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Search Page
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Songs, artists, albums...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),
            const Text(
              'Browse Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final categories = [
                    'Pop',
                    'Rock',
                    'Hip-Hop',
                    'Jazz',
                    'Classical',
                    'Electronic'
                  ];
                  return GradientCard(
                    onTap: () {},
                    margin: const EdgeInsets.all(0),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 100 * index))
                      .scale(begin: const Offset(0.8, 0.8));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Favourites Page
class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicService>(
      builder: (context, musicService, child) {
        // ADD: Define real songs
        final songs = [
          Song(
            id: 'note1',
            title: 'Note 1',
            artist: 'Your Artist',
            audioPath: 'music/note1.mp3',
            isFavorite: true,
          ),
          Song(
            id: 'note2',
            title: 'Note 2',
            artist: 'Your Artist',
            audioPath: 'music/note2.mp3',
            isFavorite: true,
          ),
          Song(
            id: 'note3',
            title: 'Note 3',
            artist: 'Your Artist',
            audioPath: 'music/note3.mp3',
            isFavorite: true,
          ),
        ];
        
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Favourites',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ).animate().fadeIn().slideX(begin: -0.2),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,  // CHANGE: Use songs.length
                    itemBuilder: (context, index) {
                      final song = songs[index];  // CHANGE: Get real song
                      
                      final isCurrentlyPlaying = 
                          musicService.currentSong?.id == song.id && 
                          musicService.isPlaying;
                      
                      return GradientListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isCurrentlyPlaying ? Icons.graphic_eq : Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        trailing: GradientIconButton(
                          icon: isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                          onPressed: () {
                            if (isCurrentlyPlaying) {
                              musicService.pause();
                            } else {
                              musicService.playSong(song);
                            }
                          },
                          size: 28,
                        ),
                        onTap: () {
                          if (isCurrentlyPlaying) {
                            musicService.pause();
                          } else {
                            musicService.playSong(song);
                          }
                        },
                      )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 80 * index))
                          .slideX(begin: 0.2);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Recents Page
class RecentsPage extends StatelessWidget {
  const RecentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicService>(
      builder: (context, musicService, child) {
        // ADD: Define real songs
        final songs = [
          Song(
            id: 'note1',
            title: 'Note 1',
            artist: 'Your Artist',
            audioPath: 'music/note1.mp3',
          ),
          Song(
            id: 'note2',
            title: 'Note 2',
            artist: 'Your Artist',
            audioPath: 'music/note2.mp3',
          ),
          Song(
            id: 'note3',
            title: 'Note 3',
            artist: 'Your Artist',
            audioPath: 'music/note3.mp3',
          ),
        ];
        
        return Scaffold(
          appBar: AppBar(title: const Text('Recently Played')),
          body: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: songs.length,  // CHANGE: Use songs.length
                itemBuilder: (context, index) {
                  final song = songs[index];  // CHANGE: Get real song
                  
                  final isCurrentlyPlaying = 
                      musicService.currentSong?.id == song.id && 
                      musicService.isPlaying;
                  
                  return GradientListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isCurrentlyPlaying ? Icons.graphic_eq : Icons.history,
                      ),
                    ),
                    title: Text(song.title),
                    subtitle: Text('Played ${index + 1}h ago'),
                    trailing: GradientIconButton(
                      icon: isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                      onPressed: () {
                        if (isCurrentlyPlaying) {
                          musicService.pause();
                        } else {
                          musicService.playSong(song);
                        }
                      },
                      size: 28,
                    ),
                    onTap: () {
                      if (isCurrentlyPlaying) {
                        musicService.pause();
                      } else {
                        musicService.playSong(song);
                      }
                    },
                  )
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 60 * index))
                      .slideX(begin: 0.1);
                },
              ),
              
              if (musicService.hasCurrentSong)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MiniPlayer(
                    songTitle: musicService.currentSong!.title,
                    artistName: musicService.currentSong!.artist,
                    isPlaying: musicService.isPlaying,
                    isFavorite: musicService.currentSong!.isFavorite,
                    progress: musicService.progress,
                    onPlay: musicService.play,
                    onPause: musicService.pause,
                    onNext: musicService.next,
                    onPrevious: musicService.previous,
                    onFavorite: musicService.toggleFavorite,
                    onClose: musicService.closeMiniPlayer,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Dashboard Page
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard 📊',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 20),
            GradientCard(
              padding: const EdgeInsets.all(20),
              child: const Column(
                children: [
                  Text(
                    'Total Listening Time',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '127 Hours',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).scale(),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildStatCard(context, 'Total Songs', '342', 0),
                  _buildStatCard(context, 'Playlists', '12', 1),
                  _buildStatCard(context, 'Artists', '89', 2),
                  _buildStatCard(context, 'Albums', '54', 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, int index) {
    return GradientCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(16),
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 100 * index))
        .scale(begin: const Offset(0.8, 0.8));
  }
}