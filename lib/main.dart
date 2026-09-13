import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const AvoozaApp());
}

/* =========================================================
   MODELS
========================================================= */

class XtreamAccount {
  final String server;
  final String username;
  final String password;

  const XtreamAccount({
    required this.server,
    required this.username,
    required this.password,
  });

  bool get isValid =>
      server.trim().isNotEmpty &&
      username.trim().isNotEmpty &&
      password.trim().isNotEmpty;

  String get cleanServer {
    var value = server.trim();

    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }

    return value;
  }

  String apiUrl({String? action, Map<String, String>? extra}) {
    final params = <String, String>{
      'username': username,
      'password': password,
    };

    if (action != null) {
      params['action'] = action;
    }

    if (extra != null) {
      params.addAll(extra);
    }

    final query = Uri(
      queryParameters: params,
    ).query;

    return '$cleanServer/player_api.php?$query';
  }

  String liveUrl(String streamId) {
    return '$cleanServer/live/$username/$password/$streamId.ts';
  }

  String movieUrl(
    String streamId,
    String extension,
  ) {
    final ext = extension.isEmpty ? 'mp4' : extension;
    return '$cleanServer/movie/$username/$password/$streamId.$ext';
  }

  String seriesUrl(
    String streamId,
    String extension,
  ) {
    final ext = extension.isEmpty ? 'mp4' : extension;
    return '$cleanServer/series/$username/$password/$streamId.$ext';
  }
}

class MediaItem {
  final String id;
  final String name;
  final String image;
  final String categoryId;
  final String extension;
  final String streamType;

  const MediaItem({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
    required this.extension,
    required this.streamType,
  });
}

class CategoryItem {
  final String id;
  final String name;

  const CategoryItem({
    required this.id,
    required this.name,
  });
}

class SeriesEpisode {
  final String id;
  final String title;
  final String extension;
  final int episodeNumber;
  final int seasonNumber;

  const SeriesEpisode({
    required this.id,
    required this.title,
    required this.extension,
    required this.episodeNumber,
    required this.seasonNumber,
  });
}

/* =========================================================
   TRANSLATION
========================================================= */

