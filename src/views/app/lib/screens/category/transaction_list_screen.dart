import 'package:flutter/material.dart';

class TransactionListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionListScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách giao dịch"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(
                transaction['type'] == "Chi" ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                color: transaction['type'] == "Chi" ? Colors.red : Colors.green,
                size: 40,
              ),
              title: Text(
                transaction['title'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Số tiền: ${transaction['amount']}',
                style: TextStyle(color: transaction['type'] == "Chi" ? Colors.red : Colors.green),
              ),
            ),
          );
        },
      ),
    );
  }
}
