import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../transaction/add_transaction_screen.dart';
import 'widgets/_header_section.dart';
import 'widgets/_quick_action_section.dart';
import 'widgets/_promotions_section.dart';
import './../account/account_screen.dart';
import './../transaction/transaction_screen.dart';
import './../category/category_screen.dart';
import './../statistical/statistical_screen.dart';
import './widgets/_contacts_section.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  const HomeScreen({super.key, required this.name});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late String userId = ''; // Initialize as empty string
  bool isLoading = true; // Flag to manage loading state

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeUserId(); // Initialize userId asynchronously
    _screens = [
      HomeTab(name: widget.name),
      const TransactionScreen(),
      const StatisticalScreen(),
      const CategoryScreen(),
      AccountScreen(),
    ];
  }

  // Asynchronous method to get the userId
  Future<void> _initializeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userData');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        userId = user['id'].toString(); // Set userId when fetched
        isLoading = false; // Set loading to false once the userId is set
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while waiting for userId
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: userId.isNotEmpty
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(userId: userId),
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      )
          : null,
      appBar: AppBar(
        title: Text(
          '${widget.name.isNotEmpty ? widget.name : 'Người dùng'}!',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_sharp),
            label: 'Thu/Chi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Danh mục',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}



class HomeTab extends StatelessWidget {
  final String name;
  const HomeTab({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 0, maxHeight: double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(name: name),
            const SizedBox(height: 20),
            const QuickActionSection(),
            const SizedBox(height: 20),
            const PromotionsSection(),
            const SizedBox(height: 20),
            const ContactScreen(),
          ],
        ),
      ),
    );
  }
}
