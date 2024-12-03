import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/modules/statistical_service.dart';

class StatisticalScreen extends StatefulWidget {
  const StatisticalScreen({super.key});

  @override
  _StatisticalScreenState createState() => _StatisticalScreenState();
}

class _StatisticalScreenState extends State<StatisticalScreen> {
  late Future<Map<String, dynamic>> statisticalData;
  int selectedMonth = DateTime.now().month;

  final List<String> months = [
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
  ];

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      return user['id']?.toString();
    }
    return null;
  }

  void _loadDataForMonth() async {
    final userId = await _getUserId();
    if (userId != null) {
      setState(() {
        statisticalData = ServicesService().getTransactionByMonthOfUser(userId, selectedMonth);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDataForMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Thống kê tháng $selectedMonth', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () async {
              int? month = await _selectMonthDialog(context);
              if (month != null) {
                setState(() {
                  selectedMonth = month;
                });
                _loadDataForMonth();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: statisticalData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {};
          if (data.isEmpty) {
            return const Center(child: Text('Không có dữ liệu.'));
          }

          final totalMoney = data['totalMoney'];
          final totalIncome = data['totalIncome'];
          final totalMoneyOut = data['totalMoneyOut'];
          final totalThu = data['totalThu'];
          final totalChi = data['totalChi'];
          final categories = data['totalCategoryMoney'] as List<dynamic>;

          final categoryNames = categories.map((category) => category['name'] as String).toList();
          final categoryMoney = categories.map((category) => double.parse(category['totalMoney'])).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatisticCard('Tổng tiền đã giao dịch', totalMoney, Colors.green, Icons.monetization_on),
                _buildStatisticCard('Tổng thu nhập', totalIncome, Colors.blue, Icons.account_balance_wallet),
                _buildStatisticCard('Tổng chi tiêu', totalMoneyOut, Colors.red, Icons.credit_card),
                const SizedBox(height: 20),
                _buildStatisticCard('Số thu', totalThu, Colors.blueGrey, Icons.arrow_upward),
                _buildStatisticCard('Số chi', totalChi, Colors.blueGrey, Icons.arrow_downward),
                const SizedBox(height: 20),
                const Text(
                  'Phân bổ theo danh mục',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 50,
                      sections: categoryMoney
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final value = entry.value;
                        return PieChartSectionData(
                          color: _getColorForIndex(index),
                          value: value,
                          title: '${categoryNames[index]}: ${value.toStringAsFixed(2)}',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: categoryNames
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final name = entry.value;
                      return TextSpan(
                        text: name + (index < categoryNames.length - 1 ? ', ' : ''),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getColorForIndex(index),
                        ),
                      );
                    })
                        .toList(),
                  ),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticCard(String label, dynamic value, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          value.toString(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  Future<int?> _selectMonthDialog(BuildContext context) {
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn tháng'),
        content: SingleChildScrollView(
          child: Column(
            children: List.generate(
              12,
                  (index) => ListTile(
                title: Text(months[index]),
                onTap: () {
                  Navigator.of(context).pop(index + 1);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