const Map<String, Map<String, String>> texts = {
  'en': {
    'home': 'Home',
    'live': 'Live TV',
    'movies': 'Movies',
    'series': 'Series',
    'radio': 'Radio',
    'settings': 'Settings',
    'language': 'Language',
    'search': 'Search',
    'all': 'All',
    'connect': 'Connect',
    'save': 'Save',
    'cancel': 'Cancel',
    'server': 'Server URL',
    'username': 'Username',
    'password': 'Password',
    'account': 'Xtream Codes',
    'notConfigured': 'Connect your Xtream Codes account',
    'configure': 'Configure account',
    'loading': 'Loading...',
    'error': 'Unable to load content',
    'retry': 'Retry',
    'featured': 'A World of Stories',
    'subtitle': 'Entertainment without borders.',
    'watchNow': 'Watch Now',
    'changeChannel': 'Channels',
    'previous': 'Previous',
    'next': 'Next',
    'logout': 'Remove account',
    'episodes': 'Episodes',
    'season': 'Season',
    'noContent': 'No content found',
  },
  'ar': {
    'home': 'الرئيسية',
    'live': 'البث المباشر',
    'movies': 'الأفلام',
    'series': 'المسلسلات',
    'radio': 'الراديو',
    'settings': 'الإعدادات',
    'language': 'اللغة',
    'search': 'بحث',
    'all': 'الكل',
    'connect': 'اتصال',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'server': 'رابط السيرفر',
    'username': 'اسم المستخدم',
    'password': 'كلمة المرور',
    'account': 'Xtream Codes',
    'notConfigured': 'أدخل بيانات Xtream Codes',
    'configure': 'إعداد الحساب',
    'loading': 'جاري التحميل...',
    'error': 'تعذر تحميل المحتوى',
    'retry': 'إعادة المحاولة',
    'featured': 'عالم من القصص',
    'subtitle': 'ترفيه بلا حدود.',
    'watchNow': 'شاهد الآن',
    'changeChannel': 'القنوات',
    'previous': 'السابق',
    'next': 'التالي',
    'logout': 'حذف الحساب',
    'episodes': 'الحلقات',
    'season': 'الموسم',
    'noContent': 'لا يوجد محتوى',
  },
  'fr': {
    'home': 'Accueil',
    'live': 'TV en direct',
    'movies': 'Films',
    'series': 'Séries',
    'radio': 'Radio',
    'settings': 'Paramètres',
    'language': 'Langue',
    'search': 'Rechercher',
    'all': 'Tout',
    'connect': 'Connexion',
    'save': 'Enregistrer',
    'cancel': 'Annuler',
    'server': 'URL du serveur',
    'username': 'Utilisateur',
    'password': 'Mot de passe',
    'account': 'Xtream Codes',
    'notConfigured': 'Connectez votre compte Xtream Codes',
    'configure': 'Configurer le compte',
    'loading': 'Chargement...',
    'error': 'Impossible de charger le contenu',
    'retry': 'Réessayer',
    'featured': 'Un monde d’histoires',
    'subtitle': 'Le divertissement sans frontières.',
    'watchNow': 'Regarder',
    'changeChannel': 'Chaînes',
    'previous': 'Précédent',
    'next': 'Suivant',
    'logout': 'Supprimer le compte',
    'episodes': 'Épisodes',
    'season': 'Saison',
    'noContent': 'Aucun contenu',
  },
  'nl': {
    'home': 'Home',
    'live': 'Live TV',
    'movies': 'Films',
    'series': 'Series',
    'radio': 'Radio',
    'settings': 'Instellingen',
    'language': 'Taal',
    'search': 'Zoeken',
    'all': 'Alles',
    'connect': 'Verbinden',
    'save': 'Opslaan',
    'cancel': 'Annuleren',
    'server': 'Server URL',
    'username': 'Gebruikersnaam',
    'password': 'Wachtwoord',
    'account': 'Xtream Codes',
    'notConfigured': 'Verbind je Xtream Codes-account',
    'configure': 'Account instellen',
    'loading': 'Laden...',
    'error': 'Kan inhoud niet laden',
    'retry': 'Opnieuw proberen',
    'featured': 'Een wereld vol verhalen',
    'subtitle': 'Entertainment zonder grenzen.',
    'watchNow': 'Nu kijken',
    'changeChannel': 'Kanalen',
    'previous': 'Vorige',
    'next': 'Volgende',
    'logout': 'Account verwijderen',
    'episodes': 'Afleveringen',
    'season': 'Seizoen',
    'noContent': 'Geen inhoud gevonden',
  },
  'zh': {
    'home': '首页',
    'live': '直播',
    'movies': '电影',
    'series': '剧集',
    'radio': '广播',
    'settings': '设置',
    'language': '语言',
    'search': '搜索',
    'all': '全部',
    'connect': '连接',
    'save': '保存',
    'cancel': '取消',
    'server': '服务器地址',
    'username': '用户名',
    'password': '密码',
    'account': 'Xtream Codes',
    'notConfigured': '连接 Xtream Codes',
    'configure': '配置账号',
    'loading': '加载中...',
    'error': '无法加载内容',
    'retry': '重试',
    'featured': '故事的世界',
    'subtitle': '娱乐无国界。',
    'watchNow': '立即观看',
    'changeChannel': '频道',
    'previous': '上一个',
    'next': '下一个',
    'logout': '删除账号',
    'episodes': '剧集',
    'season': '季',
    'noContent': '没有内容',
  },
  'hi': {
    'home': 'होम',
    'live': 'लाइव टीवी',
    'movies': 'फ़िल्में',
    'series': 'सीरीज़',
    'radio': 'रेडियो',
    'settings': 'सेटिंग्स',
    'language': 'भाषा',
    'search': 'खोज',
    'all': 'सभी',
    'connect': 'कनेक्ट',
    'save': 'सेव',
    'cancel': 'रद्द करें',
    'server': 'सर्वर URL',
    'username': 'यूज़रनेम',
    'password': 'पासवर्ड',
    'account': 'Xtream Codes',
    'notConfigured': 'Xtream Codes कनेक्ट करें',
    'configure': 'अकाउंट सेट करें',
    'loading': 'लोड हो रहा है...',
    'error': 'कंटेंट लोड नहीं हो सका',
    'retry': 'फिर कोशिश करें',
    'featured': 'कहानियों की दुनिया',
    'subtitle': 'मनोरंजन बिना सीमाओं के।',
    'watchNow': 'अभी देखें',
    'changeChannel': 'चैनल',
    'previous': 'पिछला',
    'next': 'अगला',
    'logout': 'अकाउंट हटाएँ',
    'episodes': 'एपिसोड',
    'season': 'सीज़न',
    'noContent': 'कोई कंटेंट नहीं',
  },
};

String tr(String language, String key) {
  return texts[language]?[key] ??
      texts['en']?[key] ??
      key;
}

/* =========================================================
   APP
========================================================= */

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
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      language = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);

    if (!mounted) return;

    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AVOOZA TV 3.0',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050816),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: MainShell(
        language: language,
        onLanguageChanged: setLanguage,
      ),
    );
  }
}

/* =========================================================
   API SERVICE
========================================================= */

