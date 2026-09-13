import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const AvoozaApp());

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
    setState(() => lang = p.getString('language') ?? 'en');
  }

  Future<void> _setLang(String value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('language', value);
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
      'home':'Home','live':'Live TV','movies':'Movies','series':'Series','radio':'Radio','settings':'Settings','language':'Language','watch':'Watch Now','stories':'A World of Stories','storySub':'Global entertainment in your language.','add':'Add M3U URL','change':'Change Playlist','search':'Search channels...','previous':'Previous','next':'Next','changeChannel':'Change channel','clear':'Remove saved playlist','about':'About AVOOZA TV','noChannels':'No channels yet','connect':'Connect','cancel':'Cancel'
    },
    'ar': {
      'home':'الرئيسية','live':'البث المباشر','movies':'الأفلام','series':'المسلسلات','radio':'الراديو','settings':'الإعدادات','language':'اللغة','watch':'شاهد الآن','stories':'عالم من القصص','storySub':'ترفيه عالمي بلغتك.','add':'إضافة رابط M3U','change':'تغيير القائمة','search':'ابحث عن القنوات...','previous':'السابق','next':'التالي','changeChannel':'تغيير القناة','clear':'حذف القائمة المحفوظة','about':'حول AVOOZA TV','noChannels':'لا توجد قنوات بعد','connect':'اتصال','cancel':'إلغاء'
    },
    'fr': {
      'home':'Accueil','live':'TV en direct','movies':'Films','series':'Séries','radio':'Radio','settings':'Paramètres','language':'Langue','watch':'Regarder','stories':'Un monde d’histoires','storySub':'Divertissement mondial dans votre langue.','add':'Ajouter URL M3U','change':'Changer playlist','search':'Rechercher des chaînes...','previous':'Précédent','next':'Suivant','changeChannel':'Changer de chaîne','clear':'Supprimer la playlist','about':'À propos de AVOOZA TV','noChannels':'Aucune chaîne','connect':'Connecter','cancel':'Annuler'
    },
    'nl': {
      'home':'Home','live':'Live TV','movies':'Films','series':'Series','radio':'Radio','settings':'Instellingen','language':'Taal','watch':'Nu kijken','stories':'Een wereld vol verhalen','storySub':'Wereldwijd entertainment in jouw taal.','add':'M3U URL toevoegen','change':'Playlist wijzigen','search':'Zoek kanalen...','previous':'Vorige','next':'Volgende','changeChannel':'Kanaal wijzigen','clear':'Playlist verwijderen','about':'Over AVOOZA TV','noChannels':'Nog geen kanalen','connect':'Verbinden','cancel':'Annuleren'
    },
    'zh': {
      'home':'首页','live':'直播','movies':'电影','series':'剧集','radio':'广播','settings':'设置','language':'语言','watch':'立即观看','stories':'故事的世界','storySub':'用你的语言享受全球娱乐。','add':'添加 M3U 链接','change':'更改播放列表','search':'搜索频道...','previous':'上一项','next':'下一项','changeChannel':'切换频道','clear':'删除播放列表','about':'关于 AVOOZA TV','noChannels':'暂无频道','connect':'连接','cancel':'取消'
    },
    'hi': {
      'home':'होम','live':'लाइव टीवी','movies':'फ़िल्में','series':'सीरीज़','radio':'रेडियो','settings':'सेटिंग्स','language':'भाषा','watch':'अभी देखें','stories':'कहानियों की दुनिया','storySub':'आपकी भाषा में वैश्विक मनोरंजन।','add':'M3U URL जोड़ें','change':'प्लेलिस्ट बदलें','search':'चैनल खोजें...','previous':'पिछला','next':'अगला','changeChannel':'चैनल बदलें','clear':'प्लेलिस्ट हटाएँ','about':'AVOOZA TV के बारे में','noChannels':'अभी कोई चैनल नहीं','connect':'कनेक्ट','cancel':'रद्द करें'
    },
  };
  return data[lang]?[key] ?? data['en']![key] ?? key;
}

class Channel {
  final String name;
  final String url;
  final String group;
  const Channel(this.name, this.url, this.group);
}

