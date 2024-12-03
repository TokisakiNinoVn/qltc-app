import 'package:flutter/material.dart';
// import 'package:flutter_app_thucchien1/screens/favorite.dart';
// import './../constansts.dart';

//Screen
// import './../screens/cart/cart_screen.dart';
// import './../screens/details/details_screen.dart';
// import './../screens/home/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int cuttentIndex = 2;

  List screens = const [
    Scaffold(),
    // FavoriteScreen(),
    // HomeScreen(),
    // DetailsScreen(),
    // CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            cuttentIndex = 2;
          });
        },
        shape: const CircleBorder(),
        // backgroundColor: kprimaryColor,
        child: const Icon(
          Icons.home,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: Colors.white70,
        shadowColor: Colors.pink.withOpacity(0.4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 0;
                });
              },
              icon: const Icon(Icons.grid_view_outlined),
              iconSize: 30,
              // color: cuttentIndex == 0 ? kprimaryColor : Colors.grey.shade400,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 1;
                });
              },
              icon: const Icon(Icons.favorite_border),
              iconSize: 30,
              // color: cuttentIndex == 1 ? kprimaryColor : Colors.grey.shade400,
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 3;
                });
              },
              icon: const Icon(Icons.shopping_cart),
              iconSize: 30,
              // color: cuttentIndex == 3 ? kprimaryColor : Colors.grey.shade400,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 4;
                });
              },
              icon: const Icon(Icons.person),
              iconSize: 30,
              // color: cuttentIndex == 4 ? kprimaryColor : Colors.grey.shade400,
            ),
          ],
        ),
      ),
      body: screens[cuttentIndex],
    );
  }
}
