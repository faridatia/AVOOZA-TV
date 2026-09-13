
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
    setState(() => lang = p.getString('language') ?? 'en');
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
      home: HomeShell(lang: lang, onLangChanged: _setLang),
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
      'search': 'Search...',
      'channels': 'Channels',
      'categories': 'Categories',
      'all': 'All',
      'addM3u': 'Add / Change M3U',
      'xtream': 'Xtream Codes',
      'server': 'Server URL',
      'username': 'Username',
      'password': 'Password',
      'save': 'Save',
      'cancel': 'Cancel',
      'removeM3u': 'Remove M3U',
      'removeXtream': 'Remove Xtream account',
      'about': 'About AVOOZA TV',
      'noContent': 'No content available',
      'retry': 'Retry',
      'season': 'Season',
      'episodes': 'Episodes',
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
      'search': 'بحث...',
      'channels': 'القنوات',
      'categories': 'الباقات والتصنيفات',
      'all': 'الكل',
      'addM3u': 'إضافة / تغيير M3U',
      'xtream': 'Xtream Codes',
      'server': 'رابط السيرفر',
      'username': 'اسم المستخدم',
      'password': 'كلمة المرور',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'removeM3u': 'حذف M3U',
      'removeXtream': 'حذف حساب Xtream',
      'about': 'حول AVOOZA TV',
      'noContent': 'لا يوجد محتوى',
      'retry': 'إعادة المحاولة',
      'season': 'الموسم',
      'episodes': 'الحلقات',
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
      'search': 'Rechercher...',
      'channels': 'Chaînes',
      'categories': 'Bouquets et catégories',
      'all': 'Tout',
      'addM3u': 'Ajouter / modifier M3U',
      'xtream': 'Xtream Codes',
      'server': 'URL du serveur',
      'username': 'Nom d’utilisateur',
      'password': 'Mot de passe',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'removeM3u': 'Supprimer M3U',
      'removeXtream': 'Supprimer le compte Xtream',
      'about': 'À propos de AVOOZA TV',
      'noContent': 'Aucun contenu disponible',
      'retry': 'Réessayer',
      'season': 'Saison',
      'episodes': 'Épisodes',
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
      'search': 'Zoeken...',
      'channels': 'Kanalen',
      'categories': 'Pakketten en categorieën',
      'all': 'Alles',
      'addM3u': 'M3U toevoegen / wijzigen',
      'xtream': 'Xtream Codes',
      'server': 'Server URL',
      'username': 'Gebruikersnaam',
      'password': 'Wachtwoord',
      'save': 'Opslaan',
      'cancel': 'Annuleren',
      'removeM3u': 'M3U verwijderen',
      'removeXtream': 'Xtream-account verwijderen',
      'about': 'Over AVOOZA TV',
      'noContent': 'Geen inhoud beschikbaar',
      'retry': 'Opnieuw proberen',
      'season': 'Seizoen',
      'episodes': 'Afleveringen',
    },
  };
  return data[lang]?[key] ?? data['en']![key] ?? key;
}

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

class XtreamAccount {
  final String server;
  final String username;
  final String password;

  const XtreamAccount({
    required this.server,
    required this.username,
    required this.password,
  });

  String get cleanServer {
    var s = server.trim();
    while (s.endsWith('/')) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  String api(String action, [Map<String, String> extra = const {}]) {
    final params = {
      'username': username,
      'password': password,
      'action': action,
      ...extra,
    };
    final uri = Uri.parse('$cleanServer/player_api.php')
        .replace(queryParameters: params);
    return uri.toString();
  }
}

class CategoryItem {
  final String id;
  final String name;
  const CategoryItem(this.id, this.name);
}

class MovieItem {
  final int id;
  final String name;
  final String poster;
  final String extension;
  final String categoryId;
  final double rating;

  const MovieItem({
    required this.id,
    required this.name,
    required this.poster,
    required this.extension,
    required this.categoryId,
    required this.rating,
  });

