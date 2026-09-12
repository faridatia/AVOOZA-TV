import 'package:flutter/material.dart';

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

  void changeLanguage(String code) {
    setState(() {
      language = code;
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
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: LanguageScreen(
        currentLanguage: language,
        onLanguageSelected: changeLanguage,
      ),
    );
  }
}

class AppText {
  static final Map<String, Map<String, String>> data = {
    'en': {
      'chooseLanguage': 'Choose your language',
      'continue': 'Continue',
      'welcome': 'Welcome to AVOOZA TV',
      'trial': 'Start 14-Day Free Trial',
      'trialInfo': 'Enjoy all features free for 14 days.',
      'addPlaylist': 'Add Playlist',
      'xtream': 'Xtream Codes',
      'm3u': 'M3U URL',
      'file': 'M3U File',
      'qr': 'QR Code',
      'home': 'Home',
      'live': 'Live TV',
      'movies': 'Movies',
      'series': 'Series',
      'favorites': 'Favorites',
      'settings': 'Settings',
    },
    'ar': {
      'chooseLanguage': 'اختر لغتك',
      'continue': 'متابعة',
      'welcome': 'مرحبًا بك في AVOOZA TV',
      'trial': 'ابدأ التجربة المجانية لمدة 14 يومًا',
      'trialInfo': 'استمتع بجميع المزايا مجانًا لمدة 14 يومًا.',
      'addPlaylist': 'إضافة قائمة تشغيل',
      'xtream': 'Xtream Codes',
      'm3u': 'رابط M3U',
      'file': 'ملف M3U',
      'qr': 'رمز QR',
      'home': 'الرئيسية',
      'live': 'البث المباشر',
      'movies': 'الأفلام',
      'series': 'المسلسلات',
      'favorites': 'المفضلة',
      'settings': 'الإعدادات',
    },
    'fr': {
      'chooseLanguage': 'Choisissez votre langue',
      'continue': 'Continuer',
      'welcome': 'Bienvenue sur AVOOZA TV',
      'trial': 'Essai gratuit de 14 jours',
      'trialInfo': 'Profitez de toutes les fonctions gratuitement pendant 14 jours.',
      'addPlaylist': 'Ajouter une playlist',
      'xtream': 'Xtream Codes',
      'm3u': 'URL M3U',
      'file': 'Fichier M3U',
      'qr': 'Code QR',
      'home': 'Accueil',
      'live': 'TV en direct',
      'movies': 'Films',
      'series': 'Séries',
      'favorites': 'Favoris',
      'settings': 'Paramètres',
    },
    'nl': {
      'chooseLanguage': 'Kies je taal',
      'continue': 'Doorgaan',
      'welcome': 'Welkom bij AVOOZA TV',
      'trial': 'Start 14 dagen gratis',
      'trialInfo': 'Gebruik alle functies 14 dagen gratis.',
      'addPlaylist': 'Playlist toevoegen',
      'xtream': 'Xtream Codes',
      'm3u': 'M3U URL',
      'file': 'M3U-bestand',
      'qr': 'QR-code',
      'home': 'Home',
      'live': 'Live TV',
      'movies': 'Films',
      'series': 'Series',
      'favorites': 'Favorieten',
      'settings': 'Instellingen',
    },
    'zh': {
      'chooseLanguage': '选择语言',
      'continue': '继续',
      'welcome': '欢迎使用 AVOOZA TV',
      'trial': '开始14天免费试用',
      'trialInfo': '免费体验全部功能14天。',
      'addPlaylist': '添加播放列表',
      'xtream': 'Xtream Codes',
      'm3u': 'M3U 链接',
      'file': 'M3U 文件',
      'qr': '二维码',
      'home': '首页',
      'live': '直播电视',
      'movies': '电影',
      'series': '电视剧',
      'favorites': '收藏',
      'settings': '设置',
    },
    'hi': {
      'chooseLanguage': 'अपनी भाषा चुनें',
      'continue': 'जारी रखें',
      'welcome': 'AVOOZA TV में आपका स्वागत है',
      'trial': '14 दिन का निःशुल्क ट्रायल शुरू करें',
      'trialInfo': 'सभी सुविधाओं का 14 दिनों तक निःशुल्क उपयोग करें।',
      'addPlaylist': 'प्लेलिस्ट जोड़ें',
      'xtream': 'Xtream Codes',
      'm3u': 'M3U URL',
      'file': 'M3U फ़ाइल',
      'qr': 'QR कोड',
      'home': 'होम',
      'live': 'लाइव टीवी',
      'movies': 'फिल्में',
      'series': 'सीरीज़',
      'favorites': 'पसंदीदा',
      'settings': 'सेटिंग्स',
    },
  };

