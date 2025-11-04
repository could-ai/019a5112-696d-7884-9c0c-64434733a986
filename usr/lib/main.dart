import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const JoyPopApp());
}

class JoyPopApp extends StatelessWidget {
  const JoyPopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JoyPop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF89CFF0), // Azul claro
          primary: const Color(0xFF89CFF0), // Azul claro
          secondary: const Color(0xFFF4C2C2), // Rosa
          tertiary: const Color(0xFFFFFACD), // Amarelo
          onPrimary: Colors.white,
          background: Colors.white,
        ),
        fontFamily: 'Rounded',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const <Widget>[
          VideoFeedScreen(),
          DiscoverScreen(),
          RewardsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF89CFF0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Descobrir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Recompensas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class VideoFeedScreen extends StatelessWidget {
  const VideoFeedScreen({super.key});

  static final List<Map<String, String>> _videos = [
    {
      "url": "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      "username": "@naturezaKids",
      "description": "Abelhinha ocupada coletando néctar! 🐝🌼 #abelha #natureza #kids"
    },
    {
      "url": "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      "username": "@mundoAnimal",
      "description": "Que borboleta linda! Você sabe a cor dela? 🦋 #borboleta #insetos #cores"
    },
    {
      "url": "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      "username": "@discoveryJoy",
      "description": "Voando alto com nossa amiga abelha! #diversao #aventura"
    },
    {
      "url": "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      "username": "@brincandoAprendo",
      "description": "As asas da borboleta parecem uma pintura! 🎨 #arte #natureza #aprender"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final videoData = _videos[index];
        return VideoPlayerItem(
          key: Key(videoData["url"]! + index.toString()),
          videoUrl: videoData["url"]!,
          username: videoData["username"]!,
          description: videoData["description"]!,
        );
      },
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String username;
  final String description;

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    required this.username,
    required this.description,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        // Autoplay when the widget is visible
        _controller.play();
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlaying() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlaying,
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          if (!_isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                size: 80,
                color: Colors.white54,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: VideoDetails(
                    username: widget.username,
                    description: widget.description,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    VideoActionButton(icon: Icons.favorite, label: '1.2k'),
                    SizedBox(height: 16),
                    VideoActionButton(icon: Icons.comment, label: '256'),
                    SizedBox(height: 16),
                    VideoActionButton(icon: Icons.share, label: 'Compartilhar'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoDetails extends StatelessWidget {
  final String username;
  final String description;

  const VideoDetails({
    super.key,
    required this.username,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [Shadow(blurRadius: 2.0, color: Colors.black54)],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            shadows: [Shadow(blurRadius: 2.0, color: Colors.black54)],
          ),
        ),
      ],
    );
  }
}

class VideoActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const VideoActionButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 35, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

// Placeholder Screens
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tela de Descoberta', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tela de Recompensas', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tela de Perfil', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
