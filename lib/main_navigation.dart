import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'assignment_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  
  @overide  

  State<MainNavigationScreen> createState() => _MainNavigationScreenState();

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final list<Widget> _screens = [
    const HomeScreen()
    const AssignmentListScreen(),

  ];

  void _onItemTapped (int index) {
    setState((){
      _selectedIndex = index;

    } );
  }
}
  @override
  Widget build(BuildContext){
    return Scaffold(
      body: _screens[_selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:_selectedIndex,
        onTap: _onItemTapped,
        items: const[
          BottomNavigationBarItem( 
            icon: Icon(Icons.home),
            Label: 'Home',
           ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label:'Assignments'
          ),
        ],
      ),
    );
  }
}