class XtreamService {
  final XtreamAccount account;

  const XtreamService(this.account);

  Future<dynamic> getJson(String url) async {
    http.Response response;

    try {
      response = await http.get(Uri.parse(url));
    } catch (error) {
      if (url.startsWith('https://')) {
        final fallback =
            url.replaceFirst('https://', 'http://');

        response =
            await http.get(Uri.parse(fallback));
      } else {
        rethrow;
      }
    }

    if (response.statusCode != 200) {
      throw Exception(
        'HTTP ${response.statusCode}',
      );
    }

    return jsonDecode(response.body);
  }

  Future<bool> testAccount() async {
    final data =
        await getJson(account.apiUrl());

    if (data is! Map) return false;

    final userInfo = data['user_info'];

    if (userInfo is! Map) return false;

    return userInfo['auth'].toString() == '1';
  }

  Future<List<CategoryItem>> liveCategories() async {
    return getCategories('get_live_categories');
  }

  Future<List<CategoryItem>> movieCategories() async {
    return getCategories('get_vod_categories');
  }

  Future<List<CategoryItem>> seriesCategories() async {
    return getCategories('get_series_categories');
  }

  Future<List<CategoryItem>> getCategories(
    String action,
  ) async {
    final data = await getJson(
      account.apiUrl(action: action),
    );

    if (data is! List) return [];

    return data.map((item) {
      return CategoryItem(
        id: item['category_id']?.toString() ?? '',
        name: item['category_name']?.toString() ?? 'Unknown',
      );
    }).toList();
  }

  Future<List<MediaItem>> liveStreams({
    String? categoryId,
  }) async {
    final data = await getJson(
      account.apiUrl(
        action: 'get_live_streams',
        extra: categoryId == null
            ? null
            : {'category_id': categoryId},
      ),
    );

    return parseStreams(
      data,
      streamType: 'live',
    );
  }

  Future<List<MediaItem>> movies({
    String? categoryId,
  }) async {
    final data = await getJson(
      account.apiUrl(
        action: 'get_vod_streams',
        extra: categoryId == null
            ? null
            : {'category_id': categoryId},
      ),
    );

    return parseStreams(
      data,
      streamType: 'movie',
    );
  }

  Future<List<MediaItem>> series({
    String? categoryId,
  }) async {
    final data = await getJson(
      account.apiUrl(
        action: 'get_series',
        extra: categoryId == null
            ? null
            : {'category_id': categoryId},
      ),
    );

    if (data is! List) return [];

    return data.map((item) {
      return MediaItem(
        id: item['series_id']?.toString() ?? '',
        name: item['name']?.toString() ?? 'Series',
        image: item['cover']?.toString() ?? '',
        categoryId:
            item['category_id']?.toString() ?? '',
        extension: '',
        streamType: 'series',
      );
    }).toList();
  }

  List<MediaItem> parseStreams(
    dynamic data, {
    required String streamType,
  }) {
    if (data is! List) return [];

    return data.map((item) {
      return MediaItem(
        id: item['stream_id']?.toString() ?? '',
        name: item['name']?.toString() ?? 'Channel',
        image:
            item['stream_icon']?.toString() ?? '',
        categoryId:
            item['category_id']?.toString() ?? '',
        extension:
            item['container_extension']?.toString() ?? '',
        streamType: streamType,
      );
    }).toList();
  }

  Future<List<SeriesEpisode>> episodes(
    String seriesId,
  ) async {
    final data = await getJson(
      account.apiUrl(
        action: 'get_series_info',
        extra: {
          'series_id': seriesId,
        },
      ),
    );

    if (data is! Map) return [];

    final episodesData = data['episodes'];

    if (episodesData is! Map) return [];

    final result = <SeriesEpisode>[];

    episodesData.forEach((seasonKey, value) {
      if (value is! List) return;

      final season =
          int.tryParse(seasonKey.toString()) ?? 0;

      for (final item in value) {
        if (item is! Map) continue;

        result.add(
          SeriesEpisode(
            id: item['id']?.toString() ?? '',
            title: item['title']?.toString() ??
                'Episode',
            extension:
                item['container_extension']?.toString() ??
                    'mp4',
            episodeNumber: int.tryParse(
                  item['episode_num']?.toString() ??
                      '',
                ) ??
                0,
            seasonNumber: season,
          ),
        );
      }
    });

    return result;
  }
}

/* =========================================================
   MAIN SHELL
========================================================= */

class MainShell extends StatefulWidget {
  final String language;
  final ValueChanged<String> onLanguageChanged;

