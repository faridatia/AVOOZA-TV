import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const AvoozaApp());
}

class AvoozaApp extends StatefulWidget {
  const AvoozaApp({super.key});

  @override
  State<AvoozaApp> createState() => _AvoozaAppState();
}

class _AvoozaAppState extends State<AvoozaApp> {
  String language = 'en';

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> changeLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);

    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AVOOZA TV',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080B16),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF754CFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(
        language: language,
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}

class Channel {
  final String name;
  final String url;

  Channel({
    required this.name,
    required this.url,
  });
}

class HomeScreen extends StatefulWidget {
  final String language;
  final Function(String) onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Channel> channels = [];
  bool loading = false;

  Future<void> openM3UDialog() async {
    final controller = TextEditingController();

    final prefs = await SharedPreferences.getInstance();
    controller.text = prefs.getString('m3u_url') ?? '';

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add M3U URL'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'M3U URL',
              hintText: 'https://example.com/playlist.m3u',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final url = controller.text.trim();

                if (url.isEmpty) return;

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('m3u_url', url);

                if (!mounted) return;
                Navigator.pop(context);

                await loadM3U(url);
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadM3U(String url) async {
    setState(() {
      loading = true;
      channels = [];
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Unable to load playlist');
      }

      final lines = response.body.split('\n');
      final result = <Channel>[];

      String? currentName;

      for (final rawLine in lines) {
        final line = rawLine.trim();

        if (line.startsWith('#EXTINF')) {
          final comma = line.lastIndexOf(',');

          if (comma != -1 && comma < line.length - 1) {
            currentName = line.substring(comma + 1).trim();
          } else {
            currentName = 'Channel';
          }
        } else if (line.startsWith('http://') ||
            line.startsWith('https://')) {
          result.add(
            Channel(
              name: currentName ?? 'Channel ${result.length + 1}',
              url: line,
            ),
          );

          currentName = null;
        }
      }

      setState(() {
        channels = result;
      });

      if (result.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No channels found in this M3U playlist'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          language: widget.language,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AVOOZA TV',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: openSettings,
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : channels.isEmpty
              ? buildWelcome()
              : buildChannels(),
    );
  }

  Widget buildWelcome() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount:
                MediaQuery.of(context).size.width > 700 ? 2 : 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.2,
            children: [
              menuCard(
                title: 'M3U URL',
                subtitle: 'Add your playlist link',
                icon: Icons.link_rounded,
                onTap: openM3UDialog,
              ),
              menuCard(
                title: 'Live TV',
                subtitle: 'Your channels will appear here',
                icon: Icons.live_tv_rounded,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final savedUrl = prefs.getString('m3u_url');

                  if (savedUrl == null || savedUrl.isEmpty) {
                    openM3UDialog();
                  } else {
                    loadM3U(savedUrl);
                  }
                },
              ),
              menuCard(
                title: 'Movies',
                subtitle: 'Coming next',
                icon: Icons.movie_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Movies will be added next'),
                    ),
                  );
                },
              ),
              menuCard(
                title: 'Series',
                subtitle: 'Coming next',
                icon: Icons.video_library_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Series will be added next'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF754CFF).withOpacity(.35),
              const Color(0xFF0DBDFF).withOpacity(.14),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 52,
              color: const Color(0xFF9F8DFF),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.65),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  Widget buildChannels() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(
            children: [
              Text(
                'Live TV (${channels.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: openM3UDialog,
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Change playlist'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: channels.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final channel = channels[index];

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.live_tv_rounded),
                ),
                title: Text(channel.name),
                subtitle: Text(
                  channel.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.play_arrow_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        channel: channel,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class PlayerScreen extends StatefulWidget {
  final Channel channel;

  const PlayerScreen({
    super.key,
    required this.channel,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? controller;
  bool error = false;

  @override
  void initState() {
    super.initState();
    startPlayer();
  }

  Future<void> startPlayer() async {
    try {
      final c = VideoPlayerController.networkUrl(
        Uri.parse(widget.channel.url),
      );

      controller = c;

      await c.initialize();
      await c.play();

      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          error = true;
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.name),
      ),
      body: Center(
        child: error
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'This stream could not be played.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : controller == null || !controller!.value.isInitialized
                ? const CircularProgressIndicator()
                : AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  ),
      ),
      floatingActionButton:
          controller != null && controller!.value.isInitialized
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (controller!.value.isPlaying) {
                        controller!.pause();
                      } else {
                        controller!.play();
                      }
                    });
                  },
                  child: Icon(
                    controller!.value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                )
              : null,
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final String language;
  final Function(String) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.language;
  }

  Future<void> clearPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('m3u_url');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playlist removed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Language',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedLanguage,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'ar',
                child: Text('العربية'),
              ),
              DropdownMenuItem(
                value: 'fr',
                child: Text('Français'),
              ),
              DropdownMenuItem(
                value: 'nl',
                child: Text('Nederlands'),
              ),
              DropdownMenuItem(
                value: 'zh',
                child: Text('中文'),
              ),
              DropdownMenuItem(
                value: 'hi',
                child: Text('हिन्दी'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedLanguage = value;
              });

              widget.onLanguageChanged(value);
            },
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.playlist_remove_rounded),
            title: const Text('Remove saved playlist'),
            subtitle: const Text(
              'Delete the saved M3U URL from this device',
            ),
            onTap: clearPlaylist,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('About AVOOZA TV'),
            subtitle: Text('Version 1.0'),
          ),
        ],
      ),
    );
  }
}
