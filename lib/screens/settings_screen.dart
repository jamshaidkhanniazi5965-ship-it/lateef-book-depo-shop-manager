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

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Text(
              "This software (\"Lateef Book Depo\") is developed and owned by Jamshaid Niazi and his company Niazi Tech. All rights to this application, including its source code, design, and functionality, are reserved to the developer.\n\n"
              "1. Ownership: This application is proprietary software. Jamshaid Niazi and Niazi Tech retain full ownership and all intellectual property rights.\n\n"
              "2. License to Use: This software is licensed, not sold, for use only by the person or business it was provided to. It may not be copied, resold, redistributed, or shared without prior written permission from Jamshaid Niazi.\n\n"
              "3. No Unauthorized Use: Reproducing, modifying, reverse-engineering, or reselling this software without explicit permission is strictly prohibited.\n\n"
              "4. Data: All data entered into this application is stored locally on the user's device. The developer is not responsible for data loss due to hardware failure, improper use, or lack of backups.\n\n"
              "5. No Warranty: This software is provided \"as is\" without warranty of any kind. The developer is not liable for any business losses arising from its use.\n\n"
              "6. Contact: For permissions, support, or licensing inquiries, contact Jamshaid Niazi (Niazi Tech) at jamshaidkhanniazi.5965@gmail.com.\n\n"
              "\u00A9 2026 Jamshaid Niazi / Niazi Tech. All rights reserved.",
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.storefront, color: _accentColor),
                    title: Text('Lateef Book Depo'),
                    subtitle: Text('v1.0.0 - Desktop Edition'),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.wifi_off, color: _accentColor),
                    title: Text('Fully offline'),
                    subtitle:
                        Text('All data is stored locally. No internet connection required.'),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.person_outline, color: _accentColor),
                    title: Text('Developer'),
                    subtitle: Text('Jamshaid Niazi'),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.business_outlined, color: _accentColor),
                    title: Text('Developed by'),
                    subtitle: Text('Niazi Tech'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined, color: _accentColor),
                    title: const Text('Terms & Conditions'),
                    subtitle: const Text('View license and usage terms'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showTerms(context),
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




