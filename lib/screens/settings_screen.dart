import 'package:flutter/material.dart';
import '../services/shop_services.dart';

const Color _accentColor = Color(0xFF17A398);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _sectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _accentColor),
                const SizedBox(width: 10),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRestore(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore backup?'),
        content: const Text(
            'This replaces ALL current products, bills, and customers with the backup file\'s data. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ShopServices.restoreDatabase(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),

              _sectionCard(
                context: context,
                title: 'Data & Backup',
                icon: Icons.backup_outlined,
                children: [
                  Text(
                    'Your data lives entirely on this computer. Back it up regularly, especially before restoring an older file.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => ShopServices.backupDatabase(context),
                        icon: const Icon(Icons.save_alt, size: 18),
                        label: const Text('Backup Database'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _confirmRestore(context),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red),
                        icon: const Icon(Icons.restore, size: 18),
                        label: const Text('Restore Database'),
                      ),
                    ],
                  ),
                ],
              ),

              _sectionCard(
                context: context,
                title: 'About',
                icon: Icons.info_outline,
                children: const [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.storefront, color: _accentColor),
                    title: Text('Shop Manager'),
                    subtitle: Text('v1.0.0 - Desktop Edition'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.wifi_off, color: _accentColor),
                    title: Text('Fully offline'),
                    subtitle:
                        Text('All data is stored locally. No internet connection required.'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.person_outline, color: _accentColor),
                    title: Text('Developer'),
                    subtitle: Text('Jamshaid Niazi'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.business_outlined, color: _accentColor),
                    title: Text('Developed by'),
                    subtitle: Text('Niazi Tech'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
