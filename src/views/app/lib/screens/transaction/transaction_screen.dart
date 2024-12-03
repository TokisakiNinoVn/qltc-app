import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../services/modules/transaction_service.dart';
import 'edit_transaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TransactionService _transactionService = TransactionService();
  List<dynamic> _transactions = [];
  List<dynamic> _filteredTransactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      return user['id']?.toString();
    }
    return null;
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = "User not logged in!";
        });
        return;
      }

      final now = DateTime.now();
      final response =
      await _transactionService.getTransactionByMonthOfUser(userId, now.month);
      if (response.containsKey('error')) {
        setState(() {
          _isLoading = false;
          _error = response['error'];
        });
      } else {
        setState(() {
          _isLoading = false;
          _transactions = response['data'] ?? [];
          _filteredTransactions = _transactions;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _filterTransactions(String type) {
    setState(() {
      if (type == "All") {
        _filteredTransactions = _transactions;
      } else {
        _filteredTransactions =
            _transactions.where((t) => t['categoryType'] == type).toList();
      }
    });
  }

  Future<void> _deleteTransaction(String transactionId) async {
    final response = await _transactionService.deleteTransaction(transactionId);
    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response['error']}")),
      );
    } else {
      setState(() {
        _transactions.removeWhere((transaction) => transaction['id'] == transactionId);
        _filteredTransactions = _transactions;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction deleted successfully!")),
      );
    }
  }

  IconData _getCategoryIcon(String? categoryType) {
    switch (categoryType) {
      case "Chi":
        return FontAwesomeIcons.arrowCircleUp;
      case "Thu":
        return FontAwesomeIcons.arrowCircleDown;
      default:
        return FontAwesomeIcons.plusCircle;
    }
  }

  Color _getCategoryColor(String? categoryType) {
    switch (categoryType) {
      case "Chi":
        return Colors.red;
      case "Thu":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM, yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentMonth),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 30),
            onPressed: _fetchTransactions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Text("Error: $_error", style: const TextStyle(color: Colors.red)),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _filterTransactions("Chi"),
                  icon: const Icon(FontAwesomeIcons.arrowCircleUp),
                  label: const Text("Chi"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _filterTransactions("Thu"),
                  icon: const Icon(FontAwesomeIcons.arrowCircleDown),
                  label: const Text("Thu"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _filterTransactions("All"),
                  icon: const Icon(FontAwesomeIcons.list),
                  label: const Text("Tất cả"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _filteredTransactions[index];
                return Dismissible(
                  key: Key(transaction['id'].toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) {
                    setState(() {
                      _transactions
                          .removeWhere((t) => t['id'] == transaction['id']);
                      _filteredTransactions = _transactions;
                    });
                    _deleteTransaction(transaction['id'].toString());
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTransactionScreen(
                                transaction: transaction),
                          ),
                        );
                      },
                      leading: Icon(
                        _getCategoryIcon(transaction['categoryType']),
                        color: _getCategoryColor(transaction['categoryType']),
                      ),
                      title: Text(transaction['title'] ?? 'No Title'),
                      subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(transaction['createAt'])),
                          style: const TextStyle(fontSize: 12)),
                      trailing: Text(
                        '${transaction['amount']} \$',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(transaction['categoryType']),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
