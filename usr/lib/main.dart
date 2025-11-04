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
        fontFamily: 'Nunito',
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
            icon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Descobrir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Recompensas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
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
      "url": "https://assets.mixkit.co/videos/preview/mixkit-little-girl-running-in-a-meadow-1052-large.mp4",
      "username": "@diaDeSol",
      "description": "Correndo e brincando no campo! 😄 #diversao #criança #brincadeira"
    },
    {
      "url": "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      "username": "@mundoAnimal",
      "description": "Que borboleta linda! Você sabe a cor dela? 🦋 #borboleta #insetos #cores"
    },
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-family-baking-together-in-the-kitchen-45284-large.mp4",
      "username": "@chefMirim",
      "description": "Hoje é dia de bolo na cozinha da vovó! 🎂 #cozinha #familia #bolo"
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
                Icons.play_arrow_rounded,
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
                    VideoActionButton(icon: Icons.comment_rounded, label: '256'),
                    SizedBox(height: 16),
                    VideoActionButton(icon: Icons.share_rounded, label: 'Compartilhar'),
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
    final List<Map<String, dynamic>> categories = [
      {'color': const Color(0xFF89CFF0), 'title': 'Animais', 'icon': Icons.pets},
      {'color': const Color(0xFFF4C2C2), 'title': 'Músicas', 'icon': Icons.music_note},
      {'color': const Color(0xFFFFFACD), 'title': 'Aprender', 'icon': Icons.school},
      {'color': Colors.purple.shade100, 'title': 'Desenhos', 'icon': Icons.brush},
      {'color': Colors.orange.shade200, 'title': 'Brinquedos', 'icon': Icons.toys},
      {'color': Colors.green.shade200, 'title': 'Natureza', 'icon': Icons.eco},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            color: category['color'],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'], size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  category['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Recompensas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFACD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star_rounded, color: Colors.orange, size: 40),
                  SizedBox(width: 16),
                  Text(
                    '1,250 JoyStars',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Prêmios para desbloquear:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  RewardItem(
                    icon: Icons.face_retouching_natural,
                    title: 'Avatar "Super Herói"',
                    cost: '500 JoyStars',
                    color: Color(0xFF89CFF0),
                  ),
                  RewardItem(
                    icon: Icons.emoji_emotions,
                    title: 'Pacote de Adesivos Divertidos',
                    cost: '300 JoyStars',
                    color: Color(0xFFF4C2C2),
                  ),
                  RewardItem(
                    icon: Icons.color_lens,
                    title: 'Tema de Fundo "Espacial"',
                    cost: '800 JoyStars',
                    color: Color(0xFFC3B1E1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String cost;
  final Color color;

  const RewardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.cost,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(cost),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Trocar'),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF89CFF0),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            '@criançaFeliz',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ProfileStat(count: '15', label: 'Vídeos'),
              ProfileStat(count: '1.2K', label: 'Likes'),
              ProfileStat(count: '250', label: 'Amigos'),
            ],
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9, // Placeholder for user's videos
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage('https://picsum.photos/200?random=1'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String count;
  final String label;
  const ProfileStat({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
