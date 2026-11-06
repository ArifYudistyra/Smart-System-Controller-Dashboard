import 'package:flutter/material.dart';

void main() => runApp(const NodusApp());

class NodusApp extends StatelessWidget {
  const NodusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nodus',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008F86)),
        scaffoldBackgroundColor: const Color(0xFFF2F6F6),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool login = true;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width > 700;
    final form = _AuthForm(
      login: login,
      onSuccess: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      },
      onToggle: () => setState(() => login = !login),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          if (wide)
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(48),
                color: const Color(0xFF10262D),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Brand(),
                    Spacer(),
                    Text(
                      'SMART SYSTEM, SIMPLIFIED',
                      style: TextStyle(
                        color: Color(0xFF66E5CF),
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Semua ruang Anda,\ndalam satu kendali.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        height: 1.05,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Pantau sensor, kendalikan aktuator, dan jaga semua perangkat tetap sinkron dari mana saja.',
                      style: TextStyle(
                        color: Color(0xFFB7CDCF),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Data privat per pengguna · Akses master terkontrol',
                      style: TextStyle(color: Color(0xFFB7CDCF), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            flex: wide ? 4 : 10,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SingleChildScrollView(child: form),
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF66E5CF),
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Text(
          'N',
          style: TextStyle(
            color: Color(0xFF10262D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 10),
      const Text(
        'Nodus',
        style: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.login,
    required this.onSuccess,
    required this.onToggle,
  });
  final bool login;
  final VoidCallback onSuccess;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 430),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SELAMAT DATANG',
            style: TextStyle(
              color: Color(0xFF008F86),
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            login ? 'Masuk ke ruang Anda' : 'Buat ruang kendali',
            style: const TextStyle(
              fontSize: 34,
              height: 1.1,
              fontWeight: FontWeight.w700,
              color: Color(0xFF152F37),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            login
                ? 'Gunakan akun yang sudah terdaftar.'
                : 'Mulai hubungkan sistem pintar Anda.',
            style: const TextStyle(color: Color(0xFF61777D)),
          ),
          const SizedBox(height: 32),
          if (!login) ...[
            _field('Nama lengkap', 'Nama Anda'),
            const SizedBox(height: 16),
          ],
          _field('Email', 'nama@email.com'),
          const SizedBox(height: 16),
          _field('Kata sandi', 'Minimal 8 karakter', obscure: true),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onSuccess,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF008F86),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(login ? 'Masuk' : 'Daftar akun'),
          ),
          TextButton(
            onPressed: onToggle,
            child: Text(
              login ? 'Belum punya akun? Daftar' : 'Sudah punya akun? Masuk',
              style: const TextStyle(color: Color(0xFF008F86)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String hint, {bool obscure = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ],
  );
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 0;
  bool pump = false;

  static const devices = [
    (
      'Greenhouse Utama',
      'ND-GH01',
      '28,4 °C',
      '72% RH · Tanah 46%',
      true,
      Icons.eco_outlined,
    ),
    (
      'Hidroponik Teras',
      'ND-HY02',
      'pH 6,2',
      'Air 24,8 °C',
      true,
      Icons.water_outlined,
    ),
    (
      'Akuarium Ruang',
      'ND-AQ03',
      '26,1 °C',
      'Level air 82%',
      true,
      Icons.waves_outlined,
    ),
    (
      'Kebun Samping',
      'ND-GD04',
      'Tanah 38%',
      'Data terakhir tidak terkini',
      false,
      Icons.grass_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final titles = ['Beranda', 'Perangkat', 'Aktivitas', 'Akun'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              index == 0 ? 'Selamat pagi, Arif' : titles[index],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const Text(
              'Ruang pribadi · Semua sistem normal',
              style: TextStyle(fontSize: 12, color: Color(0xFF61777D)),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
        toolbarHeight: 78,
      ),
      body: SafeArea(top: false, child: _body()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE3F5F0),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_outlined),
            selectedIcon: Icon(Icons.devices),
            label: 'Perangkat',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            label: 'Aktivitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (index == 1) return _devicePage();
    if (index == 2)
      return _simplePage(
        'Aktivitas',
        'Belum ada aktivitas baru',
        'Sinkronisasi perangkat akan muncul di sini.',
      );
    if (index == 3) return _accountPage();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        _summaryCard(),
        const SizedBox(height: 16),
        _chartCard(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F5F0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(Icons.cloud_done_outlined, color: Color(0xFF008F86)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tetap sinkron, meski aplikasi ditutup',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Perangkat mengirim data langsung ke cloud.',
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Ruang kendali',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...devices.map(
          (d) => _deviceCard(d, pump, (value) => setState(() => pump = value)),
        ),
      ],
    );
  }

  Widget _summaryCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF10262D),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERANGKAT SAYA',
          style: TextStyle(
            color: Color(0xFFB7CDCF),
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              '04',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 48,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 16),
            Text(
              'perangkat tertaut\nhanya milik Anda',
              style: TextStyle(
                color: Color(0xFFB7CDCF),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        LinearProgressIndicator(
          value: 0.75,
          minHeight: 5,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xFF66E5CF),
          backgroundColor: Color(0xFF7D6950),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '●  3 online',
              style: TextStyle(color: Color(0xFF66E5CF), fontSize: 12),
            ),
            Text(
              '●  1 offline',
              style: TextStyle(color: Color(0xFFE5BD7F), fontSize: 12),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Sinkronisasi terakhir · baru saja',
          style: TextStyle(color: Color(0xFFB7CDCF), fontSize: 11),
        ),
      ],
    ),
  );

  Widget _chartCard() => Container(
    height: 220,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFDFE8E9)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUHU GREENHOUSE',
          style: TextStyle(
            color: Color(0xFF008F86),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          '28,4 °C',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        CustomPaint(
          size: const Size(double.infinity, 110),
          painter: _ChartPainter(),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '00.00',
              style: TextStyle(fontSize: 9, color: Color(0xFF61777D)),
            ),
            Text(
              '06.00',
              style: TextStyle(fontSize: 9, color: Color(0xFF61777D)),
            ),
            Text(
              '12.00',
              style: TextStyle(fontSize: 9, color: Color(0xFF61777D)),
            ),
            Text(
              '18.00',
              style: TextStyle(fontSize: 9, color: Color(0xFF61777D)),
            ),
            Text(
              'Sekarang',
              style: TextStyle(fontSize: 9, color: Color(0xFF61777D)),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _devicePage() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text(
        'Semua perangkat',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 12),
      ...devices.map(
        (d) => _deviceCard(d, pump, (value) => setState(() => pump = value)),
      ),
    ],
  );

  Widget _deviceCard(
    (String, String, String, String, bool, IconData) d,
    bool pump,
    ValueChanged<bool> onPump,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFDFE8E9)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F5F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(d.$6, color: const Color(0xFF008F86)),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.$1, style: const TextStyle(fontSize: 14)),
                  Text(
                    d.$2,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF61777D),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: d.$5 ? const Color(0xFFE3F5F0) : const Color(0xFFFFF0D9),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                d.$5 ? '●  Online' : '●  Offline',
                style: TextStyle(
                  fontSize: 10,
                  color: d.$5
                      ? const Color(0xFF007F78)
                      : const Color(0xFFA56E16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.$3,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  d.$4,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF61777D),
                  ),
                ),
              ],
            ),
            if (d.$1 == 'Greenhouse Utama')
              Switch(
                value: pump,
                onChanged: onPump,
                activeColor: const Color(0xFF008F86),
              ),
          ],
        ),
      ],
    ),
  );

  Widget _simplePage(String title, String headline, String body) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 52, color: Color(0xFF008F86)),
          const SizedBox(height: 16),
          Text(
            headline,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF61777D)),
          ),
        ],
      ),
    ),
  );

  Widget _accountPage() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDFE8E9)),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFF66E5CF),
              child: const Text(
                'AR',
                style: TextStyle(
                  color: Color(0xFF10262D),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Arif',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const Text(
              'arif@email.com',
              style: TextStyle(color: Color(0xFF61777D)),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              ),
              child: const Text('Keluar'),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFEEF3F3)
      ..strokeWidth = 1;
    for (var y = 0; y < size.height; y += 36)
      canvas.drawLine(
        Offset(0, y.toDouble()),
        Offset(size.width, y.toDouble()),
        grid,
      );
    final line = Paint()
      ..color = const Color(0xFF008F86)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * .82)
      ..cubicTo(
        size.width * .12,
        size.height * .72,
        size.width * .18,
        size.height * .42,
        size.width * .28,
        size.height * .55,
      )
      ..cubicTo(
        size.width * .42,
        size.height * .75,
        size.width * .50,
        size.height * .32,
        size.width * .62,
        size.height * .38,
      )
      ..cubicTo(
        size.width * .78,
        size.height * .50,
        size.width * .86,
        size.height * .24,
        size.width,
        size.height * .08,
      );
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
