import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:link_on/screens/web3/web3_provider.dart';

class ImportWalletScreen extends StatefulWidget {
  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  final TextEditingController _privateKeyController = TextEditingController();

  Future<void> _importWallet() async {
    final privateKey = _privateKeyController.text.trim();
    try {
      if (privateKey.isEmpty) {
        _showDialog('Error', 'Please enter your private key.');
        return;
      }
      Provider.of<Web3Provider>(context, listen: false)
          .importWallet(context: context, privateKey: privateKey);
    } catch (e) {
      _showDialog('Error', 'An error occurred: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Import Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _privateKeyController,
              decoration: InputDecoration(
                labelText: 'Enter your private key',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Hide the private key input
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _importWallet,
              child: Text('Import Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}