  const MainShell({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;

  XtreamAccount? account;

  bool loadingAccount = true;

  @override
  void initState() {
    super.initState();
    loadAccount();
  }

  Future<void> loadAccount() async {
    final prefs =
        await SharedPreferences.getInstance();

    final server =
        prefs.getString('xtream_server') ?? '';

    final username =
        prefs.getString('xtream_username') ?? '';

    final password =
        prefs.getString('xtream_password') ?? '';

    if (!mounted) return;

    setState(() {
      if (server.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty) {
        account = XtreamAccount(
          server: server,
          username: username,
          password: password,
        );
      }

      loadingAccount = false;
    });
  }

  Future<void> saveAccount(
    XtreamAccount newAccount,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'xtream_server',
      newAccount.server,
    );

    await prefs.setString(
      'xtream_username',
      newAccount.username,
    );

    await prefs.setString(
      'xtream_password',
      newAccount.password,
    );

    if (!mounted) return;

    setState(() {
      account = newAccount;
    });
  }

  Future<void> removeAccount() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove('xtream_server');
    await prefs.remove('xtream_username');
    await prefs.remove('xtream_password');

    if (!mounted) return;

    setState(() {
      account = null;
      tab = 0;
    });
  }

  Future<void> openXtreamLogin() async {
    final result =
        await Navigator.push<XtreamAccount>(
      context,
      MaterialPageRoute(
        builder: (_) => XtreamLoginScreen(
          language: widget.language,
          existing: account,
        ),
      ),
    );

    if (result != null) {
      await saveAccount(result);
    }
  }

