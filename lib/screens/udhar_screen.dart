import 'package:flutter/material.dart';

class UdharScreen extends StatefulWidget {
  const UdharScreen({super.key});

  @override
  State<UdharScreen> createState() => _UdharScreenState();
}

class _UdharScreenState extends State<UdharScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Udhar & Credit Management'),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credit Ledger',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  'No credit records found.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