class HomeShell extends StatefulWidget {
  final String lang;
  final ValueChanged<String> onLangChanged;
  const HomeShell({super.key, required this.lang, required this.onLangChanged});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(lang: widget.lang, openTab: (i) => setState(() => index = i)),
      LivePage(lang: widget.lang),
      PlaceholderPage(title: t(widget.lang,'movies'), icon: Icons.movie_rounded),
      PlaceholderPage(title: t(widget.lang,'series'), icon: Icons.video_library_rounded),
      RadioPage(lang: widget.lang),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B1B),
        title: const Text('AVOOZA TV 2.0', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: _language, icon: const Icon(Icons.language_rounded)),
          IconButton(onPressed: _settings, icon: const Icon(Icons.settings_rounded)),
        ],
      ),
      body: NeonBackground(child: IndexedStack(index: index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        backgroundColor: const Color(0xFF070B1B),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: t(widget.lang,'home')),
          NavigationDestination(icon: const Icon(Icons.live_tv_outlined), selectedIcon: const Icon(Icons.live_tv_rounded), label: t(widget.lang,'live')),
          NavigationDestination(icon: const Icon(Icons.movie_outlined), selectedIcon: const Icon(Icons.movie_rounded), label: t(widget.lang,'movies')),
          NavigationDestination(icon: const Icon(Icons.video_library_outlined), selectedIcon: const Icon(Icons.video_library_rounded), label: t(widget.lang,'series')),
          NavigationDestination(icon: const Icon(Icons.radio_outlined), selectedIcon: const Icon(Icons.radio_rounded), label: t(widget.lang,'radio')),
        ],
      ),
    );
  }

  void _language() {
    const langs = {'en':'English','ar':'العربية','fr':'Français','nl':'Nederlands','zh':'中文','hi':'हिन्दी'};
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1128),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: langs.entries.map((e) => ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(e.value),
            trailing: widget.lang == e.key ? const Icon(Icons.check_circle_rounded) : null,
            onTap: () { widget.onLangChanged(e.key); Navigator.pop(context); },
          )).toList(),
        ),
      ),
    );
  }

  void _settings() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(lang: widget.lang, onLangChanged: widget.onLangChanged)));
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
          colors: [Color(0xFF050817), Color(0xFF0C1230), Color(0xFF160B36)],
        ),
      ),
      child: child,
    );
  }
}

