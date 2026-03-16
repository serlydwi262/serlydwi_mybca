import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyBCAHome()));

class MyBCAHome extends StatefulWidget {
  const MyBCAHome({super.key});
  @override
  State<MyBCAHome> createState() => _MyBCAHomeState();
}

class _MyBCAHomeState extends State<MyBCAHome> {
  bool _isBalVisible = false, _showCopy = false;
  final String _accNo = "012-345-XXXX";

  // Data Menu Utama
  final List<Map<String, dynamic>> _mainMenus = [
    {'i': Icons.swap_horiz, 'l': 'Transfer'}, {'i': Icons.payment, 'l': 'Bayar & Isi Saldo'},
    {'i': Icons.trending_up, 'l': 'Welma'}, {'i': Icons.shopping_bag_outlined, 'l': 'Lifestyle'},
    {'i': Icons.description_outlined, 'l': 'e-Statement'}, {'i': Icons.credit_card, 'l': 'Flazz'},
    {'i': Icons.phonelink_ring, 'l': 'Cardless'}, {'i': Icons.grid_view_rounded, 'l': 'Semua'},
  ];

  // Data Menu yang Tersembunyi (Akan muncul di menu 'semua')
  final List<Map<String, dynamic>> _hiddenMenus = [
    {'i': Icons.show_chart, 'l': 'investasi'}, {'i': Icons.security, 'l': 'Proteksi'},
    {'i': Icons.business_center_outlined, 'l': 'Produk Bank'}, {'i': Icons.history, 'l': 'RiwayatTransaksi'},   
  ];

  void _copy() {
    Clipboard.setData(ClipboardData(text: _accNo));
    setState(() => _showCopy = true);
    Timer(const Duration(seconds: 1), () => setState(() => _showCopy = false));
  }

  void _openBottomSheet() {
    // Menggabungkan menu utama (kecuali tombol 'Semua') dengan menu tersembunyi
    final allFeatures = [..._mainMenus.where((m) => m['l'] != 'Semua'), ..._hiddenMenus];

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (c) => Container(
        padding: const EdgeInsets.all(20), height: 450,
        child: Column(children: [
          Container(width: 40, height: 4, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text("Semua Fitur", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          Expanded(child: GridView.count(crossAxisCount: 4, children: allFeatures.map((m) => _item(m['i'], m['l'])).toList())),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F9FF),
    body: Stack(children: [
      _bgHeader(),
      SafeArea(child: SingleChildScrollView(child: Column(children: [
        _topBar(), _card(), const SizedBox(height: 20), _gridMenu(), const SizedBox(height: 20), _promo(),
      ]))),
    ]),
    bottomNavigationBar: _nav(),
    floatingActionButton: FloatingActionButton(onPressed: (){}, backgroundColor: const Color(0xFF00A3E0), shape: const CircleBorder(), child: const Icon(Icons.qr_code_scanner, color: Colors.white)),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );

  Widget _bgHeader() => Container(height: 260, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF00569E), Color(0xFF002D57)]), borderRadius: BorderRadius.vertical(bottom: Radius.circular(35))));

  Widget _topBar() => Padding(padding: const EdgeInsets.all(20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    const Text("myBCA", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
    Row(children: const [Icon(Icons.headset_mic_outlined, color: Colors.white), SizedBox(width: 15), Icon(Icons.settings_outlined, color: Colors.white), SizedBox(width:15), Icon(Icons.logout, color: Colors.white)]),
  ]));
  
  Widget _card() => Container(margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [
    Container(padding: const EdgeInsets.all(15), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF63D8D5), Color(0xFF00569E)]), borderRadius: BorderRadius.vertical(top: Radius.circular(20))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("HALLO, SERLY DWI RAHAYU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      Row(children: [
        Text("Rekening: $_accNo", style: const TextStyle(color: Colors.white, fontSize: 12)), const SizedBox(width: 8),
        Stack(clipBehavior: Clip.none, children: [GestureDetector(onTap: _copy, child: const Icon(Icons.copy, color: Colors.white, size: 14)), if(_showCopy) Positioned(top: -25, left: -10, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)), child: const Text("salin", style: TextStyle(color: Colors.white, fontSize: 10))))])
      ]),
    ])),
    ListTile(
      title: const Text("Saldo Aktif", style: TextStyle(color: Colors.grey, fontSize: 12)),
      subtitle: Text(_isBalVisible ? "IDR 1.500.000" : "IDR ********", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF002D57))),
      trailing: IconButton(icon: Icon(_isBalVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isBalVisible = !_isBalVisible)),  
    ),
    const Divider(height: 1),
    Row(children: [_btn(Icons.history, "Mutasi Rekening"), _btn(Icons.wallet, "Rekening Lain")]),
  ]));

  Widget _gridMenu() => Container(margin: const EdgeInsets.symmetric(horizontal:20), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius. circular(25)), child: GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, children: _mainMenus.map((m) => GestureDetector(onTap: () => m['l'] == 'Semua' ? _openBottomSheet() : null, child: _item(m['i'], m['l']))).toList()));

  Widget _item(IconData i, String l) => Column(children: [CircleAvatar(radius: 25, backgroundColor: const Color(0xFF00569E).withOpacity(0.1), child: Icon(i, color: const Color(0xFF00569E))), const SizedBox(height: 4), Text(l, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]);
  
  Widget _btn(IconData i, String l) => Expanded(child: TextButton.icon(onPressed: () {}, icon: Icon(i, size: 16), label: Text(l, style: const TextStyle(fontSize: 12))));
  
  Widget _promo() => Container(margin: const EdgeInsets.symmetric(horizontal: 20), height: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF003366), Color(0xFF00509E)])), child: const Center(child: Text("paylater BCA", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))));

  Widget _nav() => BottomAppBar(height: 70, color: const Color(0xFF002D57), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_ni(Icons.home, "Beranda", true), _ni(Icons.list_alt, "Aktivitas", false), const SizedBox(width: 40), _ni(Icons.notifications, "Notif", false), _ni(Icons.person, "Akun", false)]));

  Widget _ni(IconData i, String l, bool a) => Column(mainAxisSize: MainAxisSize.min, children: [Icon(i, color: a ? Colors.white : Colors.white54, size: 22), Text(l, style: TextStyle(color: a ? Colors.white : Colors.white54, fontSize: 9))]);
}
