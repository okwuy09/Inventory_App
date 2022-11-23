import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/ui/event/events_page.dart';
import 'package:viicsoft_inventory_app/ui/home_page.dart';
import 'package:viicsoft_inventory_app/ui/store/store_page.dart';

class MyButtomNavigationBar extends StatefulWidget {
  const MyButtomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyButtomNavigationBar> createState() => _MyButtomNavigationBarState();
}

class _MyButtomNavigationBarState extends State<MyButtomNavigationBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  static const List<Widget> _bodyView = <Widget>[
    HomePage(),
    EventsPage(),
    StorePage(),
  ];

  // ignore: unused_element
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  Widget _tabItem(Widget child, String label, {bool isSelected = false}) {
    return AnimatedContainer(
        height: 40,
        width: 111,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF7E9E8),
              ),
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            child,
            const SizedBox(
              width: 5,
            ),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ));
  }

  final List<String> _labels = ['Home', 'Events', 'Store'];

  @override
  Widget build(BuildContext context) {
    List<Widget> _icons = const [
      Icon(Icons.home),
      Icon(Icons.event),
      Icon(Icons.store)
    ];

    return Scaffold(
      body: Center(
        child: _bodyView.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 55,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            color: AppColor.white,
            child: TabBar(
                onTap: (x) {
                  setState(() {
                    _selectedIndex = x;
                  });
                },
                labelColor: const Color(0xFFB3261B),
                unselectedLabelColor: const Color(0xFFC4C4C4),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide.none,
                ),
                tabs: [
                  for (int i = 0; i < _icons.length; i++)
                    _tabItem(
                      _icons[i],
                      _labels[i],
                      isSelected: i == _selectedIndex,
                    ),
                ],
                controller: _tabController),
          ),
        ),
      ),
    );
  }
}