  factory MovieItem.fromJson(Map<String, dynamic> j) {
    return MovieItem(
      id: int.tryParse(j['stream_id']?.toString() ?? '') ?? 0,
      name: j['name']?.toString() ?? 'Movie',
      poster: j['stream_icon']?.toString() ?? '',
      extension: j['container_extension']?.toString() ?? 'mp4',
      categoryId: j['category_id']?.toString() ?? '',
      rating: double.tryParse(j['rating']?.toString() ?? '') ?? 0,
    );
  }
}

class SeriesItem {
  final int id;
  final String name;
  final String cover;
  final String categoryId;
  final String plot;
  final String rating;

  const SeriesItem({
    required this.id,
    required this.name,
    required this.cover,
    required this.categoryId,
    required this.plot,
    required this.rating,
  });

  factory SeriesItem.fromJson(Map<String, dynamic> j) {
    return SeriesItem(
      id: int.tryParse(j['series_id']?.toString() ?? '') ?? 0,
      name: j['name']?.toString() ?? 'Series',
      cover: j['cover']?.toString() ?? '',
      categoryId: j['category_id']?.toString() ?? '',
      plot: j['plot']?.toString() ?? '',
      rating: j['rating']?.toString() ?? '',
    );
  }
}

class XtreamService {
  static Future<XtreamAccount?> loadAccount() async {
    final p = await SharedPreferences.getInstance();
    final server = p.getString('xtream_server') ?? '';
    final username = p.getString('xtream_username') ?? '';
    final password = p.getString('xtream_password') ?? '';
    if (server.isEmpty || username.isEmpty || password.isEmpty) return null;
    return XtreamAccount(
      server: server,
      username: username,
      password: password,
    );
  }

  static Future<dynamic> getJson(String url) async {
    http.Response r;
    try {
      r = await http.get(
        Uri.parse(url),
        headers: const {
          'User-Agent': 'AVOOZA-TV/2.0',
          'Accept': 'application/json',
        },
      );
    } catch (_) {
      if (!url.startsWith('https://')) rethrow;
      r = await http.get(
        Uri.parse(url.replaceFirst('https://', 'http://')),
        headers: const {
          'User-Agent': 'AVOOZA-TV/2.0',
          'Accept': 'application/json',
        },
      );
    }

    if (r.statusCode != 200) {
      throw Exception('HTTP ${r.statusCode}');
    }

    final text = utf8.decode(r.bodyBytes, allowMalformed: true);
    return jsonDecode(text);
  }

  static Future<List<CategoryItem>> categories(
    XtreamAccount a,
    String action,
  ) async {
    final data = await getJson(a.api(action));
    if (data is! List) return [];
    return data.map((e) {
      final m = Map<String, dynamic>.from(e);
      return CategoryItem(
        m['category_id']?.toString() ?? '',
        m['category_name']?.toString() ?? 'Category',
      );
    }).where((e) => e.id.isNotEmpty).toList();
  }

  static Future<List<Channel>> liveStreams(
    XtreamAccount a, {
    String? categoryId,
  }) async {
    final data = await getJson(
      a.api(
        'get_live_streams',
        categoryId == null ? {} : {'category_id': categoryId},
      ),
    );
    if (data is! List) return [];

    return data.map((e) {
      final m = Map<String, dynamic>.from(e);
      final id = m['stream_id']?.toString() ?? '';
      return Channel(
        name: m['name']?.toString() ?? 'Channel',
        url: '${a.cleanServer}/live/${a.username}/${a.password}/$id.ts',
        group: m['category_id']?.toString() ?? '',
        logo: m['stream_icon']?.toString() ?? '',
      );
    }).where((e) => e.url.isNotEmpty).toList();
  }