  void openLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(0xFF0C1025),
      builder: (_) {
        final languages = {
          'en': 'English',
          'ar': 'العربية',
          'fr': 'Français',
          'nl': 'Nederlands',
          'zh': '中文',
          'hi': 'हिन्दी',
        };

        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding:
                const EdgeInsets.all(16),
            children: languages.entries.map(
              (entry) {
                return ListTile(
                  leading:
                      const Icon(Icons.language),
                  title: Text(entry.value),
                  trailing:
                      widget.language == entry.key
                          ? const Icon(
                              Icons.check_circle,
                            )
                          : null,
                  onTap: () {
                    widget.onLanguageChanged(
                      entry.key,
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadingAccount) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final pages = [
      HomePage(
        language: widget.language,
        account: account,
        onNavigate: (index) {
          setState(() {
            tab = index;
          });
        },
        onConnect: openXtreamLogin,
      ),
      MediaBrowserPage(
        language: widget.language,
        account: account,
        type: 'live',
        onConnect: openXtreamLogin,
      ),
      MediaBrowserPage(
        language: widget.language,
        account: account,
        type: 'movie',
        onConnect: openXtreamLogin,
      ),
      MediaBrowserPage(
        language: widget.language,
        account: account,
        type: 'series',
        onConnect: openXtreamLogin,
      ),
      RadioPage(
        language: widget.language,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AVOOZA TV',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: openLanguage,
            icon:
                const Icon(Icons.language_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SettingsScreen(
                    language:
                        widget.language,
                    account: account,
                    onLanguageChanged:
                        widget.onLanguageChanged,
                    onEditAccount:
                        openXtreamLogin,
                    onRemoveAccount:
                        removeAccount,
                  ),
                ),
              );
            },
            icon:
                const Icon(Icons.settings),
          ),
        ],
      ),
      body: AvoozaBackground(
        child: IndexedStack(
          index: tab,
          children: pages,
        ),
      ),
      bottomNavigationBar:
          NavigationBar(
        selectedIndex: tab,
        onDestinationSelected:
            (value) {
          setState(() {
            tab = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon:
                const Icon(Icons.home_outlined),
            selectedIcon:
                const Icon(Icons.home),
            label:
                tr(widget.language, 'home'),
          ),
          NavigationDestination(
            icon:
                const Icon(Icons.live_tv_outlined),
            selectedIcon:
                const Icon(Icons.live_tv),
            label:
                tr(widget.language, 'live'),
          ),
          NavigationDestination(
            icon:
                const Icon(Icons.movie_outlined),
            selectedIcon:
                const Icon(Icons.movie),
            label:
                tr(widget.language, 'movies'),
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.video_library_outlined,
            ),
            selectedIcon: const Icon(
              Icons.video_library,
            ),
            label:
                tr(widget.language, 'series'),
          ),
          NavigationDestination(
            icon:
                const Icon(Icons.radio_outlined),
            selectedIcon:
                const Icon(Icons.radio),
            label:
                tr(widget.language, 'radio'),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   BACKGROUND
========================================================= */

class AvoozaBackground extends StatelessWidget {
  final Widget child;

  const AvoozaBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration:
              const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end:
                  Alignment.bottomRight,
              colors: [
                Color(0xFF050816),
                Color(0xFF0C1234),
                Color(0xFF080818),
              ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          left: -80,
          child: glow(
            const Color(0xFF772CFF),
            280,
          ),
        ),
        Positioned(
          top: 80,
          right: -100,
          child: glow(
            const Color(0xFF00C8FF),
            280,
          ),
        ),
        Positioned(
          bottom: -100,
          left: 20,
          child: glow(
            const Color(0xFFFF00B8),
            260,
          ),
        ),
        child,
      ],
    );
  }

  Widget glow(
    Color color,
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            RadialGradient(
          colors: [
            color.withOpacity(.32),
            color.withOpacity(.08),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

/* =========================================================
   HOME
========================================================= */

class HomePage extends StatelessWidget {
  final String language;
  final XtreamAccount? account;
  final ValueChanged<int> onNavigate;
  final VoidCallback onConnect;

  const HomePage({
    super.key,
    required this.language,
    required this.account,
    required this.onNavigate,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(24),
            decoration:
                BoxDecoration(
              borderRadius:
                  BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white
                    .withOpacity(.12),
              ),
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF13174A),
                  Color(0xFF082B67),
                  Color(0xFF181043),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  tr(
                    language,
                    'featured',
                  ),
                  style:
                      const TextStyle(
                    fontSize: 36,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  tr(
                    language,
                    'subtitle',
                  ),
                  style:
                      const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                FilledButton.icon(
                  onPressed:
                      account == null
                          ? onConnect
                          : () =>
                              onNavigate(1),
                  icon: Icon(
                    account == null
                        ? Icons.login
                        : Icons
                            .play_arrow,
                  ),
                  label: Text(
                    account == null
                        ? tr(
                            language,
                            'configure',
                          )
                        : tr(
                            language,
                            'watchNow',
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.25,
            children: [
              homeCard(
                title:
                    tr(language, 'live'),
                icon:
                    Icons.live_tv_rounded,
                colors: const [
                  Color(0xFF006EFF),
                  Color(0xFF00C6FF),
                ],
                onTap: () =>
                    onNavigate(1),
              ),
              homeCard(
                title: tr(
                  language,
                  'movies',
                ),
                icon:
                    Icons.movie_rounded,
                colors: const [
                  Color(0xFF9A22FF),
                  Color(0xFFE045FF),
                ],
                onTap: () =>
                    onNavigate(2),
              ),
              homeCard(
                title: tr(
                  language,
                  'series',
                ),
                icon: Icons
                    .video_library_rounded,
                colors: const [
                  Color(0xFFE00080),
                  Color(0xFFFF5656),
                ],
                onTap: () =>
                    onNavigate(3),
              ),
              homeCard(
                title: tr(
                  language,
                  'radio',
                ),
                icon:
                    Icons.radio_rounded,
                colors: const [
                  Color(0xFFFF701E),
                  Color(0xFFFFB52B),
                ],
                onTap: () =>
                    onNavigate(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget homeCard({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(18),
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius.circular(26),
          gradient:
              LinearGradient(
            colors: colors,
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first
                  .withOpacity(.28),
              blurRadius: 28,
              offset:
                  const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 42,
            ),
            const Spacer(),
            Text(
              title,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================================================
   LOGIN
========================================================= */

class XtreamLoginScreen
    extends StatefulWidget {
  final String language;
  final XtreamAccount? existing;

  const XtreamLoginScreen({
    super.key,
    required this.language,
    this.existing,
  });

  @override
  State<XtreamLoginScreen>
      createState() =>
          _XtreamLoginScreenState();
}

class _XtreamLoginScreenState
    extends State<XtreamLoginScreen> {
  late TextEditingController server;
  late TextEditingController username;
  late TextEditingController password;

  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();

    server = TextEditingController(
      text:
          widget.existing?.server ?? '',
    );

    username = TextEditingController(
      text:
          widget.existing?.username ?? '',
    );

    password = TextEditingController(
      text:
          widget.existing?.password ?? '',
    );
  }

  @override
  void dispose() {
    server.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> connect() async {
    final account = XtreamAccount(
      server: server.text.trim(),
      username: username.text.trim(),
      password: password.text.trim(),
    );

    if (!account.isValid) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final valid =
          await XtreamService(account)
              .testAccount();

      if (!valid) {
        throw Exception(
          'Invalid account',
        );
      }

      if (!mounted) return;

      Navigator.pop(
        context,
        account,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(tr(
          widget.language,
          'account',
        )),
      ),
      body: AvoozaBackground(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 600,
            ),
            child: ListView(
              padding:
                  const EdgeInsets.all(
                24,
              ),
              children: [
                const Icon(
                  Icons
                      .account_circle_rounded,
                  size: 80,
                  color:
                      Color(0xFF8B6CFF),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: server,
                  keyboardType:
                      TextInputType.url,
                  decoration:
                      InputDecoration(
                    labelText: tr(
                      widget.language,
                      'server',
                    ),
                    hintText:
                        'http://server.com:8080',
                    border:
                        const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: username,
                  decoration:
                      InputDecoration(
                    labelText: tr(
                      widget.language,
                      'username',
                    ),
                    border:
                        const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration:
                      InputDecoration(
                    labelText: tr(
                      widget.language,
                      'password',
                    ),
                    border:
                        const OutlineInputBorder(),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    error!,
                    style:
                        const TextStyle(
                      color:
                          Colors.redAccent,
                    ),
                  ),
                ],
                const SizedBox(
                  height: 24,
                ),
                FilledButton.icon(
                  onPressed:
                      loading
                          ? null
                          : connect,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
                          ),
                        )
                      : const Icon(
                          Icons.login,
                        ),
                  label: Text(
                    tr(
                      widget.language,
                      'connect',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   MEDIA BROWSER
========================================================= */

class MediaBrowserPage
    extends StatefulWidget {
  final String language;
  final XtreamAccount? account;
  final String type;
  final VoidCallback onConnect;

  const MediaBrowserPage({
    super.key,
    required this.language,
    required this.account,
    required this.type,
    required this.onConnect,
  });

  @override
  State<MediaBrowserPage>
      createState() =>
          _MediaBrowserPageState();
}

class _MediaBrowserPageState
    extends State<MediaBrowserPage> {
  bool loading = true;

  List<CategoryItem> categories = [];
  List<MediaItem> items = [];
  List<MediaItem> filtered = [];

  String selectedCategory = '';
  String search = '';

  XtreamService? get service =>
      widget.account == null
          ? null
          : XtreamService(
              widget.account!,
            );

  @override
  void initState() {
    super.initState();

    if (widget.account != null) {
      load();
    } else {
      loading = false;
    }
  }

  @override
  void didUpdateWidget(
    covariant MediaBrowserPage oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.account?.username !=
            widget.account?.username ||
        oldWidget.account?.server !=
            widget.account?.server) {
      if (widget.account != null) {
        load();
      }
    }
  }

  Future<void> load({
    String? category,
  }) async {
    final api = service;

    if (api == null) return;

    setState(() {
      loading = true;
    });

    try {
      List<CategoryItem> cats = categories;
      List<MediaItem> data = [];

      if (widget.type == 'live') {
        if (cats.isEmpty) {
          cats =
              await api.liveCategories();
        }

        data = await api.liveStreams(
          categoryId: category,
        );
      }

      if (widget.type == 'movie') {
        if (cats.isEmpty) {
          cats =
              await api.movieCategories();
        }

        data = await api.movies(
          categoryId: category,
        );
      }

      if (widget.type == 'series') {
        if (cats.isEmpty) {
          cats =
              await api.seriesCategories();
        }

        data = await api.series(
          categoryId: category,
        );
      }

      if (!mounted) return;

      setState(() {
        categories = cats;
        items = data;
        applyFilter();
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        items = [];
        filtered = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void applyFilter() {
    final q = search.trim().toLowerCase();

    filtered = q.isEmpty
        ? List.from(items)
        : items
            .where(
              (item) => item.name
                  .toLowerCase()
                  .contains(q),
            )
            .toList();
  }

  String get title {
    if (widget.type == 'live') {
      return tr(
        widget.language,
        'live',
      );
    }

    if (widget.type == 'movie') {
      return tr(
        widget.language,
        'movies',
      );
    }

    return tr(
      widget.language,
      'series',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.account == null) {
      return Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.link_off_rounded,
              size: 72,
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              tr(
                widget.language,
                'notConfigured',
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            FilledButton(
              onPressed:
                  widget.onConnect,
              child: Text(
                tr(
                  widget.language,
                  'configure',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 64,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            scrollDirection:
                Axis.horizontal,
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(
                  8,
                ),
                child: ChoiceChip(
                  label: Text(
                    tr(
                      widget.language,
                      'all',
                    ),
                  ),
                  selected:
                      selectedCategory
                          .isEmpty,
                  onSelected: (_) {
                    selectedCategory =
                        '';
                    load();
                  },
                ),
              ),
              ...categories.map(
                (category) {
                  return Padding(
                    padding:
                        const EdgeInsets
                            .all(8),
                    child: ChoiceChip(
                      label: Text(
                        category.name,
                      ),
                      selected:
                          selectedCategory ==
                              category.id,
                      onSelected: (_) {
                        selectedCategory =
                            category.id;

                        load(
                          category:
                              category.id,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            14,
            4,
            14,
            12,
          ),
          child: TextField(
            decoration:
                InputDecoration(
              prefixIcon:
                  const Icon(
                Icons.search,
              ),
              hintText: tr(
                widget.language,
                'search',
              ),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                search = value;
                applyFilter();
              });
            },
          ),
        ),
        Expanded(
          child: loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : filtered.isEmpty
                  ? Center(
                      child: Text(
                        tr(
                          widget.language,
                          'noContent',
                        ),
                      ),
                    )
                  : widget.type == 'live'
                      ? liveList()
                      : mediaGrid(),
        ),
      ],
    );
  }

  Widget liveList() {
    return ListView.separated(
      padding:
          const EdgeInsets.all(14),
      itemCount: filtered.length,
      separatorBuilder:
          (_, __) =>
              const SizedBox(
        height: 8,
      ),
      itemBuilder:
          (context, index) {
        final item =
            filtered[index];

        return ListTile(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
          tileColor:
              Colors.white
                  .withOpacity(.06),
          leading:
              channelLogo(item),
          title:
              Text(item.name),
          trailing:
              const Icon(
            Icons
                .play_arrow_rounded,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LivePlayerScreen(
                  language:
                      widget.language,
                  account:
                      widget.account!,
                  channels:
                      filtered,
                  initialIndex:
                      index,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget mediaGrid() {
    return GridView.builder(
      padding:
          const EdgeInsets.all(14),
      gridDelegate:
          const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filtered.length,
      itemBuilder:
          (context, index) {
        final item =
            filtered[index];

        return InkWell(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          onTap: () {
            if (widget.type ==
                'movie') {
              final url = widget
                  .account!
                  .movieUrl(
                item.id,
                item.extension,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SimplePlayerScreen(
                    title:
                        item.name,
                    url: url,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SeriesDetailsScreen(
                    language:
                        widget.language,
                    account:
                        widget.account!,
                    series: item,
                  ),
                ),
              );
            }
          },
          child: Container(
            decoration:
                BoxDecoration(
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              color: Colors.white
                  .withOpacity(.06),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius
                            .vertical(
                      top:
                          Radius.circular(
                        20,
                      ),
                    ),
                    child:
                        item.image.isEmpty
                            ? Container(
                                width:
                                    double.infinity,
                                color:
                                    Colors.black26,
                                child:
                                    Icon(
                                  widget.type ==
                                          'movie'
                                      ? Icons
                                          .movie
                                      : Icons
                                          .video_library,
                                  size:
                                      70,
                                ),
                              )
                            : Image.network(
                                item.image,
                                width:
                                    double.infinity,
                                fit: BoxFit
                                    .cover,
                                errorBuilder:
                                    (_, __, ___) {
                                  return Container(
                                    color:
                                        Colors.black26,
                                    child:
                                        const Center(
                                      child:
                                          Icon(
                                        Icons
                                            .broken_image,
                                        size:
                                            60,
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets
                          .all(12),
                  child: Text(
                    item.name,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget channelLogo(
    MediaItem item,
  ) {
    if (item.image.isEmpty) {
      return const CircleAvatar(
        child:
            Icon(Icons.live_tv),
      );
    }

    return CircleAvatar(
      backgroundColor:
          Colors.transparent,
      child: ClipOval(
        child: Image.network(
          item.image,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) {
            return const Icon(
              Icons.live_tv,
            );
          },
        ),
      ),
    );
  }
}

/* =========================================================
   LIVE PLAYER
========================================================= */

class LivePlayerScreen
    extends StatefulWidget {
  final String language;
  final XtreamAccount account;
  final List<MediaItem> channels;
  final int initialIndex;

  const LivePlayerScreen({
    super.key,
    required this.language,
    required this.account,
    required this.channels,
    required this.initialIndex,
  });

  @override
  State<LivePlayerScreen>
      createState() =>
          _LivePlayerScreenState();
}

class _LivePlayerScreenState
    extends State<LivePlayerScreen> {
  late int index;

  VideoPlayerController? controller;

  bool loading = true;
  String? error;

  MediaItem get current =>
      widget.channels[index];

  @override
  void initState() {
    super.initState();

    index =
        widget.initialIndex;

    play();
  }

  Future<void> play() async {
    await controller?.dispose();

    if (!mounted) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final url =
          widget.account.liveUrl(
        current.id,
      );

      final player =
          VideoPlayerController
              .networkUrl(
        Uri.parse(url),
      );

      controller = player;

      await player.initialize();
      await player.play();

      if (!mounted) return;

      setState(() {
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

  Future<void> change(
    int newIndex,
  ) async {
    if (newIndex < 0 ||
        newIndex >=
            widget.channels.length) {
      return;
    }

    setState(() {
      index = newIndex;
    });

    await play();
  }

  void channelList() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(0xFF0D1125),
      builder: (_) {
        return SafeArea(
          child: ListView.builder(
            itemCount:
                widget.channels.length,
            itemBuilder:
                (context, itemIndex) {
              final channel =
                  widget.channels[
                      itemIndex];

              return ListTile(
                leading: const Icon(
                  Icons.live_tv,
                ),
                title:
                    Text(channel.name),
                trailing:
                    itemIndex == index
                        ? const Icon(
                            Icons.check,
                          )
                        : null,
                onTap: () {
                  Navigator.pop(
                    context,
                  );

                  change(
                    itemIndex,
                  );
                },
              );
            },
          ),
        );
      },
    );
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
        title: Text(
          current.name,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed:
                channelList,
            icon: const Icon(
              Icons
                  .playlist_play_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              width:
                  double.infinity,
              child: loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : error != null
                      ? Center(
                          child:
                              Text(error!),
                        )
                      : Center(
                          child:
                              AspectRatio(
                            aspectRatio:
                                controller!
                                    .value
                                    .aspectRatio,
                            child:
                                VideoPlayer(
                              controller!,
                            ),
                          ),
                        ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.all(
              14,
            ),
            child: Row(
              children: [
                Expanded(
                  child:
                      OutlinedButton.icon(
                    onPressed:
                        index > 0
                            ? () =>
                                change(
                                  index -
                                      1,
                                )
                            : null,
                    icon:
                        const Icon(
                      Icons
                          .skip_previous,
                    ),
                    label: Text(
                      tr(
                        widget.language,
                        'previous',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child:
                      FilledButton.icon(
                    onPressed:
                        channelList,
                    icon:
                        const Icon(
                      Icons.list,
                    ),
                    label: Text(
                      tr(
                        widget.language,
                        'changeChannel',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child:
                      OutlinedButton.icon(
                    onPressed: index <
                            widget.channels
                                    .length -
                                1
                        ? () =>
                            change(
                              index +
                                  1,
                            )
                        : null,
                    icon:
                        const Icon(
                      Icons.skip_next,
                    ),
                    label: Text(
                      tr(
                        widget.language,
                        'next',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   SERIES DETAILS
========================================================= */

class SeriesDetailsScreen
    extends StatefulWidget {
  final String language;
  final XtreamAccount account;
  final MediaItem series;

  const SeriesDetailsScreen({
    super.key,
    required this.language,
    required this.account,
    required this.series,
  });

  @override
  State<SeriesDetailsScreen>
      createState() =>
          _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState
    extends State<SeriesDetailsScreen> {
  bool loading = true;
  List<SeriesEpisode> episodes = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data =
          await XtreamService(
        widget.account,
      ).episodes(
        widget.series.id,
      );

      if (!mounted) return;

      setState(() {
        episodes = data;
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(
        title:
            Text(widget.series.name),
      ),
      body: AvoozaBackground(
        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : ListView.separated(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                itemCount:
                    episodes.length,
                separatorBuilder:
                    (_, __) =>
                        const SizedBox(
                  height: 8,
                ),
                itemBuilder:
                    (context, index) {
                  final episode =
                      episodes[index];

                  return ListTile(
                    tileColor:
                        Colors.white
                            .withOpacity(
                                .06),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                    ),
                    leading:
                        CircleAvatar(
                      child: Text(
                        episode
                            .episodeNumber
                            .toString(),
                      ),
                    ),
                    title:
                        Text(
                      episode.title,
                    ),
                    subtitle: Text(
                      '${tr(widget.language, 'season')} ${episode.seasonNumber}',
                    ),
                    trailing:
                        const Icon(
                      Icons
                          .play_arrow,
                    ),
                    onTap: () {
                      final url =
                          widget.account
                              .seriesUrl(
                        episode.id,
                        episode
                            .extension,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SimplePlayerScreen(
                            title: episode
                                .title,
                            url: url,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

/* =========================================================
   SIMPLE PLAYER
========================================================= */

class SimplePlayerScreen
    extends StatefulWidget {
  final String title;
  final String url;

  const SimplePlayerScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<SimplePlayerScreen>
      createState() =>
          _SimplePlayerScreenState();
}

class _SimplePlayerScreenState
    extends State<SimplePlayerScreen> {
  VideoPlayerController? controller;

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    play();
  }

  Future<void> play() async {
    try {
      final player =
          VideoPlayerController
              .networkUrl(
        Uri.parse(widget.url),
      );

      controller = player;

      await player.initialize();
      await player.play();

      if (!mounted) return;

      setState(() {
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