class HomePage extends StatelessWidget {
  final String lang;
  final ValueChanged<int> openTab;
  const HomePage({super.key, required this.lang, required this.openTab});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(colors: [Color(0xFF10204C), Color(0xFF122D64), Color(0xFF32115D)]),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t(lang,'stories'), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t(lang,'storySub'), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 18),
            FilledButton.icon(onPressed: () => openTab(1), icon: const Icon(Icons.play_arrow_rounded), label: Text(t(lang,'watch'))),
          ]),
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
            _tile(context, t(lang,'live'), Icons.live_tv_rounded, const [Color(0xFF0066FF),Color(0xFF00C6FF)], () => openTab(1)),
            _tile(context, t(lang,'movies'), Icons.movie_rounded, const [Color(0xFF7F00FF),Color(0xFFE100FF)], () => openTab(2)),
            _tile(context, t(lang,'series'), Icons.video_library_rounded, const [Color(0xFFB400FF),Color(0xFFFF4D96)], () => openTab(3)),
            _tile(context, t(lang,'radio'), Icons.radio_rounded, const [Color(0xFFFF7A18),Color(0xFFFFB74D)], () => openTab(4)),
          ],
        ),
      ]),
    );
  }

  Widget _tile(BuildContext context, String title, IconData icon, List<Color> colors, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: LinearGradient(colors: colors)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 36),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class LivePage extends StatefulWidget {
  final String lang;
  const LivePage({super.key, required this.lang});
  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final m3u = TextEditingController();
  final search = TextEditingController();
  List<Channel> all = [];
  List<Channel> visible = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _restore();
    search.addListener(_filter);
  }

  Future<void> _restore() async {
    final p = await SharedPreferences.getInstance();
    final saved = p.getString('m3u_url') ?? '';
    m3u.text = saved;
    if (saved.isNotEmpty) await _load(saved, silent: true);
  }

  void _filter() {
    final q = search.text.toLowerCase().trim();
    setState(() => visible = q.isEmpty ? List.from(all) : all.where((c) => c.name.toLowerCase().contains(q)).toList());
  }

  Future<http.Response> _get(String url) async {
    try {
      return await http.get(Uri.parse(url));
    } catch (e) {
      final s = e.toString().toLowerCase();
      if (url.startsWith('https://') && (s.contains('wrong_version_number') || s.contains('handshake') || s.contains('ssl'))) {
        return http.get(Uri.parse(url.replaceFirst('https://','http://')));
      }
      rethrow;
    }
  }

  Future<void> _load(String url, {bool silent = false}) async {
    setState(() => loading = true);
    try {
      final r = await _get(url);
      if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode}');
      final lines = r.body.split('\n');
      final result = <Channel>[];
      String? name;
      String group = '';
      for (final raw in lines) {
        final line = raw.trim();
        if (line.startsWith('#EXTINF')) {
          group = RegExp(r'group-title="([^"]*)"').firstMatch(line)?.group(1) ?? '';
          final comma = line.lastIndexOf(',');
          name = comma >= 0 ? line.substring(comma + 1).trim() : 'Channel ${result.length + 1}';
        } else if (line.startsWith('http://') || line.startsWith('https://')) {
          result.add(Channel(name ?? 'Channel ${result.length + 1}', line, group));
          name = null;
          group = '';
        }
      }
      final p = await SharedPreferences.getInstance();
      await p.setString('m3u_url', url);
      setState(() { all = result; visible = List.from(result); });
      if (!silent && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${result.length} channels loaded')));
    } catch (e) {
      if (!silent && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Playlist error: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _dialog() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(t(widget.lang,'add')),
      content: TextField(controller: m3u, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'http://example.com/playlist.m3u')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(t(widget.lang,'cancel'))),
        FilledButton(onPressed: () { final u = m3u.text.trim(); Navigator.pop(context); if (u.isNotEmpty) _load(u); }, child: Text(t(widget.lang,'connect'))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [Expanded(child: FilledButton.icon(onPressed: _dialog, icon: const Icon(Icons.add_link), label: Text(t(widget.lang,'change'))))]),
          const SizedBox(height: 10),
          TextField(controller: search, decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: t(widget.lang,'search'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)))),
        ]),
      ),
      Expanded(child: loading
        ? const Center(child: CircularProgressIndicator())
        : visible.isEmpty
          ? Center(child: FilledButton(onPressed: _dialog, child: Text(t(widget.lang,'add'))))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: visible.length,
              separatorBuilder: (_, i) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final c = visible[i];
                final actual = all.indexOf(c);
                return ListTile(
                  tileColor: Colors.white.withOpacity(.06),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  leading: const CircleAvatar(child: Icon(Icons.live_tv_rounded)),
                  title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(c.group.isEmpty ? c.url : c.group, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.play_arrow_rounded),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerPage(lang: widget.lang, channels: all, initialIndex: actual))),
                );
              },
            )),
    ]);
  }
}

class PlayerPage extends StatefulWidget {
  final String lang;
  final List<Channel> channels;
  final int initialIndex;
  const PlayerPage({super.key, required this.lang, required this.channels, required this.initialIndex});
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late int index;
  VideoPlayerController? controller;
  bool loading = true;
  String? error;

