
import 'package:echo/screens/home_page.dart';
import 'package:echo/features/search/pages/search_page.dart';
import 'package:echo/features/search/widgets/seach_bar.dart';
import 'package:echo/features/posts/pages/post_page.dart';
import 'package:echo/screens/my_profile_page.dart';
import 'package:flutter/material.dart';


class CustomBottomNavigatorBar extends StatelessWidget {
   CustomBottomNavigatorBar({super.key, required this.selectedIndex,});
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    
    return  Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
        decoration: const BoxDecoration(
    border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
  ),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        _buildNavItem(Icons.home_outlined, Icons.home,'Home', 0,
        (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        },)
        );
        }
        ),
        _buildNavItem(Icons.search, Icons.search_off,'Appointment', 1,
        (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return SearchPage();
        },)
        );
        }),
      _buildNavItem(Icons.edit_note, Icons.edit_note,'Post', 2,
        (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return PostPage();
        },)
        );
        }),
        _buildNavItem(Icons.person_outline, Icons.person,'Post', 2,
        (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return ProfilePage();
        },)
        );
        }),
      ]
      ),
       );
  }
Widget _buildNavItem(IconData iconNotSelected,IconData iconSelected,String label,int index,VoidCallback onTap){
  bool isSelected =selectedIndex==index;
  Color itemColor=Colors.white;
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
     isSelected? Icon(iconSelected, color: itemColor, size: 26):Icon(iconNotSelected, color: itemColor, size: 26),
          const SizedBox(height: 4),
          
    ],),
  );
}
  }