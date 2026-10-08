import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart' show Package;
import '../services/purchase_service.dart';
import '../state/app_state.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  List<Package> _pk = [];
  bool _busy = false;
  bool _yearly = true;

  @override
  void initState() {
    super.initState();
    if (PurchaseService.live) {
      PurchaseService.packages().then((p) {
        if (mounted) setState(() => _pk = p);
      });
    }
  }

  Future<void> _finish(bool ok) async {
    final st = context.read<AppState>();
    final nav = Navigator.of(context);
    final msg = ScaffoldMessenger.of(context);
    if (ok) {
      await st.setPro(true);
      nav.pop(true);
    } else {
      msg.showSnackBar(
          const SnackBar(content: Text('Pembelian belum berhasil.')));
    }
  }

  Future<void> _buy(Package p) async {
    setState(() => _busy = true);
    final ok = await PurchaseService.buy(p);
    if (mounted) setState(() => _busy = false);
    if (mounted) await _finish(ok);
  }

  Future<void> _restore() async {
    setState(() => _busy = true);
    final ok = await PurchaseService.restore();
    if (mounted) setState(() => _busy = false);
    if (mounted) await _finish(ok);
  }

  Widget _plan(
      String title, String price, String note, bool sel, VoidCallback f) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
            width: 2,
            color: sel
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(note),
        trailing:
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: f,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final live = PurchaseService.live;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Belajar Jerman tanpa batas',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const Text('✅ Semua pelajaran A1 sampai B1\n'
              '✅ Latihan ucapan tanpa batas\n'
              '✅ Tanpa iklan\n'
              '✅ Bisa dipakai tanpa internet'),
          const SizedBox(height: 16),
          if (live) ...[
            if (_pk.isEmpty) const Center(child: CircularProgressIndicator()),
            for (final p in _pk)
              _plan(p.storeProduct.title, p.storeProduct.priceString,
                  p.storeProduct.description, false,
                  _busy ? () {} : () => _buy(p)),
            TextButton(
                onPressed: _busy ? null : _restore,
                child: const Text('Pulihkan pembelian')),
          ] else ...[
            _plan('Tahunan', 'Rp 349.000', 'Hemat 40%', _yearly,
                () => setState(() => _yearly = true)),
            _plan('Bulanan', 'Rp 49.000', 'Bisa dibatalkan kapan saja',
                !_yearly, () => setState(() => _yearly = false)),
            const SizedBox(height: 8),
            FilledButton(
                onPressed: () => _finish(true),
                child: const Text('Mulai uji coba (mode demo)')),
            const SizedBox(height: 8),
            const Text(
              'Mode demo: tidak ada pembayaran sungguhan. Isi RC_API_KEY untuk mengaktifkan pembelian asli lewat RevenueCat.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Nanti saja')),
        ],
      ),
    );
  }
}