  Channel get current => widget.channels[index];

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
    _play();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    setState(() { loading = true; error = null; });
    await controller?.dispose();
    try {
      final c = VideoPlayerController.networkUrl(Uri.parse(current.url));
      controller = c;
      await c.initialize();
      await c.play();
      if (mounted) setState(() => loading = false);
    } catch (e) {
      if (mounted) setState(() { loading = false; error = e.toString(); });
    }
  }

  Future<void> _change(int i) async {
    if (i < 0 || i >= widget.channels.length) return;
    setState(() => index = i);
    await _play();
  }

  void _picker() {
    showModalBottomSheet(context: context, builder: (_) => SafeArea(child: ListView.builder(
      itemCount: widget.channels.length,
      itemBuilder: (_, i) => ListTile(
        leading: Icon(i == index ? Icons.play_circle_fill : Icons.tv),
        title: Text(widget.channels[i].name),
        onTap: () { Navigator.pop(context); _change(i); },
      ),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(current.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [IconButton(onPressed: _picker, icon: const Icon(Icons.playlist_play_rounded))],
      ),
      body: NeonBackground(child: Column(children: [
        Expanded(child: Center(
          child: loading
            ? const CircularProgressIndicator()
            : error != null
              ? Padding(padding: const EdgeInsets.all(20), child: Text(error!))
              : AspectRatio(aspectRatio: controller!.value.aspectRatio, child: VideoPlayer(controller!)),
        )),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: OutlinedButton(onPressed: index > 0 ? () => _change(index - 1) : null, child: Text(t(widget.lang,'previous')))),
            const SizedBox(width: 8),
            Expanded(child: FilledButton(onPressed: _picker, child: Text(t(widget.lang,'changeChannel')))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: index < widget.channels.length - 1 ? () => _change(index + 1) : null, child: Text(t(widget.lang,'next')))),
          ]),
        ),
      ])),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const PlaceholderPage({super.key, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 72, color: const Color(0xFF7B5CFF)),
      const SizedBox(height: 14),
      Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Xtream/VOD connection comes next.'),
    ]));
  }
}

class RadioPage extends StatelessWidget {
  final String lang;
  const RadioPage({super.key, required this.lang});
  @override
  Widget build(BuildContext context) {
    const stations = [
      ('Avooza Hits', Icons.graphic_eq_rounded, [Color(0xFFFF6A00),Color(0xFFEE0979)]),
      ('News 24', Icons.campaign_rounded, [Color(0xFF0575E6),Color(0xFF021B79)]),
      ('Quran Radio', Icons.radio_rounded, [Color(0xFF11998E),Color(0xFF38EF7D)]),
      ('Chill Beats', Icons.headphones_rounded, [Color(0xFF8E2DE2),Color(0xFF4A00E0)]),
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14),
      itemBuilder: (_, i) {
        final s = stations[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: LinearGradient(colors: s.$3)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(s.$2, size: 36),
            const Spacer(),
            Text(s.$1, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
        );
      },
    );
  }
}

class SettingsPage extends StatefulWidget {
  final String lang;
  final ValueChanged<String> onLangChanged;
  const SettingsPage({super.key, required this.lang, required this.onLangChanged});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String lang;
  @override
  void initState() { super.initState(); lang = widget.lang; }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t(widget.lang,'settings'))),
      body: NeonBackground(child: ListView(padding: const EdgeInsets.all(16), children: [
        DropdownButtonFormField<String>(
          initialValue: lang,
          items: const [
            DropdownMenuItem(value:'en', child:Text('English')),
            DropdownMenuItem(value:'ar', child:Text('العربية')),
            DropdownMenuItem(value:'fr', child:Text('Français')),
            DropdownMenuItem(value:'nl', child:Text('Nederlands')),
            DropdownMenuItem(value:'zh', child:Text('中文')),
            DropdownMenuItem(value:'hi', child:Text('हिन्दी')),
          ],
          onChanged: (v) { if (v == null) return; setState(() => lang = v); widget.onLangChanged(v); },
          decoration: InputDecoration(labelText: t(widget.lang,'language'), border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        ListTile(
          tileColor: Colors.white.withOpacity(.05),
          leading: const Icon(Icons.delete_forever_rounded),
          title: Text(t(widget.lang,'clear')),
          onTap: () async { final p = await SharedPreferences.getInstance(); await p.remove('m3u_url'); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Playlist removed'))); },
        ),
        const SizedBox(height: 14),
        ListTile(tileColor: Colors.white.withOpacity(.05), leading: const Icon(Icons.info_outline_rounded), title: Text(t(widget.lang,'about')), subtitle: const Text('Version 2.0')),
      ])),
    );
  }
}
