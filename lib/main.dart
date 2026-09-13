 import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AvoozaApp());
}

class AvoozaApp extends StatefulWidget {
  const AvoozaApp({super.key});

  @override
  State<AvoozaApp> createState() => _AvoozaAppState();
}

class _AvoozaAppState extends State<AvoozaApp> {
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();

    if (!mounted) return;
    setState(() {
      lang = p.getString('language') ?? 'en';
    });
  }

  Future<void> _setLang(String value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('language', value);

    if (!mounted) return;
    setState(() => lang = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AVOOZA TV 2.0',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF050817),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF745CFF),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeShell(
        lang: lang,
        onLangChanged: _setLang,
      ),
    );
  }
}

String t(String lang, String key) {
  const data = {
    'en': {
      'home': 'Home',
      'live': 'Live TV',
      'movies': 'Movies',
      'series': 'Series',
      'radio': 'Radio',
      'settings': 'Settings',
      'language': 'Language',
      'watch': 'Watch Now',
      'stories': 'A World of Stories',
      'storySub': 'Global entertainment in your language.',
      'add': 'Add M3U URL',
      'change': 'Change Playlist',
      'playlist': 'Playlist',
      'managePlaylist': 'Manage playlist',
      'search': 'Search channels...',
      'clear': 'Remove saved playlist',
      'about': 'About AVOOZA TV',
      'noChannels': 'No channels yet',
      'connect': 'Save',
      'cancel': 'Cancel',
      'channels': 'Channels',
      'playlistSaved': 'Playlist saved',
      'playlistRemoved': 'Playlist removed',
      'fullscreen': 'Full screen',
    },
    'ar': {
      'home': 'الرئيسية',
      'live': 'البث المباشر',
      'movies': 'الأفلام',
      'series': 'المسلسلات',
      'radio': 'الراديو',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'watch': 'شاهد الآن',
      'stories': 'عالم من القصص',
      'storySub': 'ترفيه عالمي بلغتك.',
      'add': 'إضافة رابط M3U',
      'change': 'تغيير القائمة',
      'playlist': 'قائمة التشغيل',
      'managePlaylist': 'إدارة قائمة التشغيل',
      'search': 'ابحث عن القنوات...',
      'clear': 'حذف القائمة المحفوظة',
      'about': 'حول AVOOZA TV',
      'noChannels': 'لا توجد قنوات',
      'connect': 'حفظ',
      'cancel': 'إلغاء',
      'channels': 'القنوات',
      'playlistSaved': 'تم حفظ القائمة',
      'playlistRemoved': 'تم حذف القائمة',
      'fullscreen': 'ملء الشاشة',
    },
    'fr': {
      'home': 'Accueil',
      'live': 'TV en direct',
      'movies': 'Films',
      'series': 'Séries',
      'radio': 'Radio',
      'settings': 'Paramètres',
      'language': 'Langue',
      'watch': 'Regarder',
      'stories': 'Un monde d’histoires',
      'storySub': 'Divertissement mondial dans votre langue.',
      'add': 'Ajouter URL M3U',
      'change': 'Changer playlist',
      'playlist': 'Playlist',
      'managePlaylist': 'Gérer la playlist',
      'search': 'Rechercher des chaînes...',
      'clear': 'Supprimer la playlist',
      'about': 'À propos de AVOOZA TV',
      'noChannels': 'Aucune chaîne',
      'connect': 'Enregistrer',
      'cancel': 'Annuler',
      'channels': 'Chaînes',
      'playlistSaved': 'Playlist enregistrée',
      'playlistRemoved': 'Playlist supprimée',
      'fullscreen': 'Plein écran',
    },
    'nl': {
      'home': 'Home',
      'live': 'Live TV',
      'movies': 'Films',
      'series': 'Series',
      'radio': 'Radio',
      'settings': 'Instellingen',
      'language': 'Taal',
      'watch': 'Nu kijken',
      'stories': 'Een wereld vol verhalen',
      'storySub': 'Wereldwijd entertainment in jouw taal.',
      'add': 'M3U URL toevoegen',
      'change': 'Playlist wijzigen',
      'playlist': 'Playlist',
      'managePlaylist': 'Playlist beheren',
      'search': 'Zoek kanalen...',
      'clear': 'Playlist verwijderen',
      'about': 'Over AVOOZA TV',
      'noChannels': 'Nog geen kanalen',
      'connect': 'Opslaan',
      'cancel': 'Annuleren',
      'channels': 'Kanalen',
      'playlistSaved': 'Playlist opgeslagen',
      'playlistRemoved': 'Playlist verwijderd',
      'fullscreen': 'Volledig scherm',
    },
    'zh': {
      'home': '首页',
      'live': '直播',
      'movies': '电影',
      'series': '剧集',
      'radio': '广播',
      'settings': '设置',
      'language': '语言',
      'watch': '立即观看',
      'stories': '故事的世界',
      'storySub': '用你的语言享受全球娱乐。',
      'add': '添加 M3U 链接',
      'change': '更改播放列表',
      'playlist': '播放列表',
      'managePlaylist': '管理播放列表',
      'search': '搜索频道...',
      'clear': '删除播放列表',
      'about': '关于 AVOOZA TV',
      'noChannels': '暂无频道',
      'connect': '保存',
      'cancel': '取消',
      'channels': '频道',
      'playlistSaved': '播放列表已保存',
      'playlistRemoved': '播放列表已删除',
      'fullscreen': '全屏',
    },
    'hi': {
      'home': 'होम',
      'live': 'लाइव टीवी',
      'movies': 'फ़िल्में',
      'series': 'सीरीज़',
      'radio': 'रेडियो',
      'settings': 'सेटिंग्स',
      'language': 'भाषा',
      'watch': 'अभी देखें',
      'stories': 'कहानियों की दुनिया',
      'storySub': 'आपकी भाषा में वैश्विक मनोरंजन।',
      'add': 'M3U URL जोड़ें',
      'change': 'प्लेलिस्ट बदलें',
      'playlist': 'प्लेलिस्ट',
      'managePlaylist': 'प्लेलिस्ट प्रबंधित करें',
      'search': 'चैनल खोजें...',
      'clear': 'प्लेलिस्ट हटाएँ',
      'about': 'AVOOZA TV के बारे में',
      'noChannels': 'अभी कोई चैनल नहीं',
      'connect': 'सेव करें',
      'cancel': 'रद्द करें',
      'channels': 'चैनल',
      'playlistSaved': 'प्लेलिस्ट सेव हुई',
      'playlistRemoved': 'प्लेलिस्ट हटाई गई',
      'fullscreen': 'फुल स्क्रीन',
    },
  };

  return data[lang]?[key] ?? data['en']![key] ?? key;
}

