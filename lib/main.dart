import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const AvoozaApp());
}

const Map<String, Map<String, String>> kTexts = {
  'en': {
    'home': 'Home',
    'live': 'Live TV',
    'movies': 'Movies',
    'series': 'Series',
    'radio': 'Radio',
    'settings': 'Settings',
    'language': 'Language',
    'featured': 'A World of Stories',
    'featuredSub': 'Global entertainment in your language.',
    'watchNow': 'Watch Now',
    'continue': 'Continue Watching',
    'addPlaylist': 'Add M3U URL',
    'changePlaylist': 'Change Playlist',
    'savedPlaylist': 'Saved Playlist',
    'connect': 'Connect',
    'cancel': 'Cancel',
    'searchChannels': 'Search channels...',
    'noChannels': 'No channels yet',
    'noChannelsSub': 'Add your playlist and your channels will appear here.',
    'moviesSub': 'Blockbusters & more',
    'seriesSub': 'Binge your favorites',
    'radioSub': 'Listen everywhere',
    'liveSub': 'News, sports, channels',
    'kids': 'Kids',
    'kidsSub': 'Safe & fun for all',
    'comingSoon': 'Coming next',
    'clearPlaylist': 'Remove saved playlist',
    'about': 'About AVOOZA TV',
    'selectLang': 'Select language',
    'changeChannel': 'Change channel',
    'previous': 'Previous',
    'next': 'Next',
    'unablePlaylist': 'Unable to connect to playlist',
    'noResults': 'No channels found in this playlist',
    'demoNote': 'UI ready. Real VOD content can be connected next.',
  },
  'ar': {
    'home': 'الرئيسية',
    'live': 'البث المباشر',
    'movies': 'الأفلام',
    'series': 'المسلسلات',
    'radio': 'الراديو',
    'settings': 'الإعدادات',
    'language': 'اللغة',
    'featured': 'عالم من القصص',
    'featuredSub': 'ترفيه عالمي بلغتك.',
    'watchNow': 'شاهد الآن',
    'continue': 'أكمل المشاهدة',
    'addPlaylist': 'إضافة رابط M3U',
    'changePlaylist': 'تغيير القائمة',
    'savedPlaylist': 'القائمة المحفوظة',
    'connect': 'اتصال',
    'cancel': 'إلغاء',
    'searchChannels': 'ابحث عن القنوات...',
    'noChannels': 'لا توجد قنوات بعد',
    'noChannelsSub': 'أضف رابطك وستظهر القنوات هنا.',
    'moviesSub': 'أفلام وأكثر',
    'seriesSub': 'أفضل المسلسلات',
    'radioSub': 'استمع في كل مكان',
    'liveSub': 'أخبار، رياضة، قنوات',
    'kids': 'الأطفال',
    'kidsSub': 'آمن وممتع للجميع',
    'comingSoon': 'قريباً',
    'clearPlaylist': 'حذف القائمة المحفوظة',
    'about': 'حول AVOOZA TV',
    'selectLang': 'اختر اللغة',
    'changeChannel': 'تغيير القناة',
    'previous': 'السابق',
    'next': 'التالي',
    'unablePlaylist': 'تعذر الاتصال بالقائمة',
    'noResults': 'لم يتم العثور على قنوات في هذه القائمة',
    'demoNote': 'الواجهة جاهزة. ربط محتوى VOD الحقيقي يأتي في المرحلة التالية.',
  },
  'fr': {
    'home': 'Accueil',
    'live': 'Live TV',
    'movies': 'Films',
    'series': 'Séries',
    'radio': 'Radio',
    'settings': 'Paramètres',
    'language': 'Langue',
    'featured': 'Un monde d’histoires',
    'featuredSub': 'Divertissement mondial dans votre langue.',
    'watchNow': 'Regarder',
    'continue': 'Continuer',
    'addPlaylist': 'Ajouter URL M3U',
    'changePlaylist': 'Changer playlist',
    'savedPlaylist': 'Playlist enregistrée',
    'connect': 'Connecter',
    'cancel': 'Annuler',
    'searchChannels': 'Rechercher des chaînes...',
    'noChannels': 'Pas encore de chaînes',
    'noChannelsSub': 'Ajoutez votre playlist et vos chaînes apparaîtront ici.',
    'moviesSub': 'Blockbusters et plus',
    'seriesSub': 'Vos séries préférées',
    'radioSub': 'Écoutez partout',
    'liveSub': 'News, sports, chaînes',
    'kids': 'Kids',
    'kidsSub': 'Sûr & fun pour tous',
    'comingSoon': 'Bientôt',
    'clearPlaylist': 'Supprimer la playlist',
    'about': 'À propos de AVOOZA TV',
    'selectLang': 'Choisir la langue',
    'changeChannel': 'Changer de chaîne',
    'previous': 'Précédent',
    'next': 'Suivant',
    'unablePlaylist': 'Impossible de se connecter à la playlist',
    'noResults': 'Aucune chaîne trouvée dans cette playlist',
    'demoNote': 'Interface prête. Le vrai contenu VOD peut être connecté ensuite.',
  },
  'nl': {
    'home': 'Home',
    'live': 'Live TV',
    'movies': 'Films',
    'series': 'Series',
    'radio': 'Radio',
    'settings': 'Instellingen',
    'language': 'Taal',
    'featured': 'Een wereld vol verhalen',
    'featuredSub': 'Wereldwijde entertainment in jouw taal.',
    'watchNow': 'Nu kijken',
    'continue': 'Verder kijken',
    'addPlaylist': 'M3U URL toevoegen',
    'changePlaylist': 'Playlist wijzigen',
    'savedPlaylist': 'Opgeslagen playlist',
    'connect': 'Verbinden',
    'cancel': 'Annuleren',
    'searchChannels': 'Zoek kanalen...',
    'noChannels': 'Nog geen kanalen',
    'noChannelsSub': 'Voeg je playlist toe en je kanalen verschijnen hier.',
    'moviesSub': 'Films & meer',
    'seriesSub': 'Jouw favoriete series',
    'radioSub': 'Luister overal',
    'liveSub': 'Nieuws, sport, kanalen',
    'kids': 'Kids',
    'kidsSub': 'Veilig & leuk voor iedereen',
    'comingSoon': 'Binnenkort',
    'clearPlaylist': 'Opgeslagen playlist verwijderen',
    'about': 'Over AVOOZA TV',
    'selectLang': 'Kies taal',
    'changeChannel': 'Kanaal wijzigen',
    'previous': 'Vorige',
    'next': 'Volgende',
    'unablePlaylist': 'Kan geen verbinding maken met de playlist',
    'noResults': 'Geen kanalen gevonden in deze playlist',
    'demoNote': 'UI is klaar. Echte VOD-content kan hierna gekoppeld worden.',
  },
  'zh': {
    'home': '首页',
    'live': '直播',
    'movies': '电影',
    'series': '剧集',
    'radio': '广播',
    'settings': '设置',
    'language': '语言',
    'featured': '故事的世界',
    'featuredSub': '用你的语言享受全球娱乐。',
    'watchNow': '立即观看',
    'continue': '继续观看',
    'addPlaylist': '添加 M3U 链接',
    'changePlaylist': '更改播放列表',
    'savedPlaylist': '已保存列表',
    'connect': '连接',
    'cancel': '取消',
    'searchChannels': '搜索频道...',
    'noChannels': '暂无频道',
    'noChannelsSub': '添加你的播放列表后，频道会显示在这里。',
    'moviesSub': '电影与更多',
    'seriesSub': '你喜欢的剧集',
    'radioSub': '随时收听',
    'liveSub': '新闻、体育、频道',
    'kids': '儿童',
    'kidsSub': '安全有趣',
    'comingSoon': '即将推出',
    'clearPlaylist': '删除已保存列表',
    'about': '关于 AVOOZA TV',
    'selectLang': '选择语言',
    'changeChannel': '切换频道',
    'previous': '上一项',
    'next': '下一项',
    'unablePlaylist': '无法连接到播放列表',
    'noResults': '此播放列表中未找到频道',
    'demoNote': '界面已准备好，下一步可连接真实 VOD 内容。',
  },
  'hi': {
    'home': 'होम',
    'live': 'लाइव टीवी',
    'movies': 'फ़िल्में',
    'series': 'सीरीज़',
    'radio': 'रेडियो',
    'settings': 'सेटिंग्स',
    'language': 'भाषा',
    'featured': 'कहानियों की दुनिया',
    'featuredSub': 'आपकी भाषा में वैश्विक मनोरंजन।',
    'watchNow': 'अभी देखें',
    'continue': 'देखना जारी रखें',
    'addPlaylist': 'M3U URL जोड़ें',
    'changePlaylist': 'प्लेलिस्ट बदलें',
    'savedPlaylist': 'सहेजी गई प्लेलिस्ट',
    'connect': 'कनेक्ट',
    'cancel': 'रद्द करें',
    'searchChannels': 'चैनल खोजें...',
    'noChannels': 'अभी कोई चैनल नहीं',
    'noChannelsSub': 'अपनी प्लेलिस्ट जोड़ें और चैनल यहाँ दिखेंगे।',
    'moviesSub': 'ब्लॉकबस्टर और अधिक',
    'seriesSub': 'आपकी पसंदीदा सीरीज़',
    'radioSub': 'हर जगह सुनें',
    'liveSub': 'समाचार, खेल, चैनल',
    'kids': 'किड्स',
    'kidsSub': 'सुरक्षित और मज़ेदार',
    'comingSoon': 'जल्द आ रहा है',
    'clearPlaylist': 'सहेजी हुई प्लेलिस्ट हटाएँ',
    'about': 'AVOOZA TV के बारे में',
    'selectLang': 'भाषा चुनें',
    'changeChannel': 'चैनल बदलें',
    'previous': 'पिछला',
    'next': 'अगला',
    'unablePlaylist': 'प्लेलिस्ट से कनेक्ट नहीं हो सका',
    'noResults': 'इस प्लेलिस्ट में कोई चैनल नहीं मिला',
    'demoNote': 'UI तैयार है। असली VOD सामग्री अगली स्टेप में जोड़ी जा सकती है।',
  },
};

