// import 'package:flutter/material.dart';
// import 'package:jobbiteproject/views/businness/jobspage.dart';
// import 'package:jobbiteproject/views/businness/workplacespage.dart';
// import 'package:jobbiteproject/views/businness/applicationspage.dart';
// import 'package:jobbiteproject/views/businness/businessprofilepage.dart';
// import 'package:jobbiteproject/views/customappbar.dart';
// import 'package:bottom_navy_bar/bottom_navy_bar.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: BusinnessMainPage1(),
//   ));
// }

// class BusinnessMainPage1 extends StatefulWidget {
//   const BusinnessMainPage1({super.key});

//   @override
//   State<BusinnessMainPage1> createState() => _BusinnessMainPage1State();
// }

// class _BusinnessMainPage1State extends State<BusinnessMainPage1> {
//   int _selectedIndex = 0;
//   late PageController pageController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     pageController = PageController();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     pageController.dispose();
//     super.dispose();
//   }

//   final List<Widget> _widgetOptions = <Widget>[WorkplacesPage(), JobsPage(), ApplicationsPage(), BusinessProfilePage()];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             appBar: CustomAppBar(backButton: false),
//             body: SizedBox.expand(
//               child: PageView(
//                   controller: pageController,
//                   onPageChanged: (index) {
//                     setState(() {
//                       _selectedIndex = index;
//                     });
//                   },
//                   children: _widgetOptions),
//             ),
//             bottomNavigationBar: BottomNavyBar(
//               selectedIndex: _selectedIndex,
//               items: [
//                 BottomNavyBarItem(icon: const Icon(Icons.add_business), title: const Text('İşyeri Ekle')),
//                 BottomNavyBarItem(icon: const Icon(Icons.add_box), title: const Text('İlan Ekle')),
//                 BottomNavyBarItem(icon: const Icon(Icons.app_blocking_sharp), title: const Text('Başvurular')),
//                 BottomNavyBarItem(icon: const Icon(Icons.account_circle), title: const Text('Profil')),
//               ],
//               onItemSelected: (index) {
//                 setState(() {
//                   pageController.jumpToPage(index);
//                 });
//               },
//             ) /*BottomNavigationBar(
//               items: const <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.add_business),
//                   label: 'İşyeri Ekle',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.add_box),
//                   label: 'İlan Ekle',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.app_blocking_sharp),
//                   label: 'Başvurular',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.account_circle),
//                   label: 'Profil',
//                 ),
//               ],
//               currentIndex: _selectedIndex,
//               selectedItemColor: Colors.blue,
//               unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
//               onTap: _onItemTapped,
//             ),*/
//             ));
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Profil sayfasından dönüş yapıldıysa ve _selectedIndex henüz güncellenmediyse
//     if (ModalRoute.of(context)?.settings.arguments == 3 && _selectedIndex != 3) {
//       setState(() {
//         _selectedIndex = 3; // Profil sayfasına yönlendir
//       });
//     }
//   }
// }