  static String get(String lang, String key) {
    return data[lang]?[key] ?? data['en']![key]!;
  }
}

class LanguageScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  const LanguageScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String selectedLanguage;

  final languages = const [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🌍'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'nl', 'name': 'Nederlands', 'flag': '🇳🇱'},
    {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
    {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = selectedLanguage == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF070A15),
                Color(0xFF10152A),
                Color(0xFF171038),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const AvoozaLogo(),
                      const SizedBox(height: 30),
                      Text(
                        AppText.get(selectedLanguage, 'chooseLanguage'),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: GridView.builder(
                          itemCount: languages.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 260,
                            mainAxisExtent: 95,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final item = languages[index];
                            final selected =
                                item['code'] == selectedLanguage;

                            return InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () {
                                setState(() {
                                  selectedLanguage = item['code']!;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: selected
                                      ? const Color(0xFF6E4BFF)
                                          .withOpacity(.25)
                                      : Colors.white.withOpacity(.06),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFF8D76FF)
                                        : Colors.white.withOpacity(.12),
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      item['flag']!,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        item['name']!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF9F8CFF),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF754CFF),
                          ),
                          onPressed: () {
                            widget.onLanguageSelected(selectedLanguage);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TrialScreen(
                                  language: selectedLanguage,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            AppText.get(selectedLanguage, 'continue'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrialScreen extends StatelessWidget {
  final String language;

  const TrialScreen({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF080B16),
                Color(0xFF15102F),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AvoozaLogo(),
                      const SizedBox(height: 45),
                      Text(
                        AppText.get(language, 'welcome'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        AppText.get(language, 'trialInfo'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(.72),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6D4AFF).withOpacity(.30),
                              const Color(0xFF27C6FF).withOpacity(.18),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(.12),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.workspace_premium_rounded,
                              size: 60,
                              color: Color(0xFF9E8BFF),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '14',
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'DAYS FREE',
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 38),
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF754CFF),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlaylistScreen(
                                  language: language,
                                ),
                              ),
                            );
                          },
                          label: Text(
                            AppText.get(language, 'trial'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaylistScreen extends StatelessWidget {
  final String language;

  const PlaylistScreen({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'title': AppText.get(language, 'xtream'),
        'icon': Icons.dns_rounded,
      },
      {
        'title': AppText.get(language, 'm3u'),
        'icon': Icons.link_rounded,
      },
      {
        'title': AppText.get(language, 'file'),
        'icon': Icons.upload_file_rounded,
      },
      {
        'title': AppText.get(language, 'qr'),
        'icon': Icons.qr_code_2_rounded,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AVOOZA TV'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  AppText.get(language, 'addPlaylist'),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: GridView.builder(
                    itemCount: options.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 360,
                      mainAxisExtent: 160,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                    ),
                    itemBuilder: (context, index) {
                      final item = options[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(26),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(
                                language: language,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF734BFF).withOpacity(.28),
                                const Color(0xFF16B9FF).withOpacity(.12),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(.12),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 50,
                                color: const Color(0xFF9F8DFF),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
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
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String language;

  const HomeScreen({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      {
        'title': AppText.get(language, 'live'),
        'icon': Icons.live_tv_rounded,
      },
      {
        'title': AppText.get(language, 'movies'),
        'icon': Icons.movie_rounded,
      },
      {
        'title': AppText.get(language, 'series'),
        'icon': Icons.video_library_rounded,
      },
      {
        'title': AppText.get(language, 'favorites'),
        'icon': Icons.favorite_rounded,
      },
    ];

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
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          itemCount: sections.length,
          gridDelegate:
              const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            mainAxisExtent: 220,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final section = sections[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF754CFF).withOpacity(.35),
                    const Color(0xFF0DBDFF).withOpacity(.12),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(.10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    section['icon'] as IconData,
                    size: 62,
                    color: const Color(0xFF9F8DFF),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    section['title'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AvoozaLogo extends StatelessWidget {
  const AvoozaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF885CFF),
                Color(0xFF2AB6FF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF754CFF).withOpacity(.35),
                blurRadius: 35,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            size: 56,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'AVOOZA',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
        Text(
          'TV',
          style: TextStyle(
            fontSize: 15,
            letterSpacing: 8,
            color: Colors.white.withOpacity(.60),
          ),
        ),
      ],
    );
  }
}