String tr(String lang, String key) {
  return kTexts[lang]?[key] ?? kTexts['en']![key] ?? key;
}

class AvoozaApp extends StatefulWidget {
  const AvoozaApp({super.key});

  @override
  State<AvoozaApp> createState() => _AvoozaAppState();
}

class _AvoozaAppState extends State<AvoozaApp> {
  String currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLanguage = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _changeLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    setState(() {
      currentLanguage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVOOZA TV 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050817),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B5CFF),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeShell(
        language: currentLanguage,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}

class Channel {
  final String name;
  final String url;
  final String group;

  Channel({
    required this.name,
    required this.url,
    this.group = '',
  });
}

class MediaCardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  MediaCardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });
}

class RadioStation {
  final String name;
  final IconData icon;
  final List<Color> colors;

  RadioStation({
    required this.name,
    required this.icon,
    required this.colors,
  });
}

class HomeShell extends StatefulWidget {
  final String language;
  final ValueChanged<String> onLanguageChanged;

  const HomeShell({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  void _goTo(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _openLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1128),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final items = [
          {'code': 'en', 'name': 'English'},
          {'code': 'ar', 'name': 'العربية'},
          {'code': 'fr', 'name': 'Français'},
          {'code': 'nl', 'name': 'Nederlands'},
          {'code': 'zh', 'name': '中文'},
          {'code': 'hi', 'name': 'हिन्दी'},
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr(widget.language, 'selectLang'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map((e) {
                  final selected = widget.language == e['code'];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tileColor: selected
                        ? const Color(0xFF7B5CFF).withOpacity(.18)
                        : Colors.white.withOpacity(.04),
                    leading: const Icon(Icons.language_rounded),
                    title: Text(e['name']!),
                    trailing: selected
                        ? const Icon(Icons.check_circle_rounded)
                        : null,
                    onTap: () {
                      widget.onLanguageChanged(e['code']!);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSettings() {
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
    final pages = [
      DashboardPage(
        language: widget.language,
        onOpenTab: _goTo,
      ),
      LiveTvPage(language: widget.language),
      MoviesPage(language: widget.language),
      SeriesPage(language: widget.language),
      RadioPage(language: widget.language),
    ];

    final titles = [
      tr(widget.language, 'home'),
      tr(widget.language, 'live'),
      tr(widget.language, 'movies'),
      tr(widget.language, 'series'),
      tr(widget.language, 'radio'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(.25),
        title: Row(
          children: [
            const Icon(
              Icons.play_circle_fill_rounded,
              color: Color(0xFF7B5CFF),
            ),
            const SizedBox(width: 10),
            const Text(
              'AVOOZA TV 2.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                titles[currentIndex],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(.72),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: tr(widget.language, 'language'),
            icon: const Icon(Icons.language_rounded),
            onPressed: _openLanguageSheet,
          ),
          IconButton(
            tooltip: tr(widget.language, 'settings'),
            icon: const Icon(Icons.settings_rounded),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: AvoozaBackground(
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 74,
        selectedIndex: currentIndex,
        backgroundColor: const Color(0xFF070B1B),
        indicatorColor: const Color(0xFF7B5CFF).withOpacity(.25),
        onDestinationSelected: _goTo,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: tr(widget.language, 'home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.live_tv_outlined),
            selectedIcon: const Icon(Icons.live_tv_rounded),
            label: tr(widget.language, 'live'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.movie_outlined),
            selectedIcon: const Icon(Icons.movie_rounded),
            label: tr(widget.language, 'movies'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.video_library_outlined),
            selectedIcon: const Icon(Icons.video_library_rounded),
            label: tr(widget.language, 'series'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.radio_outlined),
            selectedIcon: const Icon(Icons.radio_rounded),
            label: tr(widget.language, 'radio'),
          ),
        ],
      ),
    );
  }
}

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
        Container(color: const Color(0xFF050817)),
        Positioned(
          top: -80,
          left: -40,
          child: _glow(const Color(0xFF772CFF), 220),
        ),
        Positioned(
          top: 100,
          right: -60,
          child: _glow(const Color(0xFF00B8FF), 220),
        ),
        Positioned(
          bottom: -100,
          left: 10,
          child: _glow(const Color(0xFFFF4FD8), 250),
        ),
        Positioned(
          bottom: 10,
          right: -40,
          child: _glow(const Color(0xFF7B5CFF), 180),
        ),
        child,
      ],
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(.38),
            color.withOpacity(.18),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String language;
  final ValueChanged<int> onOpenTab;

  const DashboardPage({
    super.key,
    required this.language,
    required this.onOpenTab,
  });

  @override
  Widget build(BuildContext context) {
    final media = [
      MediaCardItem(
        title: tr(language, 'live'),
        subtitle: tr(language, 'liveSub'),
        icon: Icons.live_tv_rounded,
        colors: const [
          Color(0xFF0072FF),
          Color(0xFF00C6FF),
        ],
      ),
      MediaCardItem(
        title: tr(language, 'movies'),
        subtitle: tr(language, 'moviesSub'),
        icon: Icons.movie_creation_outlined,
        colors: const [
          Color(0xFF8328FF),
          Color(0xFFCD5BFF),
        ],
      ),
      MediaCardItem(
        title: tr(language, 'series'),
        subtitle: tr(language, 'seriesSub'),
        icon: Icons.video_library_rounded,
        colors: const [
          Color(0xFFB400FF),
          Color(0xFFFF4D96),
        ],
      ),
      MediaCardItem(
        title: tr(language, 'radio'),
        subtitle: tr(language, 'radioSub'),
        icon: Icons.radio_rounded,
        colors: const [
          Color(0xFFFF7A18),
          Color(0xFFFFB74D),
        ],
      ),
      MediaCardItem(
        title: tr(language, 'kids'),
        subtitle: tr(language, 'kidsSub'),
        icon: Icons.sentiment_satisfied_alt_rounded,
        colors: const [
          Color(0xFF10B981),
          Color(0xFF34D399),
        ],
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heroBanner(),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            itemCount: media.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.15,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final item = media[index];
              final tabIndex = index > 3 ? 0 : index + 1;

              return _mediaTile(
                item: item,
                onTap: () => onOpenTab(tabIndex),
              );
            },
          ),
          const SizedBox(height: 22),
          Text(
            tr(language, 'continue'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 172,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _posterCard(
                  title: 'The Last of Us',
                  subtitle: 'S1 E5 · 28 min left',
                  colors: const [
                    Color(0xFF2B4162),
                    Color(0xFF12100E),
                  ],
                ),
                _posterCard(
                  title: 'Dune',
                  subtitle: '2h 46m · Epic sci-fi',
                  colors: const [
                    Color(0xFF6B4E2E),
                    Color(0xFFD9A066),
                  ],
                ),
                _posterCard(
                  title: 'Stranger Things',
                  subtitle: 'S4 E1 · 36 min left',
                  colors: const [
                    Color(0xFF2C1839),
                    Color(0xFF8B1E3F),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(.10),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A0E23),
            Color(0xFF091D50),
            Color(0xFF10224A),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(language, 'featured'),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tr(language, 'featuredSub'),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => onOpenTab(1),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              tr(language, 'watchNow'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaTile({
    required MediaCardItem item,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              item.colors.first.withOpacity(.80),
              item.colors.last.withOpacity(.35),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              item.icon,
              size: 34,
            ),
            const Spacer(),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.subtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _posterCard({
    required String title,
    required String subtitle,
    required List<Color> colors,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class LiveTvPage extends StatefulWidget {
  final String language;

  const LiveTvPage({
    super.key,
    required this.language,
  });

  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> {
  final TextEditingController _playlistController =
      TextEditingController();

  final TextEditingController _searchController =
      TextEditingController();

  List<Channel> channels = [];
  List<Channel> filteredChannels = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPlaylist();
    _searchController.addListener(_applySearch);
  }

  @override
  void dispose() {
    _playlistController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('m3u_url') ?? '';

    _playlistController.text = saved;

    if (saved.isNotEmpty) {
      await _loadM3U(
        saved,
        silent: true,
      );
    }
  }

  void _applySearch() {
    final query =
        _searchController.text.trim().toLowerCase();

    setState(() {
      filteredChannels = query.isEmpty
          ? List.from(channels)
          : channels
              .where(
                (c) =>
                    c.name.toLowerCase().contains(query),
              )
              .toList();
    });
  }

  Future<http.Response> _downloadPlaylist(
    String rawUrl,
  ) async {
    try {
      return await http.get(
        Uri.parse(rawUrl),
      );
    } catch (e) {
      final message =
          e.toString().toLowerCase();

      if (rawUrl.startsWith('https://') &&
          (message.contains('wrong_version_number') ||
              message.contains('handshakeexception') ||
              message.contains('ssl'))) {
        return await http.get(
          Uri.parse(
            rawUrl.replaceFirst(
              'https://',
              'http://',
            ),
          ),
        );
      }

      rethrow;
    }
  }

  Future<void> _loadM3U(
    String url, {
    bool silent = false,
  }) async {
    setState(() {
      loading = true;
    });

    try {
      final response =
          await _downloadPlaylist(url);

      if (response.statusCode != 200) {
        throw Exception(
          'Status code: ${response.statusCode}',
        );
      }

      final lines =
          response.body.split('\n');

      final result = <Channel>[];

      String? currentName;
      String currentGroup = '';

      for (final rawLine in lines) {
        final line = rawLine.trim();

        if (line.startsWith('#EXTINF')) {
          final groupMatch = RegExp(
            r'group-title="([^"]*)"',
          ).firstMatch(line);

          currentGroup =
              groupMatch?.group(1) ?? '';

          final commaIndex =
              line.lastIndexOf(',');

          currentName = commaIndex != -1
              ? line
                  .substring(
                    commaIndex + 1,
                  )
                  .trim()
              : 'Channel ${result.length + 1}';
        } else if (line.startsWith('http://') ||
            line.startsWith('https://')) {
          result.add(
            Channel(
              name: currentName ??
                  'Channel ${result.length + 1}',
              url: line,
              group: currentGroup,
            ),
          );

          currentName = null;
          currentGroup = '';
        }
      }

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'm3u_url',
        url,
      );

      setState(() {
        channels = result;
        filteredChannels =
            List.from(result);
      });

      if (!silent && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              result.isEmpty
                  ? tr(
                      widget.language,
                      'noResults',
                    )
                  : '${result.length} channels loaded',
            ),
          ),
        );
      }
    } catch (e) {
      if (!silent && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              '${tr(widget.language, 'unablePlaylist')}\n$e',
            ),
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

  void _openPlaylistDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          tr(
            widget.language,
            'addPlaylist',
          ),
        ),
        content: TextField(
          controller:
              _playlistController,
          decoration:
              const InputDecoration(
            hintText:
                'http://example.com/playlist.m3u',
            border:
                OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Text(
              tr(
                widget.language,
                'cancel',
              ),
            ),
          ),
          FilledButton(
            onPressed: () async {
              final url =
                  _playlistController
                      .text
                      .trim();

              Navigator.pop(context);

              if (url.isNotEmpty) {
                await _loadM3U(url);
              }
            },
            child: Text(
              tr(
                widget.language,
                'connect',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.all(16),
          child: Column(
            children: [
              FilledButton.icon(
                onPressed:
                    _openPlaylistDialog,
                icon: const Icon(
                  Icons.add_link_rounded,
                ),
                label: Text(
                  tr(
                    widget.language,
                    'changePlaylist',
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller:
                    _searchController,
                decoration:
                    InputDecoration(
                  prefixIcon:
                      const Icon(
                    Icons.search_rounded,
                  ),
                  hintText: tr(
                    widget.language,
                    'searchChannels',
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : filteredChannels
                      .isEmpty
                  ? Center(
                      child:
                          FilledButton(
                        onPressed:
                            _openPlaylistDialog,
                        child: Text(
                          tr(
                            widget.language,
                            'addPlaylist',
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding:
                          const EdgeInsets
                              .all(16),
                      itemCount:
                          filteredChannels
                              .length,
                      separatorBuilder:
                          (_, index) =>
                              const SizedBox(
                        height: 10,
                      ),
                      itemBuilder:
                          (context, index) {
                        final channel =
                            filteredChannels[
                                index];

                        final actualIndex =
                            channels.indexOf(
                          channel,
                        );

                        return ListTile(
                          tileColor:
                              Colors.white
                                  .withOpacity(
                                      .05),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                          ),
                          leading:
                              const Icon(
                            Icons
                                .live_tv_rounded,
                          ),
                          title: Text(
                            channel.name,
                          ),
                          subtitle: Text(
                            channel.group
                                    .isEmpty
                                ? channel.url
                                : channel
                                    .group,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
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
                                    PlayerScreen(
                                  language:
                                      widget
                                          .language,
                                  channels:
                                      channels,
                                  initialIndex:
                                      actualIndex,
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
  final String language;
  final List<Channel> channels;
  final int initialIndex;

  const PlayerScreen({
    super.key,
    required this.language,
    required this.channels,
    required this.initialIndex,
  });

  @override
  State<PlayerScreen> createState() =>
      _PlayerScreenState();
}

class _PlayerScreenState
    extends State<PlayerScreen> {
  VideoPlayerController? controller;
  int currentIndex = 0;
  bool loading = true;
  String? errorText;

  Channel get currentChannel =>
      widget.channels[currentIndex];

  @override
  void initState() {
    super.initState();
    currentIndex =
        widget.initialIndex;
    _playCurrent();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _playCurrent() async {
    setState(() {
      loading = true;
      errorText = null;
    });

    await controller?.dispose();

    try {
      final c =
          VideoPlayerController.networkUrl(
        Uri.parse(
          currentChannel.url,
        ),
      );

      controller = c;

      await c.initialize();
      await c.play();

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          errorText = e.toString();
        });
      }
    }
  }

  Future<void> _changeChannel(
    int newIndex,
  ) async {
    if (newIndex < 0 ||
        newIndex >=
            widget.channels.length) {
      return;
    }

    setState(() {
      currentIndex = newIndex;
    });

    await _playCurrent();
  }

  void _showChannelPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: ListView.builder(
          itemCount:
              widget.channels.length,
          itemBuilder:
              (context, index) {
            final channel =
                widget.channels[index];

            return ListTile(
              leading: const Icon(
                Icons.tv_rounded,
              ),
              title: Text(
                channel.name,
              ),
              onTap: () async {
                Navigator.pop(
                  context,
                );

                await _changeChannel(
                  index,
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPrev =
        currentIndex > 0;

    final canNext =
        currentIndex <
            widget.channels.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentChannel.name,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons
                  .playlist_play_rounded,
            ),
            onPressed:
                _showChannelPicker,
          ),
        ],
      ),
      body: AvoozaBackground(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: loading
                    ? const CircularProgressIndicator()
                    : errorText != null
                        ? Padding(
                            padding:
                                const EdgeInsets
                                    .all(24),
                            child: Text(
                              errorText!,
                              textAlign:
                                  TextAlign
                                      .center,
                            ),
                          )
                        : controller == null ||
                                !controller!
                                    .value
                                    .isInitialized
                            ? const Text(
                                'Player not ready',
                              )
                            : AspectRatio(
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
            Padding(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        OutlinedButton(
                      onPressed:
                          canPrev
                              ? () =>
                                  _changeChannel(
                                    currentIndex -
                                        1,
                                  )
                              : null,
                      child: Text(
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
                        FilledButton(
                      onPressed:
                          _showChannelPicker,
                      child: Text(
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
                        OutlinedButton(
                      onPressed:
                          canNext
                              ? () =>
                                  _changeChannel(
                                    currentIndex +
                                        1,
                                  )
                              : null,
                      child: Text(
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
      ),
    );
  }
}

class MoviesPage extends StatelessWidget {
  final String language;

  const MoviesPage({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${tr(language, 'movies')}\n${tr(language, 'demoNote')}',
        textAlign:
            TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}

class SeriesPage extends StatelessWidget {
  final String language;

  const SeriesPage({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${tr(language, 'series')}\n${tr(language, 'demoNote')}',
        textAlign:
            TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}

class RadioPage extends StatelessWidget {
  final String language;

  const RadioPage({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final stations = [
      RadioStation(
        name: 'Avooza Hits',
        icon:
            Icons.graphic_eq_rounded,
        colors: const [
          Color(0xFFFF6A00),
          Color(0xFFEE0979),
        ],
      ),
      RadioStation(
        name: 'News 24',
        icon:
            Icons.campaign_rounded,
        colors: const [
          Color(0xFF0575E6),
          Color(0xFF021B79),
        ],
      ),
      RadioStation(
        name: 'Quran Radio',
        icon: Icons.radio_rounded,
        colors: const [
          Color(0xFF11998E),
          Color(0xFF38EF7D),
        ],
      ),
      RadioStation(
        name: 'Chill Beats',
        icon:
            Icons.headphones_rounded,
        colors: const [
          Color(0xFF8E2DE2),
          Color(0xFF4A00E0),
        ],
      ),
    ];

    return GridView.builder(
      padding:
          const EdgeInsets.all(16),
      itemCount:
          stations.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
      ),
      itemBuilder:
          (context, index) {
        final station =
            stations[index];

        return Container(
          padding:
              const EdgeInsets.all(
            16,
          ),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            gradient:
                LinearGradient(
              colors:
                  station.colors,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Icon(
                station.icon,
                size: 36,
              ),
              const Spacer(),
              Text(
                station.name,
                style:
                    const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              Text(
                tr(
                  language,
                  'radioSub',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsScreen
    extends StatefulWidget {
  final String language;
  final ValueChanged<String>
      onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen>
      createState() =>
          _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage =
        widget.language;
  }

  Future<void>
      _clearPlaylist() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove(
      'm3u_url',
    );

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            tr(
              widget.language,
              'clearPlaylist',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(
            widget.language,
            'settings',
          ),
        ),
      ),
      body: AvoozaBackground(
        child: ListView(
          padding:
              const EdgeInsets.all(
            16,
          ),
          children: [
            DropdownButtonFormField<
                String>(
              initialValue:
                  selectedLanguage,
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child:
                      Text('English'),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  child:
                      Text('العربية'),
                ),
                DropdownMenuItem(
                  value: 'fr',
                  child:
                      Text('Français'),
                ),
                DropdownMenuItem(
                  value: 'nl',
                  child: Text(
                    'Nederlands',
                  ),
                ),
                DropdownMenuItem(
                  value: 'zh',
                  child: Text('中文'),
                ),
                DropdownMenuItem(
                  value: 'hi',
                  child:
                      Text('हिन्दी'),
                ),
              ],
              onChanged:
                  (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedLanguage =
                      value;
                });

                widget
                    .onLanguageChanged(
                  value,
                );
              },
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            ListTile(
              tileColor:
                  Colors.white
                      .withOpacity(.05),
              leading:
                  const Icon(
                Icons
                    .delete_forever_rounded,
              ),
              title: Text(
                tr(
                  widget.language,
                  'clearPlaylist',
                ),
              ),
              onTap:
                  _clearPlaylist,
            ),
            const SizedBox(
              height: 14,
            ),
            ListTile(
              tileColor:
                  Colors.white
                      .withOpacity(.05),
              leading:
                  const Icon(
                Icons
                    .info_outline_rounded,
              ),
              title: Text(
                tr(
                  widget.language,
                  'about',
                ),
              ),
              subtitle:
                  const Text(
                'AVOOZA TV 2.0',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 