  static Future<List<MovieItem>> movies(
    XtreamAccount a, {
    String? categoryId,
  }) async {
    final data = await getJson(
      a.api(
        'get_vod_streams',
        categoryId == null ? {} : {'category_id': categoryId},
      ),
    );
    if (data is! List) return [];
    return data
        .map((e) => MovieItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<List<SeriesItem>> series(
    XtreamAccount a, {
    String? categoryId,
  }) async {
    final data = await getJson(
      a.api(
        'get_series',
        categoryId == null ? {} : {'category_id': categoryId},
      ),
    );
    if (data is! List) return [];
    return data
        .map((e) => SeriesItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<Map<String, dynamic>> seriesInfo(
    XtreamAccount a,
    int seriesId,
  ) async {
    final data = await getJson(
      a.api('get_series_info', {'series_id': '$seriesId'}),
    );
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
}

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
  int revision = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        lang: widget.lang,
        openTab: (i) => setState(() => index = i),
      ),
      LivePage(
        key: ValueKey('live_$revision'),
        lang: widget.lang,
      ),
      MoviesPage(
        key: ValueKey('movies_$revision'),
        lang: widget.lang,
      ),
      SeriesPage(
        key: ValueKey('series_$revision'),
        lang: widget.lang,
      ),
      RadioPage(
        key: ValueKey('radio_$revision'),
        lang: widget.lang,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B1B),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF745CFF),
              child: Icon(Icons.play_arrow_rounded, color: Colors.white),
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
        child: IndexedStack(index: index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
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
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1128),
      builder: (_) => SafeArea(
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
      ),
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
    if (!mounted) return;
    setState(() => revision++);
  }
}

class NeonBackground extends StatelessWidget {
  final Widget child;
  const NeonBackground({super.key, required this.child});

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
                Text(t(lang, 'storySub')),
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
                const [Color(0xFF0066FF), Color(0xFF00C6FF)],
                () => openTab(1),
              ),
              _tile(
                t(lang, 'movies'),
                Icons.movie_rounded,
                const [Color(0xFF7F00FF), Color(0xFFE100FF)],
                () => openTab(2),
              ),
              _tile(
                t(lang, 'series'),
                Icons.video_library_rounded,
                const [Color(0xFFB400FF), Color(0xFFFF4D96)],
                () => openTab(3),
              ),
              _tile(
                t(lang, 'radio'),
                Icons.radio_rounded,
                const [Color(0xFFFF7A18), Color(0xFFFFB74D)],
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

class CategoryGrid extends StatelessWidget {
  final String title;
  final List<CategoryItem> categories;
  final void Function(CategoryItem) onTap;

  const CategoryGrid({
    super.key,
    required this.title,
    required this.categories,
    required this.onTap,
  });

  IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('sport') || n.contains('bein')) return Icons.sports_soccer;
    if (n.contains('kid') || n.contains('cartoon')) return Icons.child_care;
    if (n.contains('news')) return Icons.newspaper;
    if (n.contains('movie') || n.contains('film')) return Icons.movie;
    if (n.contains('series')) return Icons.video_library;
    if (n.contains('radio')) return Icons.radio;
    if (n.contains('music')) return Icons.music_note;
    return Icons.folder_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (_, i) {
              final c = categories[i];
              return InkWell(
                onTap: () => onTap(c),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF192455),
                        const Color(0xFF38217A).withOpacity(.95),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(_iconFor(c.name), size: 30),
                      const Spacer(),
                      Text(
                        c.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
  bool loading = true;
  String? error;

  XtreamAccount? account;
  List<CategoryItem> categories = [];
  List<Channel> m3uChannels = [];

  @override
  void initState() {
    super.initState();
    _loadRoot();
  }

  Future<void> _loadRoot() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      account = await XtreamService.loadAccount();

      if (account != null) {
        final cats = await XtreamService.categories(
          account!,
          'get_live_categories',
        );
        if (!mounted) return;
        setState(() {
          categories = cats;
          loading = false;
        });
        return;
      }

      final p = await SharedPreferences.getInstance();
      final m3u = p.getString('m3u_url') ?? '';

      if (m3u.isEmpty) {
        setState(() => loading = false);
        return;
      }

      final r = await http.get(Uri.parse(m3u));
      if (r.statusCode != 200) {
        throw Exception('HTTP ${r.statusCode}');
      }

      final body = utf8.decode(r.bodyBytes, allowMalformed: true);
      final lines = const LineSplitter().convert(body);

      String name = '';
      String group = '';
      String logo = '';
      final result = <Channel>[];

      String attr(String line, String key) {
        return RegExp('$key="([^"]*)"', caseSensitive: false)
                .firstMatch(line)
                ?.group(1)
                ?.trim() ??
            '';
      }

      for (final raw in lines) {
        final line = raw.trim();
        if (line.startsWith('#EXTINF')) {
          group = attr(line, 'group-title');
          logo = attr(line, 'tvg-logo');
          final comma = line.lastIndexOf(',');
          name = comma >= 0 ? line.substring(comma + 1).trim() : 'Channel';
        } else if (line.startsWith('http://') ||
            line.startsWith('https://')) {
          result.add(
            Channel(
              name: name.isEmpty ? 'Channel' : name,
              url: line,
              group: group.isEmpty ? 'Other' : group,
              logo: logo,
            ),
          );
          name = '';
          group = '';
          logo = '';
        }
      }

      final groups = result.map((e) => e.group).toSet().toList()..sort();

      if (!mounted) return;
      setState(() {
        m3uChannels = result;
        categories = groups
            .map((g) => CategoryItem(g, g))
            .toList();
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: FilledButton.icon(
          onPressed: _loadRoot,
          icon: const Icon(Icons.refresh),
          label: Text(t(widget.lang, 'retry')),
        ),
      );
    }

    if (categories.isEmpty) {
      return _empty(
        widget.lang == 'ar'
            ? 'أضف M3U أو Xtream Codes من الإعدادات.'
            : widget.lang == 'fr'
                ? 'Ajoutez M3U ou Xtream Codes dans les paramètres.'
                : 'Add M3U or Xtream Codes in Settings.',
      );
    }

    return CategoryGrid(
      title: t(widget.lang, 'categories'),
      categories: categories,
      onTap: (cat) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveCategoryPage(
              lang: widget.lang,
              title: cat.name,
              account: account,
              categoryId: account != null ? cat.id : null,
              localChannels: account == null
                  ? m3uChannels.where((c) => c.group == cat.name).toList()
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _empty(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

class LiveCategoryPage extends StatefulWidget {
  final String lang;
  final String title;
  final XtreamAccount? account;
  final String? categoryId;
  final List<Channel>? localChannels;

  const LiveCategoryPage({
    super.key,
    required this.lang,
    required this.title,
    required this.account,
    required this.categoryId,
    required this.localChannels,
  });

  @override
  State<LiveCategoryPage> createState() => _LiveCategoryPageState();
}

class _LiveCategoryPageState extends State<LiveCategoryPage> {
  final search = TextEditingController();
  List<Channel> all = [];
  List<Channel> visible = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    search.addListener(_filter);
    _load();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final data = widget.account != null
          ? await XtreamService.liveStreams(
              widget.account!,
              categoryId: widget.categoryId,
            )
          : (widget.localChannels ?? []);

      if (!mounted) return;
      setState(() {
        all = data;
        visible = List.from(data);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  void _filter() {
    final q = search.text.toLowerCase().trim();
    setState(() {
      visible = q.isEmpty
          ? List.from(all)
          : all.where((c) => c.name.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: NeonBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: t(widget.lang, 'search'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(child: Text(error!))
                      : ListView.separated(
                          padding: const EdgeInsets.all(14),
                          itemCount: visible.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final c = visible[i];
                            final actual = all.indexOf(c);

                            return ListTile(
                              tileColor: Colors.white.withOpacity(.06),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              leading: ChannelLogo(channel: c, size: 52),
                              title: Text(
                                c.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing:
                                  const Icon(Icons.play_arrow_rounded),
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
        ),
      ),
    );
  }
}

class MoviesPage extends StatefulWidget {
  final String lang;
  const MoviesPage({super.key, required this.lang});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  bool loading = true;
  String? error;
  XtreamAccount? account;
  List<CategoryItem> categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      account = await XtreamService.loadAccount();
      if (account == null) {
        setState(() => loading = false);
        return;
      }

      final cats = await XtreamService.categories(
        account!,
        'get_vod_categories',
      );

      if (!mounted) return;
      setState(() {
        categories = cats;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: FilledButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh),
          label: Text(t(widget.lang, 'retry')),
        ),
      );
    }

    if (account == null) {
      return _needXtream();
    }

    if (categories.isEmpty) {
      return Center(child: Text(t(widget.lang, 'noContent')));
    }

    return CategoryGrid(
      title: t(widget.lang, 'categories'),
      categories: categories,
      onTap: (cat) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieCategoryPage(
              lang: widget.lang,
              account: account!,
              category: cat,
            ),
          ),
        );
      },
    );
  }

  Widget _needXtream() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(
          widget.lang == 'ar'
              ? 'الأفلام والبوسترات تحتاج Xtream Codes: Server + Username + Password.'
              : widget.lang == 'fr'
                  ? 'Les films et posters nécessitent Xtream Codes : Server + Username + Password.'
                  : 'Movies and posters need Xtream Codes: Server + Username + Password.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MovieCategoryPage extends StatefulWidget {
  final String lang;
  final XtreamAccount account;
  final CategoryItem category;

  const MovieCategoryPage({
    super.key,
    required this.lang,
    required this.account,
    required this.category,
  });

  @override
  State<MovieCategoryPage> createState() => _MovieCategoryPageState();
}

class _MovieCategoryPageState extends State<MovieCategoryPage> {
  final search = TextEditingController();
  List<MovieItem> all = [];
  List<MovieItem> visible = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    search.addListener(_filter);
    _load();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final data = await XtreamService.movies(
        widget.account,
        categoryId: widget.category.id,
      );
      if (!mounted) return;
      setState(() {
        all = data;
        visible = List.from(data);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  void _filter() {
    final q = search.text.toLowerCase().trim();
    setState(() {
      visible = q.isEmpty
          ? List.from(all)
          : all.where((m) => m.name.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: NeonBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: t(widget.lang, 'search'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(child: Text(error!))
                      : _grid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 1000
            ? 8
            : w >= 700
                ? 6
                : w >= 500
                    ? 4
                    : 3;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: visible.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
            childAspectRatio: .56,
          ),
          itemBuilder: (_, i) {
            final m = visible[i];
            return PosterCard(
              title: m.name,
              image: m.poster,
              rating: m.rating > 0 ? m.rating.toString() : '',
              icon: Icons.movie_rounded,
              onTap: () {
                final ext = m.extension.isEmpty ? 'mp4' : m.extension;
                final url =
                    '${widget.account.cleanServer}/movie/${widget.account.username}/${widget.account.password}/${m.id}.$ext';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VodPlayerPage(
                      title: m.name,
                      url: url,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class SeriesPage extends StatefulWidget {
  final String lang;
  const SeriesPage({super.key, required this.lang});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  bool loading = true;
  String? error;
  XtreamAccount? account;
  List<CategoryItem> categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      account = await XtreamService.loadAccount();
      if (account == null) {
        setState(() => loading = false);
        return;
      }

      final cats = await XtreamService.categories(
        account!,
        'get_series_categories',
      );

      if (!mounted) return;
      setState(() {
        categories = cats;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (error != null) {
      return Center(
        child: FilledButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh),
          label: Text(t(widget.lang, 'retry')),
        ),
      );
    }

    if (account == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            widget.lang == 'ar'
                ? 'المسلسلات والبوسترات تحتاج Xtream Codes.'
                : widget.lang == 'fr'
                    ? 'Les séries et posters nécessitent Xtream Codes.'
                    : 'Series and posters need Xtream Codes.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (categories.isEmpty) {
      return Center(child: Text(t(widget.lang, 'noContent')));
    }

    return CategoryGrid(
      title: t(widget.lang, 'categories'),
      categories: categories,
      onTap: (cat) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SeriesCategoryPage(
              lang: widget.lang,
              account: account!,
              category: cat,
            ),
          ),
        );
      },
    );
  }
}

class SeriesCategoryPage extends StatefulWidget {
  final String lang;
  final XtreamAccount account;
  final CategoryItem category;

  const SeriesCategoryPage({
    super.key,
    required this.lang,
    required this.account,
    required this.category,
  });

  @override
  State<SeriesCategoryPage> createState() => _SeriesCategoryPageState();
}

class _SeriesCategoryPageState extends State<SeriesCategoryPage> {
  final search = TextEditingController();
  List<SeriesItem> all = [];
  List<SeriesItem> visible = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    search.addListener(_filter);
    _load();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final data = await XtreamService.series(
        widget.account,
        categoryId: widget.category.id,
      );
      if (!mounted) return;
      setState(() {
        all = data;
        visible = List.from(data);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  void _filter() {
    final q = search.text.toLowerCase().trim();
    setState(() {
      visible = q.isEmpty
          ? List.from(all)
          : all.where((s) => s.name.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: NeonBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: t(widget.lang, 'search'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(child: Text(error!))
                      : _grid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 1000
            ? 8
            : w >= 700
                ? 6
                : w >= 500
                    ? 4
                    : 3;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: visible.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
            childAspectRatio: .56,
          ),
          itemBuilder: (_, i) {
            final s = visible[i];
            return PosterCard(
              title: s.name,
              image: s.cover,
              rating: s.rating,
              icon: Icons.video_library_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SeriesDetailsPage(
                      lang: widget.lang,
                      account: widget.account,
                      series: s,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class PosterCard extends StatelessWidget {
  final String title;
  final String image;
  final String rating;
  final IconData icon;
  final VoidCallback onTap;

  const PosterCard({
    super.key,
    required this.title,
    required this.image,
    required this.rating,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                color: Colors.white.withOpacity(.06),
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Center(child: Icon(icon, size: 42)),
                      )
                    : Center(child: Icon(icon, size: 42)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (rating.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: Colors.amber,
                ),
                const SizedBox(width: 3),
                Text(
                  rating,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class SeriesDetailsPage extends StatefulWidget {
  final String lang;
  final XtreamAccount account;
  final SeriesItem series;

  const SeriesDetailsPage({
    super.key,
    required this.lang,
    required this.account,
    required this.series,
  });

  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
  bool loading = true;
  String? error;
  Map<String, dynamic> info = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await XtreamService.seriesInfo(
        widget.account,
        widget.series.id,
      );
      if (!mounted) return;
      setState(() {
        info = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.series.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: NeonBackground(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!))
                : _content(),
      ),
    );
  }

  Widget _content() {
    final raw = info['episodes'];
    if (raw is! Map) {
      return Center(child: Text(t(widget.lang, 'noContent')));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: 115,
                height: 170,
                child: widget.series.cover.isNotEmpty
                    ? Image.network(
                        widget.series.cover,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.video_library_rounded),
                      )
                    : const Icon(Icons.video_library_rounded),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.series.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.series.plot.isNotEmpty)
                    Text(
                      widget.series.plot,
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        ...raw.entries.map((season) {
          final episodes = season.value;
          if (episodes is! List) return const SizedBox();

          return ExpansionTile(
            initiallyExpanded: season.key.toString() == '1',
            title: Text(
              '${t(widget.lang, 'season')} ${season.key}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: episodes.map<Widget>((item) {
              final e = Map<String, dynamic>.from(item);
              final id = e['id']?.toString() ?? '';
              final title = e['title']?.toString() ?? 'Episode';
              final ext = e['container_extension']?.toString() ?? 'mp4';
              final num = e['episode_num']?.toString() ?? '';

              return ListTile(
                leading: CircleAvatar(
                  child: Text(num.isEmpty ? '▶' : num),
                ),
                title: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.play_arrow_rounded),
                onTap: id.isEmpty
                    ? null
                    : () {
                        final url =
                            '${widget.account.cleanServer}/series/${widget.account.username}/${widget.account.password}/$id.$ext';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VodPlayerPage(
                              title: title,
                              url: url,
                            ),
                          ),
                        );
                      },
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}

class RadioPage extends StatefulWidget {
  final String lang;
  const RadioPage({super.key, required this.lang});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  bool loading = true;
  XtreamAccount? account;
  List<CategoryItem> categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    account = await XtreamService.loadAccount();
    if (account != null) {
      final all = await XtreamService.categories(
        account!,
        'get_live_categories',
      );
      categories = all.where((c) {
        final n = c.name.toLowerCase();
        return n.contains('radio') ||
            n.contains('music') ||
            n.contains('quran') ||
            n.contains('coran');
      }).toList();
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (account == null || categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            widget.lang == 'ar'
                ? 'سيظهر الراديو هنا إذا كان المزوّد يرسل باقات Radio أو Music ضمن Xtream.'
                : widget.lang == 'fr'
                    ? 'La radio apparaîtra ici si le fournisseur propose des catégories Radio ou Music.'
                    : 'Radio will appear here when the provider exposes Radio or Music categories.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return CategoryGrid(
      title: t(widget.lang, 'categories'),
      categories: categories,
      onTap: (cat) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveCategoryPage(
              lang: widget.lang,
              title: cat.name,
              account: account,
              categoryId: cat.id,
              localChannels: null,
            ),
          ),
        );
      },
    );
  }
}

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
  bool fullscreen = false;
  bool showControls = true;
  String? error;
  Timer? timer;

  Channel get current => widget.channels[index];

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
    _play();
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _armTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => showControls = false);
    });
  }

  Future<void> _play() async {
    await controller?.dispose();
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final c = VideoPlayerController.networkUrl(Uri.parse(current.url));
      controller = c;
      await c.initialize();
      await c.play();
      if (!mounted) return;
      setState(() => loading = false);
      _armTimer();
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
    fullscreen = !fullscreen;
    setState(() {});

    if (fullscreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
      );
    }
  }

  void _picker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1024),
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .75,
          child: ListView.builder(
            itemCount: widget.channels.length,
            itemBuilder: (_, i) {
              final c = widget.channels[i];
              return ListTile(
                leading: ChannelLogo(channel: c, size: 42),
                title: Text(c.name),
                trailing: i == index
                    ? const Icon(Icons.play_circle_fill)
                    : const Icon(Icons.play_arrow_rounded),
                onTap: () {
                  Navigator.pop(context);
                  _change(i);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (fullscreen || landscape) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: _player(full: true),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          current.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
            Expanded(child: _player(full: false)),
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.28),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed:
                        index > 0 ? () => _change(index - 1) : null,
                    icon: const Icon(Icons.skip_previous_rounded),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: _picker,
                      child: Text(
                        current.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: index < widget.channels.length - 1
                        ? () => _change(index + 1)
                        : null,
                    icon: const Icon(Icons.skip_next_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _player({required bool full}) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: FilledButton.icon(
          onPressed: _play,
          icon: const Icon(Icons.refresh),
          label: Text(t(widget.lang, 'retry')),
        ),
      );
    }

    final c = controller!;
    final body = GestureDetector(
      onTap: () {
        setState(() => showControls = !showControls);
        if (showControls) _armTimer();
      },
      onDoubleTap: _toggleFullscreen,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio:
                  c.value.aspectRatio <= 0 ? 16 / 9 : c.value.aspectRatio,
              child: VideoPlayer(c),
            ),
          ),
          if (showControls)
            Stack(
              children: [
                Center(
                  child: IconButton.filled(
                    iconSize: 42,
                    onPressed: () {
                      if (c.value.isPlaying) {
                        c.pause();
                      } else {
                        c.play();
                      }
                      setState(() {});
                      _armTimer();
                    },
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
                  bottom: 16,
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: index > 0
                            ? () => _change(index - 1)
                            : null,
                        icon: const Icon(Icons.skip_previous_rounded),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _picker,
                        icon: const Icon(Icons.list_rounded),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: index < widget.channels.length - 1
                            ? () => _change(index + 1)
                            : null,
                        icon: const Icon(Icons.skip_next_rounded),
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
        ],
      ),
    );

    if (full) return body;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: body,
          ),
        ),
      ),
    );
  }
}

class VodPlayerPage extends StatefulWidget {
  final String title;
  final String url;

  const VodPlayerPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<VodPlayerPage> createState() => _VodPlayerPageState();
}

class _VodPlayerPageState extends State<VodPlayerPage> {
  VideoPlayerController? controller;
  bool loading = true;
  String? error;
  bool fullscreen = false;

  @override
  void initState() {
    super.initState();
    _play();
  }

  Future<void> _play() async {
    try {
      final c = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      controller = c;
      await c.initialize();
      await c.play();
      if (!mounted) return;
      setState(() => loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _toggleFullscreen() async {
    fullscreen = !fullscreen;
    setState(() {});
    if (fullscreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: fullscreen || landscape
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              title: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : GestureDetector(
                  onDoubleTap: _toggleFullscreen,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio:
                              controller!.value.aspectRatio <= 0
                                  ? 16 / 9
                                  : controller!.value.aspectRatio,
                          child: VideoPlayer(controller!),
                        ),
                      ),
                      Center(
                        child: IconButton.filled(
                          iconSize: 44,
                          onPressed: () {
                            if (controller!.value.isPlaying) {
                              controller!.pause();
                            } else {
                              controller!.play();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            controller!.value.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: IconButton.filled(
                          onPressed: _toggleFullscreen,
                          icon: Icon(
                            fullscreen
                                ? Icons.fullscreen_exit_rounded
                                : Icons.fullscreen_rounded,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final String lang;
  final ValueChanged<String> onLangChanged;

  const SettingsPage({
    super.key,
    required this.lang,
    required this.onLangChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String lang;

  @override
  void initState() {
    super.initState();
    lang = widget.lang;
  }

  Future<void> _m3uDialog() async {
    final p = await SharedPreferences.getInstance();
    final c = TextEditingController(text: p.getString('m3u_url') ?? '');

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t(lang, 'addM3u')),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: 'M3U URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t(lang, 'cancel')),
          ),
          FilledButton(
            onPressed: () async {
              final value = c.text.trim();
              if (value.isEmpty) return;
              final p = await SharedPreferences.getInstance();
              await p.setString('m3u_url', value);
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text(t(lang, 'save')),
          ),
        ],
      ),
    );

    c.dispose();
  }

  Future<void> _xtreamDialog() async {
    final p = await SharedPreferences.getInstance();
    final server =
        TextEditingController(text: p.getString('xtream_server') ?? '');
    final user =
        TextEditingController(text: p.getString('xtream_username') ?? '');
    final pass =
        TextEditingController(text: p.getString('xtream_password') ?? '');

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xtream Codes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: server,
                decoration: InputDecoration(
                  labelText: t(lang, 'server'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: user,
                decoration: InputDecoration(
                  labelText: t(lang, 'username'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pass,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: t(lang, 'password'),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t(lang, 'cancel')),
          ),
          FilledButton(
            onPressed: () async {
              var s = server.text.trim();
              final u = user.text.trim();
              final pw = pass.text.trim();
              if (s.isEmpty || u.isEmpty || pw.isEmpty) return;

              if (!s.startsWith('http://') && !s.startsWith('https://')) {
                s = 'http://$s';
              }
              while (s.endsWith('/')) {
                s = s.substring(0, s.length - 1);
              }

              final test = XtreamAccount(
                server: s,
                username: u,
                password: pw,
              );

              try {
                final data = await XtreamService.getJson(
                  test.api('').replaceAll('&action=', ''),
                );

                bool ok = false;
                if (data is Map && data['user_info'] is Map) {
                  ok = Map<String, dynamic>.from(data['user_info'])['auth']
                          ?.toString() ==
                      '1';
                }

                if (!ok) throw Exception('Invalid account');

                final p = await SharedPreferences.getInstance();
                await p.setString('xtream_server', s);
                await p.setString('xtream_username', u);
                await p.setString('xtream_password', pw);

                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Xtream connected ✓')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text('Connexion impossible: $e')),
                );
              }
            },
            child: Text(t(lang, 'save')),
          ),
        ],
      ),
    );

    server.dispose();
    user.dispose();
    pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'settings'))),
      body: NeonBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: lang,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'nl', child: Text('Nederlands')),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => lang = v);
                widget.onLangChanged(v);
              },
              decoration: InputDecoration(
                labelText: t(lang, 'language'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              tileColor: Colors.white.withOpacity(.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              leading: const CircleAvatar(
                child: Icon(Icons.playlist_play_rounded),
              ),
              title: Text(t(lang, 'addM3u')),
              trailing: const Icon(Icons.chevron_right),
              onTap: _m3uDialog,
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white.withOpacity(.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              leading: const CircleAvatar(
                child: Icon(Icons.dns_rounded),
              ),
              title: const Text('Xtream Codes'),
              subtitle: const Text('Server + Username + Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _xtreamDialog,
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white.withOpacity(.05),
              leading: const Icon(Icons.delete_forever_rounded),
              title: Text(t(lang, 'removeM3u')),
              onTap: () async {
                final p = await SharedPreferences.getInstance();
                await p.remove('m3u_url');
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white.withOpacity(.05),
              leading: const Icon(Icons.person_remove_alt_1_rounded),
              title: Text(t(lang, 'removeXtream')),
              onTap: () async {
                final p = await SharedPreferences.getInstance();
                await p.remove('xtream_server');
                await p.remove('xtream_username');
                await p.remove('xtream_password');
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white.withOpacity(.05),
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(t(lang, 'about')),
              subtitle: const Text('Version 2.0'),
            ),
          ],
        ),
      ),
    );
  }
}