// =======================================================
// CHANNEL
// =======================================================

class Channel {
  final String name;
  final String url;
  final String group;
  final String logo;

  const Channel({
    required this.name,
    required this.url,
    required this.group,
    required this.logo,
  });
}

// =======================================================
// HOME SHELL
// =======================================================

class HomeShell extends StatefulWidget {
  final String lang;
  final ValueChanged<String> onLangChanged;

  const HomeShell({
    super.key,
    required this.lang,
    required this.onLangChanged,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final GlobalKey<_LivePageState> liveKey = GlobalKey<_LivePageState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        lang: widget.lang,
        openTab: (i) => setState(() => index = i),
      ),
      LivePage(
        key: liveKey,
        lang: widget.lang,
      ),
      PlaceholderPage(
        title: t(widget.lang, 'movies'),
        icon: Icons.movie_rounded,
      ),
      PlaceholderPage(
        title: t(widget.lang, 'series'),
        icon: Icons.video_library_rounded,
      ),
      RadioPage(lang: widget.lang),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B1B),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF745CFF),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'AVOOZA TV 2.0',
                style: TextStyle(fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _language,
            icon: const Icon(Icons.language_rounded),
          ),
          IconButton(
            onPressed: _settings,
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: NeonBackground(
        child: IndexedStack(
          index: index,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          setState(() => index = i);
        },
        backgroundColor: const Color(0xFF070B1B),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: t(widget.lang, 'home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.live_tv_outlined),
            selectedIcon: const Icon(Icons.live_tv_rounded),
            label: t(widget.lang, 'live'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.movie_outlined),
            selectedIcon: const Icon(Icons.movie_rounded),
            label: t(widget.lang, 'movies'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.video_library_outlined),
            selectedIcon: const Icon(Icons.video_library_rounded),
            label: t(widget.lang, 'series'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.radio_outlined),
            selectedIcon: const Icon(Icons.radio_rounded),
            label: t(widget.lang, 'radio'),
          ),
        ],
      ),
    );
  }

  void _language() {
    const langs = {
      'en': 'English',
      'ar': 'العربية',
      'fr': 'Français',
      'nl': 'Nederlands',
      'zh': '中文',
      'hi': 'हिन्दी',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1128),
      builder: (_) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: langs.entries.map((e) {
              return ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(e.value),
                trailing: widget.lang == e.key
                    ? const Icon(Icons.check_circle_rounded)
                    : null,
                onTap: () {
                  widget.onLangChanged(e.key);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _settings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsPage(
          lang: widget.lang,
          onLangChanged: widget.onLangChanged,
        ),
      ),
    );

    liveKey.currentState?.reloadFromPrefs();
  }
}

// =======================================================
// BACKGROUND
// =======================================================

class NeonBackground extends StatelessWidget {
  final Widget child;

  const NeonBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF050817),
            Color(0xFF0C1230),
            Color(0xFF160B36),
          ],
        ),
      ),
      child: child,
    );
  }
}

// =======================================================
// HOME
// =======================================================

class HomePage extends StatelessWidget {
  final String lang;
  final ValueChanged<int> openTab;

  const HomePage({
    super.key,
    required this.lang,
    required this.openTab,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF10204C),
                  Color(0xFF122D64),
                  Color(0xFF32115D),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(lang, 'stories'),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t(lang, 'storySub'),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => openTab(1),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(t(lang, 'watch')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.15,
            children: [
              _tile(
                t(lang, 'live'),
                Icons.live_tv_rounded,
                const [
                  Color(0xFF0066FF),
                  Color(0xFF00C6FF),
                ],
                () => openTab(1),
              ),
              _tile(
                t(lang, 'movies'),
                Icons.movie_rounded,
                const [
                  Color(0xFF7F00FF),
                  Color(0xFFE100FF),
                ],
                () => openTab(2),
              ),
              _tile(
                t(lang, 'series'),
                Icons.video_library_rounded,
                const [
                  Color(0xFFB400FF),
                  Color(0xFFFF4D96),
                ],
                () => openTab(3),
              ),
              _tile(
                t(lang, 'radio'),
                Icons.radio_rounded,
                const [
                  Color(0xFFFF7A18),
                  Color(0xFFFFB74D),
                ],
                () => openTab(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tile(
    String title,
    IconData icon,
    List<Color> colors,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: colors),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// CHANNEL LOGO
// =======================================================

class ChannelLogo extends StatelessWidget {
  final Channel channel;
  final double size;

  const ChannelLogo({
    super.key,
    required this.channel,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: channel.logo.trim().isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                channel.logo,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _fallback(),
              ),
            )
          : _fallback(),
    );
  }

  Widget _fallback() {
    return const Icon(
      Icons.live_tv_rounded,
      color: Color(0xFF745CFF),
    );
  }
}

// =======================================================
// LIVE TV
// =======================================================

class LivePage extends StatefulWidget {
  final String lang;

  const LivePage({
    super.key,
    required this.lang,
  });

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final search = TextEditingController();

  List<Channel> all = [];
  List<Channel> visible = [];

  bool loading = false;
  String currentPlaylist = '';

  @override
  void initState() {
    super.initState();
    reloadFromPrefs();
    search.addListener(_filter);
  }

  @override
  void dispose() {
    search.removeListener(_filter);
    search.dispose();
    super.dispose();
  }

  Future<void> reloadFromPrefs() async {
    final p = await SharedPreferences.getInstance();
    final saved = p.getString('m3u_url') ?? '';

    if (saved.isEmpty) {
      if (!mounted) return;

      setState(() {
        currentPlaylist = '';
        all = [];
        visible = [];
        loading = false;
      });

      return;
    }

    if (saved == currentPlaylist && all.isNotEmpty) return;

    currentPlaylist = saved;
    await _load(saved);
  }

  void _filter() {
    final q = search.text.toLowerCase().trim();

    if (!mounted) return;

    setState(() {
      if (q.isEmpty) {
        visible = List.from(all);
      } else {
        visible = all.where((c) {
          return c.name.toLowerCase().contains(q) ||
              c.group.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  Future<http.Response> _get(String url) async {
    try {
      return await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'AVOOZA-TV/2.0',
          'Accept': '*/*',
        },
      );
    } catch (e) {
      final s = e.toString().toLowerCase();

      if (url.startsWith('https://') &&
          (s.contains('wrong_version_number') ||
              s.contains('handshake') ||
              s.contains('ssl'))) {
        return http.get(
          Uri.parse(
            url.replaceFirst('https://', 'http://'),
          ),
        );
      }

      rethrow;
    }
  }

  String _attribute(String line, String name) {
    final match = RegExp(
      '$name="([^"]*)"',
      caseSensitive: false,
    ).firstMatch(line);

    return match?.group(1)?.trim() ?? '';
  }

  Future<void> _load(String url) async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final r = await _get(url);

      if (r.statusCode != 200) {
        throw Exception('HTTP ${r.statusCode}');
      }

      // مهم لإصلاح الأسماء العربية والفرنسية والرموز.
      final body = utf8.decode(
        r.bodyBytes,
        allowMalformed: true,
      );

      final lines = const LineSplitter().convert(body);
      final result = <Channel>[];

      String name = '';
      String group = '';
      String logo = '';

      for (final raw in lines) {
        final line = raw.trim();

        if (line.isEmpty) continue;

        if (line.startsWith('#EXTINF')) {
          group = _attribute(line, 'group-title');
          logo = _attribute(line, 'tvg-logo');

          final comma = line.lastIndexOf(',');

          if (comma >= 0 && comma < line.length - 1) {
            name = line.substring(comma + 1).trim();
          } else {
            name = 'Channel ${result.length + 1}';
          }
        } else if (line.startsWith('http://') ||
            line.startsWith('https://')) {
          result.add(
            Channel(
              name: name.isEmpty
                  ? 'Channel ${result.length + 1}'
                  : name,
              url: line,
              group: group,
              logo: logo,
            ),
          );

          name = '';
          group = '';
          logo = '';
        }
      }

      if (!mounted) return;

      setState(() {
        all = result;
        visible = List.from(result);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playlist error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (all.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: TextField(
              controller: search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: t(widget.lang, 'search'),
                filled: true,
                fillColor: Colors.white.withOpacity(.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),

        Expanded(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : visible.isEmpty
                  ? _empty()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final c = visible[i];
                        final actual = all.indexOf(c);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          tileColor: Colors.white.withOpacity(.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          leading: ChannelLogo(
                            channel: c,
                            size: 54,
                          ),
                          title: Text(
                            c.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: c.group.isNotEmpty
                              ? Text(
                                  c.group,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF745CFF),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerPage(
                                  lang: widget.lang,
                                  channels: all,
                                  initialIndex: actual,
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

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.live_tv_rounded,
              size: 72,
              color: Color(0xFF745CFF),
            ),
            const SizedBox(height: 16),
            Text(
              t(widget.lang, 'noChannels'),
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.lang == 'ar'
                  ? 'أضف قائمة التشغيل من الإعدادات ⚙️'
                  : widget.lang == 'fr'
                      ? 'Ajoutez votre playlist depuis les paramètres ⚙️'
                      : widget.lang == 'nl'
                          ? 'Voeg je playlist toe via Instellingen ⚙️'
                          : 'Add your playlist from Settings ⚙️',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// PLAYER
// =======================================================

class PlayerPage extends StatefulWidget {
  final String lang;
  final List<Channel> channels;
  final int initialIndex;

  const PlayerPage({
    super.key,
    required this.lang,
    required this.channels,
    required this.initialIndex,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late int index;

  VideoPlayerController? controller;

  bool loading = true;
  bool showControls = true;
  bool fullscreen = false;

  String? error;

  Timer? controlsTimer;

  Channel get current => widget.channels[index];

  @override
  void initState() {
    super.initState();

    index = widget.initialIndex;
    _play();
  }

  @override
  void dispose() {
    controlsTimer?.cancel();
    controller?.dispose();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setPreferredOrientations(
      DeviceOrientation.values,
    );

    super.dispose();
  }

  void _startControlsTimer() {
    controlsTimer?.cancel();

    controlsTimer = Timer(
      const Duration(seconds: 4),
      () {
        if (mounted) {
          setState(() => showControls = false);
        }
      },
    );
  }

  void _toggleControls() {
    setState(() {
      showControls = !showControls;
    });

    if (showControls) {
      _startControlsTimer();
    }
  }

  Future<void> _play() async {
    controlsTimer?.cancel();

    if (mounted) {
      setState(() {
        loading = true;
        error = null;
        showControls = true;
      });
    }

    await controller?.dispose();

    try {
      final c = VideoPlayerController.networkUrl(
        Uri.parse(current.url),
      );

      controller = c;

      await c.initialize();
      await c.play();

      if (!mounted) return;

      setState(() => loading = false);

      _startControlsTimer();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  Future<void> _change(int i) async {
    if (i < 0 || i >= widget.channels.length) return;

    setState(() => index = i);

    await _play();
  }

  Future<void> _toggleFullscreen() async {
    if (!fullscreen) {
      setState(() => fullscreen = true);

      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      setState(() => fullscreen = false);

      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _picker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1024),
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.live_tv_rounded),
                      const SizedBox(width: 10),
                      Text(
                        t(widget.lang, 'channels'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.channels.length,
                    itemBuilder: (_, i) {
                      final channel = widget.channels[i];

                      return ListTile(
                        leading: ChannelLogo(
                          channel: channel,
                          size: 44,
                        ),
                        title: Text(
                          channel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: channel.group.isNotEmpty
                            ? Text(
                                channel.group,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        trailing: i == index
                            ? const Icon(
                                Icons.play_circle_fill_rounded,
                                color: Color(0xFF8C74FF),
                              )
                            : const Icon(
                                Icons.play_arrow_rounded,
                              ),
                        onTap: () {
                          Navigator.pop(context);
                          _change(i);
                        },
                      );
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

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (fullscreen || landscape) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: false,
          bottom: false,
          child: _videoPlayer(full: true),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B1B),
        title: Row(
          children: [
            ChannelLogo(
              channel: current,
              size: 38,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                current.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _picker,
            icon: const Icon(Icons.format_list_bulleted_rounded),
          ),
        ],
      ),
      body: NeonBackground(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _videoPlayer(),
              ),
            ),

            // شريط تغيير القناة الجديد
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.30),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(.10),
                ),
              ),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: index > 0
                        ? () => _change(index - 1)
                        : null,
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: InkWell(
                      onTap: _picker,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            Text(
                              current.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (current.group.isNotEmpty)
                              Text(
                                current.group,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(.6),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton.filledTonal(
                    onPressed: index <
                            widget.channels.length - 1
                        ? () => _change(index + 1)
                        : null,
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoPlayer({bool full = false}) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 55,
              ),
              const SizedBox(height: 12),
              const Text(
                'Unable to play this channel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _play,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final c = controller;

    if (c == null || !c.value.isInitialized) {
      return const SizedBox();
    }

    final video = GestureDetector(
      onTap: _toggleControls,
      onDoubleTap: _toggleFullscreen,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: c.value.aspectRatio <= 0
                  ? 16 / 9
                  : c.value.aspectRatio,
              child: VideoPlayer(c),
            ),
          ),

          AnimatedOpacity(
            opacity: showControls ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !showControls,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.55),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(.65),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 18,
                      left: 18,
                      right: 18,
                      child: Row(
                        children: [
                          ChannelLogo(
                            channel: current,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              current.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Center(
                      child: IconButton.filled(
                        onPressed: () {
                          if (c.value.isPlaying) {
                            c.pause();
                          } else {
                            c.play();
                          }

                          setState(() {});
                          _startControlsTimer();
                        },
                        iconSize: 40,
                        icon: Icon(
                          c.value.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 18,
                      child: Row(
                        children: [
                          IconButton.filledTonal(
                            onPressed: index > 0
                                ? () => _change(index - 1)
                                : null,
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                            ),
                          ),

                          const SizedBox(width: 8),

                          IconButton.filledTonal(
                            onPressed: _picker,
                            icon: const Icon(
                              Icons.format_list_bulleted_rounded,
                            ),
                          ),

                          const Spacer(),

                          IconButton.filledTonal(
                            onPressed: index <
                                    widget.channels.length - 1
                                ? () => _change(index + 1)
                                : null,
                            icon: const Icon(
                              Icons.skip_next_rounded,
                            ),
                          ),

                          const SizedBox(width: 8),

                          IconButton.filled(
                            onPressed: _toggleFullscreen,
                            icon: Icon(
                              fullscreen
                                  ? Icons.fullscreen_exit_rounded
                                  : Icons.fullscreen_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (full) {
      return video;
    }

    return Container(
      margin: const EdgeInsets.all(12),
      constraints: const BoxConstraints(
        maxWidth: 1000,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: video,
        ),
      ),
    );
  }
}

// =======================================================
// PLACEHOLDER MOVIES/SERIES
// =======================================================

class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 72,
            color: const Color(0xFF7B5CFF),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Xtream/VOD connection comes next.',
          ),
        ],
      ),
    );
  }
}

// =======================================================
// RADIO
// =======================================================

class RadioPage extends StatelessWidget {
  final String lang;

  const RadioPage({
    super.key,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    const stations = [
      (
        'Avooza Hits',
        Icons.graphic_eq_rounded,
        [
          Color(0xFFFF6A00),
          Color(0xFFEE0979),
        ]
      ),
      (
        'News 24',
        Icons.campaign_rounded,
        [
          Color(0xFF0575E6),
          Color(0xFF021B79),
        ]
      ),
      (
        'Quran Radio',
        Icons.radio_rounded,
        [
          Color(0xFF11998E),
          Color(0xFF38EF7D),
        ]
      ),
      (
        'Chill Beats',
        Icons.headphones_rounded,
        [
          Color(0xFF8E2DE2),
          Color(0xFF4A00E0),
        ]
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, i) {
        final s = stations[i];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: s.$3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(s.$2, size: 36),
              const Spacer(),
              Text(
                s.$1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =======================================================
// SETTINGS
// =======================================================

class SettingsPage extends StatefulWidget {
  final String lang;
  final ValueChanged<String> onLangChanged;

  const SettingsPage({
    super.key,
    required this.lang,
    required this.onLangChanged,
  });

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String lang;

  @override
  void initState() {
    super.initState();
    lang = widget.lang;
  }

  Future<void> _playlistDialog() async {
    final p = await SharedPreferences.getInstance();

    final controller = TextEditingController(
      text: p.getString('m3u_url') ?? '',
    );

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            t(lang, 'managePlaylist'),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.url,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: t(lang, 'playlist'),
              hintText:
                  'http://example.com/playlist.m3u',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                t(lang, 'cancel'),
              ),
            ),
            FilledButton.icon(
              icon: const Icon(
                Icons.save_rounded,
              ),
              onPressed: () async {
                final url =
                    controller.text.trim();

                if (url.isEmpty) return;

                final prefs =
                    await SharedPreferences.getInstance();

                await prefs.setString(
                  'm3u_url',
                  url,
                );

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      t(lang, 'playlistSaved'),
                    ),
                  ),
                );
              },
              label: Text(
                t(lang, 'connect'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removePlaylist() async {
    final p = await SharedPreferences.getInstance();

    await p.remove('m3u_url');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t(lang, 'playlistRemoved'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t(lang, 'settings'),
        ),
      ),
      body: NeonBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: lang,
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
              onChanged: (v) {
                if (v == null) return;

                setState(() => lang = v);

                widget.onLangChanged(v);
              },
              decoration: InputDecoration(
                labelText: t(lang, 'language'),
                border:
                    const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // PLAYLIST أصبحت هنا فقط
            ListTile(
              tileColor:
                  Colors.white.withOpacity(.06),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              leading: const CircleAvatar(
                backgroundColor:
                    Color(0xFF745CFF),
                child: Icon(
                  Icons.playlist_play_rounded,
                  color: Colors.white,
                ),
              ),
              title: Text(
                t(lang, 'managePlaylist'),
              ),
              subtitle: Text(
                t(lang, 'add'),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
              ),
              onTap: _playlistDialog,
            ),

            const SizedBox(height: 12),

            ListTile(
              tileColor:
                  Colors.white.withOpacity(.05),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              leading: const Icon(
                Icons.delete_forever_rounded,
              ),
              title: Text(
                t(lang, 'clear'),
              ),
              onTap: _removePlaylist,
            ),

            const SizedBox(height: 12),

            ListTile(
              tileColor:
                  Colors.white.withOpacity(.05),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              leading: const Icon(
                Icons.info_outline_rounded,
              ),
              title: Text(
                t(lang, 'about'),
              ),
              subtitle:
                  const Text('Version 2.0'),
            ),
          ],
        ),
      ),
    );
  }
} 
